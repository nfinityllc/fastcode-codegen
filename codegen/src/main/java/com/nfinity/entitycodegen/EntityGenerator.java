package com.nfinity.entitycodegen;

import java.io.File;
import java.io.PrintWriter;
import java.util.*;

import freemarker.template.Configuration;
import freemarker.template.Template;

import freemarker.cache.ClassTemplateLoader;

public class EntityGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);

	public static void setTemplateLoader() {
		ClassTemplateLoader ctl = new ClassTemplateLoader(new EntityGenerator().getClass(), "/templates/entityTemplate");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(ctl);
	}

	public static Map<String,EntityDetails> generateEntities(String connectionString, String schema,List<String> tableList, String packageName, String destination,
			Boolean audit) {

		Map<String,String> connectionProps = parseConnectionString(connectionString);
		String entityPackage = packageName + ".domain.model";
		final String tempPackageName = entityPackage.concat(".Temp"); 
		destination = destination.replace('\\', '/');
		final String destinationPath = destination.concat("/src/main/java"); 
		final String targetPath = destination.concat("/target/classes"); 
		String tables="";
		if(tableList !=null)
		{
			for(int i=0;i<tableList.size();i++)
			{
				if(!tableList.get(i).isEmpty())
				{
					if(i<tableList.size()-1)
						tables= tables + schema.concat("." + tableList.get(i) + ",");
					else
						tables= tables + schema.concat("." + tableList.get(i) );
				}
			}
		}

		if(!tables.isEmpty())
		{
			ReverseMapping.run(tempPackageName, destinationPath, tables, connectionProps); 
		}
		else
			ReverseMapping.run(tempPackageName, destinationPath, schema, connectionProps); 
		try {
			Thread.sleep(28000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		try {
			BaseAppGen.CompileApplication(destination);
			deleteFile(destinationPath + "/orm.xml");
			//Utils.runCommand("mvn compile", destination);
		} catch (Exception e) {
			System.out.println("Compilation Error");
			e.printStackTrace();
		}
		CGenClassLoader loader = new CGenClassLoader(targetPath);

		ArrayList<Class<?>> entityClasses;
		Map<String,EntityDetails> entityDetailsMap = new HashMap<>();
		Map<String,FieldDetails> descriptiveMap = new HashMap<>();
		List<String> relationInputList=new ArrayList<String>();
		try {
			entityClasses = loader.findClasses(tempPackageName);
			ClassDetails classDetails = getClasses(entityClasses);
			List<Class<?>> classList = classDetails.getClassesList();
			List<String> relationClassList = classDetails.getRelationClassesList();
			relationInputList = GetUserInput.getRelationInput(classList, relationClassList, destination,
					tempPackageName);

			
			for (Class<?> currentClass : classList) {
				String entityName = currentClass.getName();
				if (!relationClassList.contains(entityName)) {
					EntityDetails details = GetEntityDetails.getDetails(currentClass, entityName, classList);
					details.setRelationInput(relationInputList);
					
					Map<String,RelationDetails> relationMap =details.getRelationsMap();
				    relationMap=GetEntityDetails.setJoinColumn(relationMap, classList);
				    for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {
				    	if (entry.getValue().getRelation() == "ManyToOne" || entry.getValue().getRelation() == "ManyToMany") {
				    		FieldDetails descriptiveField=null;
				    		if(entry.getValue().getRelation() == "ManyToMany")
				    		{
				    			for(String str : relationInputList)
				    			{
				    				int indexOfDash = str.indexOf('-');
				    				String before = str.substring(0, indexOfDash);
				    				if(before.equals(entry.getValue().geteName()))
				    				{
				    					descriptiveField = GetUserInput.getEntityDescriptionField(entry.getValue().geteName(),
												entry.getValue().getfDetails());
				    				}
				    			}
				    		}
				    		else
				    		{
							 descriptiveField = GetUserInput.getEntityDescriptionField(entry.getValue().geteName(),
									entry.getValue().getfDetails());
				    		}
				    		if(descriptiveField!=null)
				    		{
							entry.getValue().setEntityDescriptionField(descriptiveField);
							descriptiveMap.put(entry.getKey() ,entry.getValue().getEntityDescriptionField());
				    		}
						}
				    }
				    details.setRelationsMap(relationMap);
				    entityDetailsMap.put(entityName.substring(entityName.lastIndexOf(".") + 1),details);

					EntityGenerator.Generate(entityName, details, schema, packageName, destinationPath, audit);

				}

			}
		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();

		}

		if (audit) {
			EntityGenerator.generateAuditEntity(destinationPath, packageName);
		} 

		//deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/"));
		System.out.println(" exit ");
		return setDescriptiveField(entityDetailsMap,descriptiveMap,relationInputList);
	}
	
	public static Map<String,EntityDetails> setDescriptiveField(Map<String,EntityDetails> entityDetailsMap, Map<String,FieldDetails> descriptiveMap,List<String> relationInputList)
	{
	    for (Map.Entry<String, EntityDetails> details : entityDetailsMap.entrySet()) {
	    Map<String,RelationDetails>  relationMap =details.getValue().getRelationsMap();
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {
			if(entry.getValue().getRelation()=="OneToMany" || entry.getValue().getRelation()=="ManyToMany")
			{
				for(Map.Entry<String, FieldDetails> str: descriptiveMap.entrySet())
				{
				int indexOfDash = str.getKey().indexOf('-');
				String before = str.getKey().substring(0, indexOfDash);
				String after = str.getKey().substring(indexOfDash + 1);
				if(entry.getValue().getRelation()=="ManyToMany")
				{
					for(String input : relationInputList)
	    			{
	    				int index = input.indexOf('-');
	    				String parent = input.substring(0, index);
	    				if(parent.equals(after))
	    				{
	    					if(after.equals(entry.getValue().getcName()) && before.equals(entry.getValue().geteName())
	    							&& str.getKey() !=null)
	    					{
	    					  entry.getValue().setEntityDescriptionField(str.getValue());
	    					}
	    							
	    				}
	    			}
				}
				else
				{
				if(after.equals(entry.getValue().getcName()) && before.equals(entry.getValue().geteName())
						&& str.getKey() !=null)
				{
				  entry.getValue().setEntityDescriptionField(str.getValue());
				}
				}
				}
			}
			
		}
		details.getValue().setRelationsMap(relationMap);
	    }
	    
	    return entityDetailsMap;
	}

	public static void Generate(String entityName, EntityDetails entityDetails, String schemaName, String packageName,
			String destPath, Boolean audit) {

		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");

		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("RelationInput", entityDetails.getRelationInput());
		root.put("SchemaName", schemaName);
		root.put("Audit", audit);


		setTemplateLoader();

		Map<String, FieldDetails> actualFieldNames = entityDetails.getFieldsMap();
		Map<String, RelationDetails> relationMap = entityDetails.getRelationsMap();
		root.put("Fields", actualFieldNames);
		root.put("Relationship", relationMap);

		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";
		generateEntity(root, destinationFolder);

	}

	private static void generateEntity(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		generateFiles(getEntityTemplate(root.get("ClassName").toString()), root, destPath);
	}

	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());
				File fileName = null;
				fileName = new File(destPath + "/" + entry.getValue().toString());
				PrintWriter writer = new PrintWriter(fileName);
				template.process(root, writer);
				writer.flush();

			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}

	private static Map<String, Object> getEntityTemplate(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entity.java.ftl", className + "Entity.java");
		return backEndTemplate;
	}

	public static void generateAuditEntity(String destPath, String packageName) {
		setTemplateLoader();
		Map<String, Object> backEndTemplate = new HashMap<>();
		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		backEndTemplate.put("audit.java.ftl", "AuditedEntity.java");
		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/")+ "/Audit";
		new File(destinationFolder).mkdirs();
		generateFiles(backEndTemplate, root, destinationFolder);

	}

	public static void deleteFile(String directory) {
		File file = new File(directory);
		if (file.exists()) {
			file.delete();
		}
	}

	public static void deleteDirectory(String directory) {
		File file = new File(directory);
		File[] contents = file.listFiles();
		if (contents != null) {
			for (File f : contents) {
				if (f.isDirectory())
					deleteDirectory(f.getAbsolutePath());
				else
					f.delete();
			}
		}
		file.delete();
	}

	public static ClassDetails getClasses(ArrayList<Class<?>> entityClasses) {
		List<String> entityClassNames = new ArrayList<>();
		for (Class<?> currentClass : entityClasses) {
			String entityName = currentClass.getName();
			entityClassNames.add(entityName);
		}

		List<String> relationClass = new ArrayList<>();
		List<Class<?>> classList = new ArrayList<>();

		for (Class<?> currentClass : entityClasses) {
			String entityName = currentClass.getName();
			if (entityName.contains("Id")) {
				if (!entityName.contains("Tokenizer")) {
					String className = entityName.substring(0, entityName.indexOf("Id"));

					if (!entityClassNames.contains(className))
						classList.add(currentClass);
					else
						relationClass.add(className);
				}
			} else {
				classList.add(currentClass);
			}
		}
		return new ClassDetails(classList, relationClass);
	}

	public static Map<String,String> parseConnectionString(String connectionString){
		Map<String,String> connectionStringMap = new HashMap<String,String>();

		String[] urlArr = connectionString.split("\\?");
		connectionStringMap.put("url", urlArr[0]);

		String[] paramsArr = urlArr[1].split("\\;");
		for(String param:paramsArr) {
			String[] paramArr = param.split("\\=");
			connectionStringMap.put(paramArr[0], paramArr[1]);
		}

		return connectionStringMap;
	}
}
