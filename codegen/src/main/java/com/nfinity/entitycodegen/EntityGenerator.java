package com.nfinity.entitycodegen;

import static java.util.Map.Entry.comparingByKey;
import static java.util.stream.Collectors.toMap;

import java.io.File;
import java.io.PrintWriter;
import java.text.MessageFormat;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nfinity.codegen.AuthenticationClassesTemplateGenerator;
import com.nfinity.codegen.CodeGeneratorUtils;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;

@Component
public class EntityGenerator {

	
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	final static String TEMPLATE_FOLDER = "/templates";
	final static String ENTITIES_TEMPLATE_FOLDER = "/templates/backendTemplates/entities";
	
	@Autowired
	BaseAppGen baseAppGen;
//	public static void setTemplateLoader() {
//
//		ClassTemplateLoader ctl = new ClassTemplateLoader(EntityGenerator.class, TEMPLATE_FOLDER + "/");
//		TemplateLoader[] templateLoadersArray = new TemplateLoader[] {ctl};
//		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
//		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
//		cfg.setDefaultEncoding("UTF-8");
//		cfg.setTemplateLoader(mtl);
//	}

	public Map<String, EntityDetails> generateEntities(String connectionString, String schema,
			List<String> tableList, String packageName, String destination, String authenticationTable, String authenticationType) { 
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

		//processAndGenerateRelevantEntities()
		try {
			baseAppGen.CompileApplication(destination);
			deleteFile(destinationPath + "/orm.xml");
		} catch (Exception e) {
			System.out.println("Compilation Error");
			e.printStackTrace();
		}
		
		Map<String, EntityDetails> entityDetailsMap = processAndGenerateRelevantEntities(targetPath, tempPackageName, schema, packageName, destinationPath, authenticationType, authenticationTable);
		deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/"));
		System.out.println(" exit ");

		return entityDetailsMap;
	}
	
	public Map<String, EntityDetails> processAndGenerateRelevantEntities(String targetPath, String tempPackageName,String schema,String packageName, String destinationPath, String authenticationType, String authenticationTable)
	{
		CGenClassLoader loader = new CGenClassLoader(targetPath);

		ArrayList<Class<?>> entityClasses;
		Map<String, EntityDetails> entityDetailsMap = new HashMap<>();
		
		List<String> compositePrimaryKeyEntities = new ArrayList<String>();
		try {
			entityClasses = loader.findClasses(tempPackageName);

			List<Class<?>> classList = filterOnlyRelevantEntities(entityClasses);// classDetails.getClassesList();
			compositePrimaryKeyEntities=findCompositePrimaryKeyClasses(entityClasses);			

			for (Class<?> currentClass : classList) {
				String entityName = currentClass.getName();
				String className = entityName.substring(entityName.lastIndexOf(".") + 1);

				// process each entities except many to many association entities
				if (!entityName.endsWith("Id")) {

					EntityDetails details = EntityDetails.retreiveEntityFieldsAndRships(currentClass, entityName, classList);// GetEntityDetails.getDetails(currentClass,
					Map<String, RelationDetails> relationMap = details.getRelationsMap();
					details.setCompositeKeyClasses(compositePrimaryKeyEntities);
					details.setPrimaryKeys(getPrimaryKeysFromMap(details.getFieldsMap()));
					relationMap = EntityDetails.FindOneToManyJoinColFromChildEntity(relationMap, classList);
					relationMap = EntityDetails.FindOneToOneJoinColFromChildEntity(relationMap, classList);
				
					//get descriptive fields
					details=setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(relationMap,details, className);
					details.setRelationsMap(relationMap);
					if(className.concat("Id") != details.getIdClass()) {
						details=updateFieldsListInRelationMap(details);
						details.setPrimaryKeys(getPrimaryKeysFromMap(details.getFieldsMap()));
					}
					
					entityDetailsMap.put(entityName.substring(entityName.lastIndexOf(".") + 1), details);
					// Generate Entity based on template
					Generate(entityName, details, schema, packageName, destinationPath,compositePrimaryKeyEntities,authenticationTable,authenticationType);

				}
			}

			if(authenticationTable !=null  && authenticationType != "none")
			{
				entityDetailsMap=validateAuthenticationTable(entityDetailsMap, authenticationTable);
			}
			
			if(authenticationType !="none")
			{
				GenerateAutheticationEntities(entityDetailsMap, schema, packageName, destinationPath,authenticationTable,authenticationType);
			}

		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();
		}

		return entityDetailsMap;
	}
	
	public EntityDetails setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(Map<String, RelationDetails> relationMap,EntityDetails details,String className)
	{
		Map<String,FieldDetails> descriptiveFieldEntities = new HashMap<>();
		
		// Get parent descrptive fields from user
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {

			if(entry.getValue().getRelation().equals("OneToOne") && !entry.getValue().getIsParent())
			{
                   
				if(identifyOneToOneRelationContainsPrimaryKeys(entry.getValue().getfDetails(),details.getPrimaryKeys(),entry.getValue().getJoinDetails())) {
					details.setIdClass(entry.getValue().geteName()+"Id");
				}
				
				//get and set descriptive field
				if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName()))){
					descriptiveFieldEntities = entry.getValue().FindAndSetDescriptiveField(descriptiveFieldEntities);
				}
				
				//if child id class not exists update join columns
				if(className.concat("Id") != details.getIdClass()) {
					details=updateJoinColumnName(details,entry.getValue(), entry.getKey());
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

		details.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
		return details;
	}

	public boolean identifyOneToOneRelationContainsPrimaryKeys(List<FieldDetails> fDetails, Map<String,String> primaryKeysMap,List<JoinDetails> joinDetailsList)
	{
		List<String> relationEntityPrimaryKeys = getPrimaryKeysFromList(fDetails);
		List<String> entityPrimaryKeys = new ArrayList<String>();
		for(String key: primaryKeysMap.keySet()) {
			entityPrimaryKeys.add(key);
		}
		for(JoinDetails jDetails : joinDetailsList)
		{
			if(relationEntityPrimaryKeys.contains(jDetails.getReferenceColumn()) && entityPrimaryKeys.contains(jDetails.getReferenceColumn()))
			{
				return true;

			}
		}

		return false;
	}

	public List<String> getPrimaryKeysFromList(List<FieldDetails> fieldsList)
	{
		List<String> primaryKeys= new ArrayList<String>();
		for(FieldDetails f : fieldsList)
		{
			if(f.getIsPrimaryKey())
				primaryKeys.add(f.getFieldName());
		}

		return primaryKeys;
	}

	public static Map<String,String> getPrimaryKeysFromMap(Map<String, FieldDetails> fieldsMap)
	{
		Map<String,String> primaryKeys = new HashMap<>();
		for (Map.Entry<String, FieldDetails> entry : fieldsMap.entrySet()) {
			if(entry.getValue().getIsPrimaryKey())
			{
				if(entry.getValue().getFieldType().equalsIgnoreCase("long"))
					primaryKeys.put(entry.getValue().getFieldName(),"Long");
				else
					primaryKeys.put(entry.getValue().getFieldName(), entry.getValue().getFieldType());
			}
		}
		Map<String, String> sortedKeys =primaryKeys
				.entrySet()
				.stream()
				.sorted(comparingByKey())
				.collect(
						toMap(e -> e.getKey(), e -> e.getValue(),
								(e1, e2) -> e2, LinkedHashMap::new));
		return sortedKeys;
	}
	
	public static EntityDetails updateFieldsListInRelationMap(EntityDetails entityDetails)
	{

		Map<String, RelationDetails> relationMap = entityDetails.getRelationsMap();
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {

			if(entry.getValue().getRelation().equals("OneToOne") && entry.getValue().getIsParent())
			{
				for(JoinDetails jdetail : entry.getValue().getJoinDetails())
				{
					if(entry.getValue().getfDetails().size() >1)
					{
						for(FieldDetails fdetail : entry.getValue().getfDetails()) {
							if(fdetail.getFieldName().equalsIgnoreCase(jdetail.getJoinColumn()))
							{
								fdetail.setFieldName(jdetail.getReferenceColumn());
							}
						}
					}

				}
			}
		}

		return entityDetails;
	}

	public static EntityDetails updateJoinColumnName(EntityDetails entityDetails, RelationDetails relationdetails ,String relationDetailsKey)
	{
		Map<String, FieldDetails> fieldsMap= entityDetails.getFieldsMap();

		for(JoinDetails str : relationdetails.getJoinDetails())
		{
			if(fieldsMap.containsKey(str.getJoinColumn()) && !str.getJoinColumn().equalsIgnoreCase(str.getReferenceColumn()))
			{
				FieldDetails fieldDetails = fieldsMap.get(str.getJoinColumn());
				fieldDetails.setrelationFieldName(fieldDetails.getFieldName());
				fieldDetails.setFieldName(str.getReferenceColumn());
				fieldsMap.put(str.getJoinColumn(), fieldDetails);
			}

		}

		return entityDetails;
	}

	public static Map<String,EntityDetails> validateAuthenticationTable(Map<String,EntityDetails> entityDetailsMap, String authenticationTable)
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

			return getAuthenticationTableFieldsMapping(entityDetailsMap, authenticationTable, scanner);
		}
		return entityDetailsMap;
	}

	public static Map<String,EntityDetails> getAuthenticationTableFieldsMapping(Map<String,EntityDetails> entityDetails, String authenticationTable, Scanner scanner)
	{
		Map<String,FieldDetails> authFields=new HashMap<String, FieldDetails>();
		authFields.put("UserName", null);
		authFields.put("Password", null);

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

	public void GenerateAutheticationEntities(Map<String,EntityDetails> entityDetails, String schemaName, String packageName,
			String destPath, String authenticationTable,String authenticationType) {
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

	//	setTemplateLoader();

		for(Map.Entry<String,EntityDetails> entry : entityDetails.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			if(className.equalsIgnoreCase(authenticationTable))
			{
				root.put("ClassName", className);
				root.put("IdClass", entry.getValue().getIdClass());
				root.put("TableName", entry.getValue().getEntityTableName());
				root.put("CompositeKeyClasses",entry.getValue().getCompositeKeyClasses());
				root.put("Fields", entry.getValue().getFieldsMap());
				root.put("AuthenticationFields", entry.getValue().getAuthenticationFieldsMap());
				root.put("PrimaryKeys", entry.getValue().getPrimaryKeys());
			}
		}

		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";

		getAuthenticationEntitiesTemplates(destinationFolder,ENTITIES_TEMPLATE_FOLDER,authenticationType,authenticationTable,root);
		//generateFiles(AuthenticationClassesTemplateGenerator.getAuthenticationEntitiesTemplates(authenticationType,authenticationTable), root, destinationFolder);
	}
	
	public void getAuthenticationEntitiesTemplates(String destination, String templatePath, String authenticationType, String authenticationTable, Map<String,Object> root) {
		List<String> filesList = new CodeGeneratorUtils().readFilesFromDirectory(templatePath);
		filesList = new CodeGeneratorUtils().replaceFileNames(filesList, templatePath);
		
		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));

			if(authenticationTable==null)
			{
				templates.put(filePath, outputFileName);
			}
			else
			{
				if((outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
				{
					outputFileName = outputFileName.replace("User", authenticationTable);
					outputFileName = outputFileName.replace("user", authenticationTable.toLowerCase());
				}

				if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}

		}

		new CodeGeneratorUtils().generateFiles(templates, root, destination,templatePath);
	}

	public void Generate(String entityName, EntityDetails entityDetails, String schemaName, String packageName,
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
		root.put("IdClass", entityDetails.getIdClass());
		root.put("AuthenticationType",authenticationType);
		if(authenticationTable !=null)
			root.put("AuthenticationTable", authenticationTable);
		else
			root.put("AuthenticationTable", "User");
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());

		//setTemplateLoader();

		Map<String, FieldDetails> actualFieldNames = entityDetails.getFieldsMap();
		Map<String, RelationDetails> relationMap = entityDetails.getRelationsMap();

		root.put("Fields", actualFieldNames);
		root.put("Relationship", relationMap);
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());
		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";

		generateEntity(root, destinationFolder);

		String idClassName = entityDetails.getIdClass().substring(0,entityDetails.getIdClass().indexOf("Id"));
		if (compositePrimaryKeyEntities.contains(idClassName) && root.get("ClassName").toString().equals(idClassName)) {
			generateIdClass(root, destinationFolder);
		}

	}

	private static void generateEntity(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		new CodeGeneratorUtils().generateFiles(getEntityTemplate(root.get("ClassName").toString()), root, destPath,TEMPLATE_FOLDER);
	}

	private static void generateIdClass(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		new CodeGeneratorUtils().generateFiles(getIdClassTemplate(root.get("ClassName").toString()), root, destPath,TEMPLATE_FOLDER);
	}

//	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
//		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
//			try {
//				Template template = cfg.getTemplate(entry.getKey());
//
//				String entryPath = entry.getValue().toString();
//				File fileName = new File(destPath + "/" + entry.getValue().toString());
//
//				String dirPath = destPath;
//				if(destPath.split("/").length > 1 && entryPath.split("/").length > 1) {
//					dirPath = dirPath + entryPath.substring(0, entryPath.lastIndexOf('/'));
//				}
//				File dir = new File(dirPath);
//				if(!dir.exists()) {
//					dir.mkdirs();
//				};
//
//				PrintWriter writer = new PrintWriter(fileName);
//				template.process(root, writer);
//				writer.flush();
//				writer.close();
//
//			} catch (Exception e1) {
//				e1.printStackTrace();
//
//			}
//		}
//	}

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

	public Map<String, String> parseConnectionString(String connectionString) {
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
