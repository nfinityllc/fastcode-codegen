package com.nfinity.entitycodegen;

import java.io.File;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;


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

	public static Map<String, EntityDetails> generateEntities(String connectionString, String schema,
			List<String> tableList, String packageName, String destination, Boolean audit) {

		Map<String, String> connectionProps = parseConnectionString(connectionString);
		String entityPackage = packageName + ".domain.model";
		final String tempPackageName = entityPackage.concat(".Temp");
		destination = destination.replace('\\', '/');
		final String destinationPath = destination.concat("/src/main/java");
		final String targetPath = destination.concat("/target/classes");
		String tables = "";
		if (tableList != null) {
			for (int i = 0; i < tableList.size(); i++) {
				if (!tableList.get(i).isEmpty()) {
					if (i < tableList.size() - 1)
						tables = tables + schema.concat("." + tableList.get(i) + ",");
					else
						tables = tables + schema.concat("." + tableList.get(i));
				}
			}
		}

		if (!tables.isEmpty()) {
			ReverseMapping.run(tempPackageName, destinationPath, tables, connectionProps);
		} else
			ReverseMapping.run(tempPackageName, destinationPath, schema, connectionProps);
		try {
			Thread.sleep(28000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		try {
			BaseAppGen.CompileApplication(destination);
			deleteFile(destinationPath + "/orm.xml");
		} catch (Exception e) {
			System.out.println("Compilation Error");
			e.printStackTrace();
		}
		CGenClassLoader loader = new CGenClassLoader(targetPath);

		ArrayList<Class<?>> entityClasses;
		Map<String, EntityDetails> entityDetailsMap = new HashMap<>();
		Map<String,FieldDetails> descriptiveFieldEntities = new HashMap<>();
		List<String> compositePrimaryKeyEntities = new ArrayList<String>();
		try {
			entityClasses = loader.findClasses(tempPackageName);

			List<Class<?>> classList = filterOnlyRelevantEntities(entityClasses);// classDetails.getClassesList();
			compositePrimaryKeyEntities=findCompositePrimaryKeyClasses(entityClasses);			

			for (Class<?> currentClass : classList) {
				String entityName = currentClass.getName();
				
				// process each entities except many to many association entities
				if (!entityName.endsWith("Id")) {
				
					EntityDetails details = EntityDetails.retreiveEntityFieldsAndRships(currentClass, entityName, classList);// GetEntityDetails.getDetails(currentClass,
					details.setCompositeKeyClasses(compositePrimaryKeyEntities);

					Map<String, RelationDetails> relationMap = details.getRelationsMap();
					relationMap = EntityDetails.FindOneToManyJoinColFromChildEntity(relationMap, classList);

					// Get parent descrptive fields from user
					for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {
                         
                        if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName()) || descriptiveFieldEntities.containsKey(entry.getValue().getcName())))
						{
							descriptiveFieldEntities = entry.getValue().FindAndSetDescriptiveField(descriptiveFieldEntities);
						}
            
					}

					details.setRelationsMap(relationMap);
					details.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
					entityDetailsMap.put(entityName.substring(entityName.lastIndexOf(".") + 1), details);
					// Generate Entity based on template
					EntityGenerator.Generate(entityName, details, schema, packageName, destinationPath, audit,compositePrimaryKeyEntities);

				}
			}
		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();
		}

	//	deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/"));
		System.out.println(" exit ");

		return entityDetailsMap;
	}

	public static void Generate(String entityName, EntityDetails entityDetails, String schemaName, String packageName,
			String destPath, Boolean audit,List<String> compositePrimaryKeyEntities) {

		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("CommonModulePackage", packageName.concat(".CommonModule"));
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("SchemaName", schemaName);
		root.put("Audit", audit);

		setTemplateLoader();
 
		Map<String, FieldDetails> actualFieldNames = entityDetails.getFieldsMap();
		Map<String, RelationDetails> relationMap = entityDetails.getRelationsMap();
		Map<String,String> primaryKeys= new HashMap<>();
		root.put("Fields", actualFieldNames);
		
		root.put("Relationship", relationMap);
		for (Map.Entry<String, FieldDetails> entry : actualFieldNames.entrySet()) {
			if(entry.getValue().getIsPrimaryKey())
			{
				if(entry.getValue().getFieldType().equalsIgnoreCase("long"))
				primaryKeys.put(entry.getValue().getFieldName(),"Long");
				else
			    primaryKeys.put(entry.getValue().getFieldName(), entry.getValue().getFieldType());
			}
		}

		root.put("PrimaryKeys", primaryKeys);
		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";

		
		generateEntity(root, destinationFolder);
		if (compositePrimaryKeyEntities.contains(className)) {
			generateIdClass(root, destinationFolder);
		}
	
	}

	private static void generateEntity(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		generateFiles(getEntityTemplate(root.get("ClassName").toString()), root, destPath);
	}
	
	private static void generateIdClass(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		generateFiles(getIdClassTemplate(root.get("ClassName").toString()), root, destPath);
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
	
	private static Map<String, Object> getIdClassTemplate(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("idClass.java.ftl", className + "Id.java");
		return backEndTemplate;
	}

	public static void generateAuditEntity(String destPath, String packageName) {
		setTemplateLoader();
		Map<String, Object> backEndTemplate = new HashMap<>();
		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		backEndTemplate.put("audit.java.ftl", "AuditedEntity.java");
		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/Audit";
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

	public static List<Class<?>> filterOnlyRelevantEntities(ArrayList<Class<?>> entityClasses) {
//		List<Class<?>> otherEntities = entityClasses.stream().filter((e) -> e.getName().endsWith("Id"))
//				.collect(Collectors.toList());
		List<Class<?>> relevantEntities = entityClasses.stream()
				.filter((e) -> !(e.getName().endsWith("Id$Tokenizer")))
				.collect(Collectors.toList());
//		for (Class<?> currentClass : otherEntities) {
//			String className = currentClass.getName().substring(0, currentClass.getName().indexOf("Id"));
//			Class<?> entity = relevantEntities.stream().filter((r) -> r.getName().endsWith(className)).findAny().orElse(null);
//			if (entity == null)
//				relevantEntities.add(currentClass);
//
//		}
		return relevantEntities;
	}

	public static List<String> findCompositePrimaryKeyClasses(ArrayList<Class<?>> entityClasses) {
		 List<String> compositeKeyEntities = new ArrayList<>(); 
	        List<Class<?>> otherEntities = entityClasses.stream().filter((e) -> e.getName().endsWith("Id")) 
	                .collect(Collectors.toList()); 
	        List<Class<?>> relevantEntities = entityClasses.stream() 
	                .filter((e) -> !(e.getName().endsWith("Id") || e.getName().endsWith("Id$Tokenizer"))) 
	                .collect(Collectors.toList()); 
	        for (Class<?> currentClass : otherEntities) { 
	            String className = currentClass.getName().substring(0, currentClass.getName().indexOf("Id")); 
	            Class<?> entity = relevantEntities.stream().filter((r) -> r.getName().endsWith(className)).findAny().orElse(null); 
	            if (entity != null) 
	            {
	            	
	            	compositeKeyEntities.add(className.substring(className.lastIndexOf(".")+1));
	            }
	        } 
	        return compositeKeyEntities; 
	}

	public static Map<String, String> parseConnectionString(String connectionString) {
		Map<String, String> connectionStringMap = new HashMap<String, String>();

		String[] urlArr = connectionString.split("\\?");
		connectionStringMap.put("url", urlArr[0]);

		String[] paramsArr = urlArr[1].split("\\;");
		for (String param : paramsArr) {
			String[] paramArr = param.split("\\=");
			connectionStringMap.put(paramArr[0], paramArr[1]);
		}

		return connectionStringMap;
	}
}
