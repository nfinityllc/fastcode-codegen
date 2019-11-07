package com.nfinity.entitycodegen;

import java.io.File;
import java.io.PrintWriter;
import java.text.MessageFormat;
import java.util.*;
import java.util.stream.Collectors;

import com.nfinity.codegen.AuthenticationClassesTemplateGenerator;
import com.nfinity.codegen.CodegenApplication;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;

public class EntityGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static String TEMPLATE_FOLDER = "/templates";
	public static void setTemplateLoader() {

		ClassTemplateLoader ctl = new ClassTemplateLoader(EntityGenerator.class, TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] {ctl};
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(mtl);
	}

	public static Map<String, EntityDetails> generateEntities(String connectionString, String schema,
			List<String> tableList, String packageName, String destination, Boolean history, Boolean flowable, String authenticationTable, String authenticationType) { 
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
					Map<String, RelationDetails> relationMap = details.getRelationsMap();
					details.setCompositeKeyClasses(compositePrimaryKeyEntities);

					relationMap = EntityDetails.FindOneToManyJoinColFromChildEntity(relationMap, classList);
					relationMap = EntityDetails.FindOneToOneJoinColFromChildEntity(relationMap, classList);
					// Get parent descrptive fields from user
					for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {

						if(entry.getValue().getRelation().equals("OneToOne") && !entry.getValue().getIsParent())
						{
							if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName())))
							{
								descriptiveFieldEntities = entry.getValue().FindAndSetDescriptiveField(descriptiveFieldEntities);
							}
						}
						else if(entry.getValue().getRelation().equals("ManyToOne"))
						{
							if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName()) || descriptiveFieldEntities.containsKey(entry.getValue().getcName())))
							{
								descriptiveFieldEntities = entry.getValue().FindAndSetDescriptiveField(descriptiveFieldEntities);
							}
						}
					}

					details.setRelationsMap(relationMap);
					details.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
					entityDetailsMap.put(entityName.substring(entityName.lastIndexOf(".") + 1), details);
					// Generate Entity based on template
					EntityGenerator.Generate(entityName, details, schema, packageName, destinationPath,compositePrimaryKeyEntities,authenticationTable,authenticationType);

				}
			}

			if(authenticationTable !=null  && authenticationType != "none")
			{
				entityDetailsMap=validateAuthenticationTable(entityDetailsMap, authenticationTable, flowable);
			}
			if(authenticationType !="none")
			{
				EntityGenerator.GenerateAutheticationEntities(entityDetailsMap, schema, packageName, destinationPath,authenticationTable,authenticationType);

			}

		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();
		}

		deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/"));
		System.out.println(" exit ");

		return entityDetailsMap;
	}

	public static Map<String,EntityDetails> validateAuthenticationTable(Map<String,EntityDetails> entityDetailsMap, String authenticationTable, Boolean flowable)
	{
		Boolean isTableExits=false;
		if(entityDetailsMap!=null)
		{
			if(entityDetailsMap.containsKey(authenticationTable)) {
				isTableExits=true;
			}
			Scanner scanner = new Scanner(System.in);
			while(!isTableExits)
			{
				System.out.println(" INVALID AUTHORIZATION SCHEMA ");
				System.exit(0);
			}

			return getAuthenticationTableFieldsMapping(entityDetailsMap, authenticationTable, flowable, scanner);
		}
		return entityDetailsMap;
	}

	public static Map<String,EntityDetails> getAuthenticationTableFieldsMapping(Map<String,EntityDetails> entityDetails, String authenticationTable, Boolean flowable, Scanner scanner)
	{
		Map<String,FieldDetails> authFields=new HashMap<String, FieldDetails>();
		authFields.put("UserName", null);
		authFields.put("Password", null);
		if(flowable) {
			authFields.put("FirstName", null);
			authFields.put("LastName", null);
			authFields.put("EmailAddress", null);
		}

		for(Map.Entry<String,EntityDetails> entry: entityDetails.entrySet())
		{
			if(entry.getKey().equals(authenticationTable))
			{

				List<FieldDetails> fieldsList = new ArrayList<>();
				for(Map.Entry<String,FieldDetails> fieldsEntry: entry.getValue().getFieldsMap().entrySet())
				{
					if (fieldsEntry.getValue().fieldType.equalsIgnoreCase("long") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("integer") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("double")
							|| fieldsEntry.getValue().fieldType.equalsIgnoreCase("short") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("string") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("boolean")
							|| fieldsEntry.getValue().fieldType.equalsIgnoreCase("timestamp") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("date"))
						fieldsList.add(fieldsEntry.getValue());
				}
				for(Map.Entry<String,FieldDetails> authFieldsEntry: authFields.entrySet())
				{
					int i = 1;
					StringBuilder b = new StringBuilder();
					for (FieldDetails f : fieldsList) {
						b.append(MessageFormat.format("{0}.{1} ", i, f.getFieldName()));
						i++;
					}
					System.out.println("\n Select field you want to map on "+ authFieldsEntry.getKey()+" by typing its corresponding number : ");
					System.out.println(b.toString());
					i = scanner.nextInt();
					while (i < 1 || i > fieldsList.size()) {
						System.out.println("\nInvalid Input \nEnter again :");
						i = scanner.nextInt();
					}
					FieldDetails selected=fieldsList.get(i - 1);
					while(!selected.getFieldType().equalsIgnoreCase("String"))
					{
						System.out.println("Please choose valid string field : ");
						i = scanner.nextInt();
						while (i < 1 || i > fieldsList.size()) {
							System.out.println("\nInvalid Input \nEnter again : ");
							i = scanner.nextInt();
						}
						selected=fieldsList.get(i - 1);
					}
					fieldsList.remove(i-1);
					authFields.replace(authFieldsEntry.getKey(), selected);

				}

				entry.getValue().setAuthenticationFieldsMap(authFields);
			}
		}

		return entityDetails;
	}

	public static void GenerateAutheticationEntities(Map<String,EntityDetails> entityDetails, String schemaName, String packageName,
			String destPath, String authenticationTable,String authenticationType) {

		Map<String,FieldDetails> primaryKeys= new HashMap<>();
		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		root.put("CommonModulePackage" , packageName.concat(".CommonModule"));
		root.put("AuthenticationType",authenticationType);
		root.put("SchemaName",schemaName);
		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}

		setTemplateLoader();

		for(Map.Entry<String,EntityDetails> entry : entityDetails.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			if(className.equalsIgnoreCase(authenticationTable))
			{
				root.put("ClassName", className);
				root.put("TableName", entry.getValue().getEntityTableName());
				root.put("CompositeKeyClasses",entry.getValue().getCompositeKeyClasses());
				root.put("Fields", entry.getValue().getFieldsMap());
				root.put("AuthenticationFields", entry.getValue().getAuthenticationFieldsMap());
				for (Map.Entry<String, FieldDetails> entryFields : entry.getValue().getFieldsMap().entrySet()) {
					if(entryFields.getValue().getIsPrimaryKey())
					{
						System.out.println(" primary key " + entryFields.getValue().getFieldName());
						primaryKeys.put(entryFields.getValue().getFieldName(), entryFields.getValue());
					}
				}
				root.put("PrimaryKeys", primaryKeys);
			}
		}

		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";

		generateFiles(AuthenticationClassesTemplateGenerator.getAuthenticationEntitiesTemplates(authenticationType,authenticationTable), root, destinationFolder);
	}

	public static void Generate(String entityName, EntityDetails entityDetails, String schemaName, String packageName,
			String destPath, List<String> compositePrimaryKeyEntities,String authenticationTable,String authenticationType) {

		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("CommonModulePackage", packageName.concat(".CommonModule"));
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("TableName", entityDetails.getEntityTableName());
		root.put("SchemaName", schemaName);
		root.put("AuthenticationType",authenticationType);
		if(authenticationTable !=null)
			root.put("AuthenticationTable", authenticationTable);
		else
			root.put("AuthenticationTable", "User");
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());

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
		backEndTemplate.put("entityTemplate/entity.java.ftl", className + "Entity.java");
		return backEndTemplate;
	}

	private static Map<String, Object> getIdClassTemplate(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entityTemplate/idClass.java.ftl", className + "Id.java");
		return backEndTemplate;
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
		List<Class<?>> relevantEntities = entityClasses.stream()
				.filter((e) -> !(e.getName().endsWith("Id$Tokenizer") || e.getName().endsWith("JvCommit") || e.getName().endsWith("JvCommitProperty") || e.getName().endsWith("JvCommitPropertyId") || e.getName().endsWith("JvSnapshot") || e.getName().endsWith("JvGlobalIdent")  ))
				.collect(Collectors.toList());
		return relevantEntities;
	}

	public static List<String> findCompositePrimaryKeyClasses(ArrayList<Class<?>> entityClasses) {
		List<String> compositeKeyEntities = new ArrayList<>(); 
		List<Class<?>> otherEntities = entityClasses.stream().filter((e) -> e.getName().endsWith("Id")) 
				.collect(Collectors.toList()); 
		List<Class<?>> relevantEntities = entityClasses.stream() 
				.filter((e) -> !(e.getName().endsWith("Id") || e.getName().endsWith("Id$Tokenizer") || e.getName().endsWith("JvCommit") || e.getName().endsWith("JvCommitProperty") || e.getName().endsWith("JvCommitPropertyId") || e.getName().endsWith("JvSnapshot") || e.getName().endsWith("JvGlobalIdent"))) 
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

		if(!urlArr[1].isEmpty()) {
			String[] paramsArr = urlArr[1].split("\\;");
			for (String param : paramsArr) {
				String[] paramArr = param.split("\\=");
				connectionStringMap.put(paramArr[0], paramArr[1]);
			}
		}

		return connectionStringMap;
	}
}
