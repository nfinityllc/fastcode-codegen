package com.nfinity.entitycodegen;
import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import freemarker.template.Configuration;
import freemarker.template.Template;

import freemarker.cache.ClassTemplateLoader;

public class EntityGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);

	public static void setTemplateLoader()
	{
		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, "/templates/");
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(ctl);
	}

	public static void Generate(String entityName,EntityDetails entityDetails,String schemaName,String packageName,String destPath,List<String> relationInput,Boolean audit,String auditPackage) {

		String className = entityName.substring(entityName.lastIndexOf(".")+1);
		String entityClassName = className.concat("Entity");

		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityClassName );
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("RelationInput", relationInput);
		root.put("SchemaName" , schemaName);
		root.put("Audit", audit);
		root.put("AuditPackage", auditPackage);
		

		setTemplateLoader();

		Map<String,FieldDetails> actualFieldNames= entityDetails.getFieldsMap();
		Map<String,RelationDetails> relationMap = entityDetails.getRelationsMap();
		root.put("Fields", actualFieldNames);
		root.put("Relationship", relationMap);

		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/");  
		generateEntity(root, destinationFolder);

	}

	private static void generateEntity(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		generateFiles(getEntityTemplate(root.get("ClassName").toString()), root, destPath);
	}

	private static void generateFiles(Map<String,Object> templateFiles,Map<String,Object> root, String destPath){
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());
				File fileName=null;
				fileName = new File(destPath + "/" +   entry.getValue().toString());
				PrintWriter writer = new PrintWriter(fileName);
				template.process(root, writer);
				writer.flush();

			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}

	private static Map<String,Object> getEntityTemplate(String className){

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entity.java.ftl", className + "Entity.java");
		return backEndTemplate;
	}
	
	public static void generateAuditEntity(String destPath,String packageName)
	{
		setTemplateLoader();
		Map<String, Object> backEndTemplate = new HashMap<>();
		Map<String, Object> root= new HashMap<>();
		root.put("PackageName",packageName);
		backEndTemplate.put("audit.java.ftl","AuditedEntity.java");
		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/");  
		new File(destinationFolder).mkdirs();
		generateFiles(backEndTemplate,root, destinationFolder);
		
	}
	
}
