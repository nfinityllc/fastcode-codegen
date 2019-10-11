package com.nfinity.codegen;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGenerator;
import com.nfinity.entitycodegen.FieldDetails;
import com.nfinity.entitycodegen.RelationDetails;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.apache.commons.io.FileUtils;

import static java.util.stream.Collectors.*;
import static java.util.Map.Entry.*;

import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CodeGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static String TEMPLATE_FOLDER = "/templates";
	static String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	static String DTO_TEMPLATE_FOLDER = "/templates/backendTemplates/Dto";
	static String CLIENT_ROOT_FOLDER = "/client";


	private static Map<String, Object> buildEntityInfo(String entityName,String packageName,Boolean audit,Boolean history, String sourcePath,
			String type, String modName,EntityDetails details,String authenticationType,Boolean email, Boolean flowable, String schema,String authenticationTable) {
		Map<String, Object> root = new HashMap<>();
		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(className);
		splittedNames[0] = StringUtils.lowerCase(splittedNames[0]);
		String instanceName = StringUtils.join(splittedNames);
		for (int i = 0; i < splittedNames.length; i++) {
			splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
		}
		String moduleName = StringUtils.isNotEmpty(modName) ? modName : StringUtils.join(splittedNames, "-");

		root.put("Schema", schema);
		root.put("ModuleName", moduleName);
		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("InstanceName", instanceName);
		root.put("CompositeKeyClasses",details.getCompositeKeyClasses());
		root.put("DescriptiveField",details.getEntitiesDescriptiveFieldMap());
		root.put("AuthenticationFields",details.getAuthenticationFieldsMap());
		root.put("Audit", audit);
		root.put("History", history);
		root.put("IEntity", "I" + className);
		root.put("IEntityFile", "i" + moduleName);
		root.put("CommonModulePackage" , packageName.concat(".CommonModule"));
		root.put("AuthenticationType", authenticationType);
		root.put("EmailModule", email);
		root.put("Flowable", flowable);
		root.put("ApiPath", className.substring(0, 1).toLowerCase() + className.substring(1));
		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}	

		Map<String, FieldDetails> actualFieldNames = details.getFieldsMap();
		Map<String,String> primaryKeys= new HashMap<>();
		for (Map.Entry<String, FieldDetails> entry : actualFieldNames.entrySet()) {
			if(entry.getValue().getIsPrimaryKey())
			{
				if(entry.getValue().getFieldType().equalsIgnoreCase("long"))
					primaryKeys.put(entry.getValue().getFieldName(),"Long");
				else
					primaryKeys.put(entry.getValue().getFieldName(), entry.getValue().getFieldType());
			}
		}
		Map<String, String> sorted =primaryKeys
				.entrySet()
				.stream()
				.sorted(comparingByKey())
				.collect(
						toMap(e -> e.getKey(), e -> e.getValue(),
								(e1, e2) -> e2, LinkedHashMap::new));

		root.put("PrimaryKeys", sorted);
		Map<String, RelationDetails> relationMap = details.getRelationsMap();
		List<String> searchFields = new ArrayList<>();

		// add text fields as search fields
		for (Map.Entry<String, FieldDetails> entry : actualFieldNames.entrySet()) {
			if (entry.getValue().getFieldType().equalsIgnoreCase("String"))
				searchFields.add(entry.getValue().getFieldName());
		}

		root.put("Fields", actualFieldNames);
		root.put("SearchFields", searchFields);
		root.put("Relationship", relationMap);

		return root;
	}

	/// appname= groupid + artifactid
	public static void GenerateAll(String backEndRootFolder, String clientRootFolder, String appName,String sourcePackageName,Boolean audit,
			Boolean history, String sourcePath, String destPath, String type,Map<String,EntityDetails> details, String connectionString,
			String schema,String authenticationType,Boolean scheduler, Boolean email,Boolean flowable,String authenticationTable) throws IOException {

		// generate all modules for each entity
		List<String> entityNames=new ArrayList<String>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			entityNames.add(className);
			Generate(entry.getKey(), appName, backEndRootFolder, clientRootFolder, sourcePackageName, audit, history, sourcePath, 
					destPath, type, entry.getValue(), authenticationType, scheduler, email, flowable, schema,authenticationTable);
		}

		//FileUtils.copyFile(new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/keystore.p12"), new File(destPath + "/" + backEndRootFolder + "/src/main/resources/keystore.p12"));
        FileUtils.copyFile(new File("src/main/resources/keystore.p12"), new File(destPath + "/" + backEndRootFolder + "/src/main/resources/keystore.p12"));

		//	PomFileModifier.update(destPath + "/" + backEndRootFolder + "/pom.xml",authenticationType,scheduler);
		//	modifyMainClass(destPath + "/" + backEndRootFolder + "/src/main/java",appName);



		if(history) {
			String appFolderPath = destPath + "/" + appName.substring(appName.lastIndexOf(".") + 1) + "Client/src/app/";
			generateEntityHistoryComponent(appFolderPath);
			addhistoryComponentsToAppModule(appFolderPath);
			addhistoryComponentsToAppRoutingModule(appFolderPath, authenticationType);
			generateAuditorController(details, appName, sourcePackageName,backEndRootFolder,destPath,authenticationType,authenticationTable);

		}

		updateAppRouting(destPath,appName.substring(appName.lastIndexOf(".") + 1), entityNames, authenticationType);
		updateAppModule(destPath,appName.substring(appName.lastIndexOf(".") + 1), entityNames);
		updateTestUtils(destPath,appName.substring(appName.lastIndexOf(".") + 1), entityNames);
		updateEntitiesJsonFile(destPath + "/" + appName.substring(appName.lastIndexOf(".") + 1) + "Client/src/app/common/components/main-nav/entities.json",entityNames,authenticationTable);

		Map<String,Object> propertyInfo = getInfoForApplicationPropertiesFile(appName, connectionString, schema,authenticationType,email, flowable);
		generateApplicationProperties(propertyInfo, destPath + "/" + backEndRootFolder + "/src/main/resources");
		generateBeanConfig(appName, sourcePackageName,backEndRootFolder,destPath,authenticationType,audit);

	}

	private static void generateBeanConfig(String appName,String packageName,String backEndRootFolder, String destPath,String authenticationType,Boolean audit){

		String backendAppFolder = backEndRootFolder + "/src/main/java";

		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/authenticationTemplates");// "/templates/backendTemplates/"); 
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 }); 

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX); 
		cfg.setDefaultEncoding("UTF-8"); 
		cfg.setTemplateLoader(mtl); 

		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", packageName);
		root.put("AuthenticationType", authenticationType);
		root.put("Audit",audit);
		Map<String, Object> template = new HashMap<>();
		template.put("BeanConfig.java.ftl", "BeanConfig.java");
		//	template.put("AuditorAwareImpl.java.ftl", "AuditorAwareImpl.java");
		String destFolder = destPath + "/" + backendAppFolder + "/" + appName.replace(".", "/") ;
		new File(destFolder).mkdirs();
		generateFiles(template, root, destFolder);

	}

	private static Map<String,Object> getInfoForApplicationPropertiesFile(String appName, String connectionString, String schema,String authenticationType,Boolean email, Boolean flowable){
		Map<String,Object> propertyInfo = new HashMap<String,Object>();

		propertyInfo.put("connectionStringInfo", EntityGenerator.parseConnectionString(connectionString));
		propertyInfo.put("appName", appName.substring(appName.lastIndexOf(".") + 1));
		propertyInfo.put("Schema", schema);
		propertyInfo.put("EmailModule",email);
		propertyInfo.put("AuthenticationType",authenticationType);
		propertyInfo.put("packageName",appName.replace(".", "/"));
		propertyInfo.put("Flowable", flowable);
		propertyInfo.put("packagePath", appName);

		return propertyInfo;
	}

	private static void generateAuditorController(Map<String, EntityDetails> details, String appName,String packageName,String backEndRootFolder, String destPath,String authenticationType,String authenticationTable){

		String backendAppFolder = backEndRootFolder + "/src/main/java";
		Map<String, Object> entitiesMap = new HashMap<String,Object>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{

			Map<String, String> entityMap = new HashMap<String,String>();
			String key = entry.getKey();
			String name = key.substring(key.lastIndexOf(".") + 1);

			entityMap.put("entity" , name + "Entity");
			entityMap.put("importPkg" , appName + ".domain.model." + name + "Entity");
			entityMap.put("requestMapping" , "/" + name.toLowerCase());
			entityMap.put("method" , "get" + name + "Changes");

			entitiesMap.put(name, entityMap);

		}
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/"); 
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 }); 

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX); 
		cfg.setDefaultEncoding("UTF-8"); 
		cfg.setTemplateLoader(mtl); 

		Map<String, Object> root = new HashMap<>();
		root.put("entitiesMap", entitiesMap);
		root.put("PackageName", packageName);
		root.put("AuthenticationType", authenticationType);
		if(authenticationTable !=null)
			root.put("AuthenticationTable", authenticationTable);
		else
			root.put("AuthenticationTable", "User");	

		Map<String, Object> template = new HashMap<>();
		template.put("AuditController.java.ftl", "AuditController.java");

		String destFolder = destPath + "/" + backendAppFolder + "/" + appName.replace(".", "/") + "/RestControllers";
		new File(destFolder).mkdirs();
		generateFiles(template, root, destFolder);

	}

	private static void generateEntityHistoryComponent(String destFolder){


		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, TEMPLATE_FOLDER + "/");
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 });

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(mtl);

		Map<String, Object> template = new HashMap<>();
		template.put("entityHistory/entity-history/entity-history.component.html.ftl", "entity-history.component.html");
		template.put("entityHistory/entity-history/entity-history.component.scss.ftl", "entity-history.component.scss");
		template.put("entityHistory/entity-history/entity-history.component.spec.ts.ftl", "entity-history.component.spec.ts");
		template.put("entityHistory/entity-history/entity-history.component.ts.ftl", "entity-history.component.ts");
		template.put("entityHistory/entity-history/entity-history.service.ts.ftl", "entity-history.service.ts");
		template.put("entityHistory/entity-history/entityHistory.ts.ftl", "entityHistory.ts");
		template.put("entityHistory/entity-history/filter-item.directive.ts.ftl", "filter-item.directive.ts");

		new File(destFolder + "/entity-history").mkdirs();
		generateFiles(template, null, destFolder + "/entity-history");

		template = new HashMap<>();
		template.put("entityHistory/manage-entity-history/manage-entity-history.component.html.ftl", "manage-entity-history.component.html");
		template.put("entityHistory/manage-entity-history/manage-entity-history.component.scss.ftl", "manage-entity-history.component.scss");
		template.put("entityHistory/manage-entity-history/manage-entity-history.component.spec.ts.ftl", "manage-entity-history.component.spec.ts");
		template.put("entityHistory/manage-entity-history/manage-entity-history.component.ts.ftl", "manage-entity-history.component.ts");

		new File(destFolder + "/manage-entity-history").mkdirs();
		generateFiles(template, null, destFolder + "/manage-entity-history");

	}

	public static void addhistoryComponentsToAppModule(String destPath)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);


		sourceBuilder.append("\n    " + "EntityHistoryComponent," );
		sourceBuilder.append("\n    " + "ManageEntityHistoryComponent,");

		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/app.module.ts"),"UTF8");

			StringBuilder builder = new StringBuilder();

			builder.append("import { EntityHistoryComponent } from './entity-history/entity-history.component';" + "\n");
			builder.append("import { ManageEntityHistoryComponent } from './manage-entity-history/manage-entity-history.component';" + "\n");

			builder.append(data);
			int index = builder.lastIndexOf("declarations");
			index = builder.indexOf("[", index);
			builder.insert(index + 1 , sourceBuilder.toString());
			File fileName = new File(destPath + "/app.module.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void addhistoryComponentsToAppRoutingModule(String destPath, String authenticationType)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);

		if(authenticationType == "none") {
			sourceBuilder.append("\n  " + " { path: 'entityHistory', component: EntityHistoryComponent},");
			sourceBuilder.append("\n  " + " { path: 'manageEntityHistory', component: ManageEntityHistoryComponent},");
		}
		else {
			sourceBuilder.append("\n  " + " { path: 'entityHistory', component: EntityHistoryComponent ,canActivate: [ AuthGuard ]},");
			sourceBuilder.append("\n  " + " { path: 'manageEntityHistory', component: ManageEntityHistoryComponent ,canActivate: [ AuthGuard ]},");
		}

		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/app.routing.ts"),"UTF8");

			StringBuilder builder = new StringBuilder();

			builder.append("import { EntityHistoryComponent } from './entity-history/entity-history.component';" + "\n");
			builder.append("import { ManageEntityHistoryComponent } from './manage-entity-history/manage-entity-history.component';" + "\n");
			builder.append(data);

			int index = builder.lastIndexOf("{");
			builder.insert(index - 1, sourceBuilder.toString());
			File fileName = new File(destPath + "/app.routing.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void Generate(String entityName, String appName, String backEndRootFolder,String clientRootFolder,String packageName,Boolean audit,

			Boolean history, String sourcePath, String destPath, String type,EntityDetails details,String authenticationType, Boolean scheduler, Boolean email, Boolean flowable, String schema,String authenticationTable) {

		String backendAppFolder = backEndRootFolder + "/src/main/java";
		String clientAppFolder = clientRootFolder + "/src/app";
		Map<String, Object> root = buildEntityInfo(entityName,packageName,audit,history, sourcePath, type, "",details,authenticationType,email,flowable,schema,authenticationTable);


		Map<String, Object> uiTemplate2DestMapping = getUITemplates(root.get("ModuleName").toString());

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, TEMPLATE_FOLDER + "/"); // "/templates/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/");
		ClassTemplateLoader ctl2 = new ClassTemplateLoader(CodegenApplication.class, DTO_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/Dto");

		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl,ctl1,ctl2 };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(mtl);

		try {

			Map<String, Object> otherTemplate2DestMapping = new HashMap<String, Object>();
			if (type.equalsIgnoreCase("other")) {
				cfg.setDirectoryForTemplateLoading(new File(sourcePath + TEMPLATE_FOLDER + "/"));
				otherTemplate2DestMapping = getOtherTemplates(root.get("ClassName").toString(),
						sourcePath + TEMPLATE_FOLDER + "/");
			} else {
				cfg.setTemplateLoader(mtl);
			}

			String destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString(); // "/fcclient/src/app/"
			new File(destFolder).mkdirs();
			if (type.equalsIgnoreCase("other")) {
				generateFiles(otherTemplate2DestMapping, root, destFolder);
			} else if (type.equalsIgnoreCase("ui"))
				generateFiles(uiTemplate2DestMapping, root, destFolder);
			else if (type == "backend") {
				destFolder = destPath + "/" + backendAppFolder + "/" + appName.replace(".", "/");
				generateBackendFiles(root, destFolder,authenticationTable);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString(),authenticationTable);
				//	generateCustomRepositoryTemplates(root, destFolder,root.get("ClassName").toString());
			} else {
				destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString();
				generateFiles(uiTemplate2DestMapping, root, destFolder);
				destFolder = destPath +"/"+ backendAppFolder + "/" + appName.replace(".", "/");
				generateBackendFiles(root, destFolder,authenticationTable);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString(),authenticationTable);
				//	generateCustomRepositoryTemplates(root, destFolder,root.get("ClassName").toString());
			}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	private static void generateBackendFiles(Map<String, Object> root, String destPath,String authenticationTable) {
		String className = root.get("ClassName").toString();

		String destFolderBackend = destPath + "/application/" + className;
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/application/Authorization/" + className;
		}
		new File(destFolderBackend).mkdirs();
		generateFiles(getApplicationTemplates(className), root, destFolderBackend);

		destFolderBackend = destPath + "/application/" + className + "/Dto";
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/application/Authorization/" + className + "/Dto";
		}
		new File(destFolderBackend).mkdirs();
		Map<String,FieldDetails> authFields = (Map<String,FieldDetails>)root.get("AuthenticationFields");
		generateFiles(getDtos(className,authenticationTable,authFields), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/" + className;
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/domain/Authorization/" + className;
		}
		new File(destFolderBackend).mkdirs();
		generateFiles(getDomainTemplates(className), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/IRepository";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRepositoryTemplates(className), root, destFolderBackend);

		destFolderBackend = destPath + "/RestControllers";
		new File(destFolderBackend).mkdirs();
		generateFiles(getControllerTemplates(className), root, destFolderBackend);
	}

	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());

				String entryPath = entry.getValue().toString();
				File fileName = new File(destPath + "/" + entry.getValue().toString());

				String dirPath = destPath;
				if(destPath.split("/").length > 1 && entryPath.split("/").length > 1) {
					dirPath = dirPath + entryPath.substring(0, entryPath.lastIndexOf('/'));
				}
				File dir = new File(dirPath);
				if(!dir.exists()) {
					dir.mkdirs();
				};

				PrintWriter writer = new PrintWriter(fileName);
				template.process(root, writer);
				writer.flush();
				writer.close();

			} catch (Exception e1) {
				e1.printStackTrace();

			}
		}
	}

	private static Map<String, Object> getUITemplates(String moduleName) {
		Map<String, Object> uiTemplate = new HashMap<>();
		uiTemplate.put("iitem.ts.ftl", "i" + moduleName + ".ts");
		uiTemplate.put("index.ts.ftl", "index.ts");
		uiTemplate.put("item.service.ts.ftl", moduleName + ".service.ts");

		uiTemplate.put("item-list.component.ts.ftl", moduleName + "-list.component.ts");
		uiTemplate.put("item-list.component.html.ftl", moduleName + "-list.component.html");
		uiTemplate.put("item-list.component.scss.ftl", moduleName + "-list.component.scss");
		uiTemplate.put("item-list.component.spec.ts.ftl", moduleName + "-list.component.spec.ts");

		uiTemplate.put("item-new.component.ts.ftl", moduleName + "-new.component.ts");
		uiTemplate.put("item-new.component.html.ftl", moduleName + "-new.component.html");
		uiTemplate.put("item-new.component.scss.ftl", moduleName + "-new.component.scss");
		uiTemplate.put("item-new.component.spec.ts.ftl", moduleName + "-new.component.spec.ts");

		uiTemplate.put("item-details.component.ts.ftl", moduleName + "-details.component.ts");
		uiTemplate.put("item-details.component.html.ftl", moduleName + "-details.component.html");
		uiTemplate.put("item-details.component.scss.ftl", moduleName + "-details.component.scss");
		uiTemplate.put("item-details.component.spec.ts.ftl", moduleName + "-details.component.spec.ts");

		return uiTemplate;
	}

	private static Map<String, Object> getOtherTemplates(String className, String templateFolder) {
		// Map<String, Object> uiTemplate = new HashMap<>();
		Map<String, Object> otherTemplates = new HashMap<>();
		// uiTemplate.put("iitem.ts.ftl","i" + moduleName + ".ts");
		// otherTemplates.put("manager.java.ftl",className + "Manager.java");

		File folder = new File(templateFolder);
		File[] tempFiles = folder.listFiles();

		String fileNameCExt = "";
		String fileName = "";
		for (int i = 0; i < tempFiles.length; i++) {
			if (tempFiles[i].isFile() && tempFiles[i].getName().toLowerCase().endsWith(".ftl")) {
				fileNameCExt = tempFiles[i].getName();
				// fileName = FilenameUtils.removeExtension(fileNameCExt);
				otherTemplates.put(fileNameCExt, fileName);
			}
		}
		return otherTemplates;
	}

	private static Map<String, Object> getApplicationTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("iappService.java.ftl", "I" + className + "AppService.java");
		backEndTemplate.put("appService.java.ftl", className + "AppService.java");
		backEndTemplate.put("mapper.java.ftl", className + "Mapper.java");
		backEndTemplate.put("appServiceTest.java.ftl", className + "AppServiceTest.java");

		return backEndTemplate;
	}

	//	private static Map<String, Object> generateCustomRepositoryTemplates(Map<String,Object> root,String destPath,String className) {
	//		List<String> relationInput= (List<String>) root.get("RelationInput");
	//		destPath=destPath + "/domain/IRepository";
	//		Map<String, Object> backEndTemplate = new HashMap<>();
	//		for(String str : relationInput)
	//		{
	//			if(className.equals(str.substring(0,str.lastIndexOf("-")).toString()))
	//			{
	//				backEndTemplate.put("icustomRepository.java.ftl", className + "CustomRepository.java");
	//				backEndTemplate.put("customRepositoryImpl.java.ftl", className + "CustomRepositoryImpl.java");
	//				generateFiles(backEndTemplate, root, destPath);
	//			}
	//		}
	//
	//		return backEndTemplate;
	//	}

	private static Map<String, Object> getRepositoryTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("irepository.java.ftl", "I" + className + "Repository.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getControllerTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("controller.java.ftl", className + "Controller.java");
		//		backEndTemplate.put("emptyJsonResponse.java.ftl","EmptyJsonResponse.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getDomainTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("manager.java.ftl", className + "Manager.java");
		backEndTemplate.put("imanager.java.ftl", "I" + className + "Manager.java");
		backEndTemplate.put("managerTest.java.ftl", className + "ManagerTest.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getDtos(String className,String authenticationTable,Map<String,FieldDetails> authFields) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("createInput.java.ftl", "Create" + className + "Input.java");
		backEndTemplate.put("createOutput.java.ftl", "Create" + className + "Output.java");
		backEndTemplate.put("updateInput.java.ftl", "Update" + className + "Input.java");
		backEndTemplate.put("updateOutput.java.ftl", "Update" + className + "Output.java");
		backEndTemplate.put("findByIdOutput.java.ftl", "Find" + className + "ByIdOutput.java");
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			if(authFields !=null)
			{
				for(Map.Entry<String, FieldDetails> map : authFields.entrySet())
				{
					if(map.getKey()=="UserName")
						backEndTemplate.put("authenticationTemplates/users/dtos/FindCustomUserByNameOutput.java.ftl", "Find"+authenticationTable+"By"+map.getValue().getFieldName().substring(0, 1).toUpperCase() + map.getValue().getFieldName().substring(1)+"Output.java");
				}
			}
			else
				backEndTemplate.put("authenticationTemplates/users/dtos/FindUserByNameOutput.java.ftl", "Find"+authenticationTable+"ByNameOutput.java");

			backEndTemplate.put("authenticationTemplates/users/dtos/GetRoleOutput.java.ftl", "GetRoleOutput.java");
			backEndTemplate.put("authenticationTemplates/users/dtos/LoginUserInput.java.ftl", "LoginUserInput.java");
			backEndTemplate.put("authenticationTemplates/users/dtos/FindCustomUserWithAllFieldsByIdOutput.java.ftl", "Find"+authenticationTable+"WithAllFieldsByIdOutput.java");
		}
		return backEndTemplate;
	}

	private static void generateRelationDto(EntityDetails details,Map<String,Object> root, String destPath,String entityName,String authenticationTable)
	{
		String destFolder = destPath + "/application/" + root.get("ClassName").toString() + "/Dto";
		if(authenticationTable !=null && root.get("ClassName").toString().equalsIgnoreCase(authenticationTable))
		{
			destFolder = destPath + "/application/Authorization/" + root.get("ClassName").toString() + "/Dto";
		}
		new File(destFolder).mkdirs();

		Map<String,RelationDetails> relationDetails = details.getRelationsMap();

		for (Map.Entry<String, RelationDetails> entry : relationDetails.entrySet()) {
			if(entry.getValue().getRelation().equals("ManyToOne") || entry.getValue().getRelation().equals("OneToOne"))
			{
				List<FieldDetails> relationEntityFields= entry.getValue().getfDetails();

				root.put("RelationEntityFields",relationEntityFields);
				root.put("RelationEntityName", entry.getValue().geteName());
				
				try {
					Template template = cfg.getTemplate("getOutput.java.ftl");
					File fileName = new File(destFolder + "/" +  "Get"+ entry.getValue().geteName() + "Output.java");
					PrintWriter writer = new PrintWriter(fileName);
					template.process(root, writer);
					writer.flush();
					writer.close();
				}
				catch ( Exception  e1) {
					e1.printStackTrace();
				}
			}
		}
	}

	private static void generateApplicationProperties(Map<String, Object> root, String destPath)
	{
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class,  BACKEND_TEMPLATE_FOLDER );
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 }); 

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX); 
		cfg.setDefaultEncoding("UTF-8"); 
		cfg.setTemplateLoader(mtl);

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("application.properties.ftl", "application.properties");
		new File(destPath).mkdirs();
		generateFiles(backEndTemplate, root, destPath);
	}

	public static void updateAppModule(String destPath,String appName,List<String> entityName)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);

		for(String str: entityName)
		{
			sourceBuilder.append("\n    " + str + "ListComponent," );
			sourceBuilder.append("\n    " + str + "DetailsComponent,");
			sourceBuilder.append("\n    " + str + "NewComponent,");
		}
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + appName + "Client/src/app/app.module.ts"),"UTF8");

			StringBuilder builder = addImports(entityName);

			builder.append(data);
			int index = builder.lastIndexOf("declarations");
			index = builder.indexOf("[", index);
			builder.insert(index + 1 , sourceBuilder.toString());
			File fileName = new File(destPath + "/" + appName + "Client/src/app/app.module.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateAppRouting(String destPath,String appName, List<String> entityName, String authenticationType)
	{
		StringBuilder sourceBuilder=new StringBuilder();

		for(String str: entityName)
		{
			String listComp,newComp,detailsComp;
			if(authenticationType == "none") {
				listComp = "\n  " +" { path: '" + str.toLowerCase() + "', component: " + str + "ListComponent, canDeactivate: [CanDeactivateGuard] },";
				newComp = "\n  " + " { path: '" + str.toLowerCase() + "/new', component: " + str + "NewComponent },";
				detailsComp = "\n  " + " { path: '" + str.toLowerCase() + "/:id', component: " +str + "DetailsComponent, canDeactivate: [CanDeactivateGuard] }," + "\n";
			}
			else {
				listComp = "\n  " +" { path: '" + str.toLowerCase() + "', component: " + str + "ListComponent, canActivate: [ AuthGuard ], canDeactivate: [CanDeactivateGuard] },";
				newComp = "\n  " + " { path: '" + str.toLowerCase() + "/new', component: " + str + "NewComponent ,canActivate: [ AuthGuard ]  },";
				detailsComp = "\n  " + " { path: '" + str.toLowerCase() + "/:id', component: " +str + "DetailsComponent ,canActivate: [ AuthGuard ], canDeactivate: [CanDeactivateGuard] },"+ "\n";
			}

			sourceBuilder.append(listComp);
			sourceBuilder.append(newComp);
			sourceBuilder.append(detailsComp);
		}
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + appName + "Client/src/app/app.routing.ts"),"UTF8");

			StringBuilder builder = addImports(entityName);

			builder.append(data);
			int index = builder.lastIndexOf("{");
			builder.insert(index - 1, sourceBuilder.toString());
			File fileName = new File(destPath + "/" + appName + "Client/src/app/app.routing.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static StringBuilder addImports(List<String> entityName)
	{
		StringBuilder builder=new StringBuilder();
		for(String str: entityName)
		{
			String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(str);
			for (int i = 0; i < splittedNames.length; i++) {
				splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
			}
			String moduleName=StringUtils.join(splittedNames, "-");
			builder.append("import { " + str + "ListComponent , " + str + "DetailsComponent, " + str + "NewComponent } from './" + moduleName + "/index';" + "\n");
		}

		return builder;
	}

	public static void modifyMainClass(String destPath,String appName)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);

		sourceBuilder.append("import org.springframework.context.annotation.ComponentScan;\n");
		sourceBuilder.append("@ComponentScan(basePackages = {\"com.nfinity.*\", " + "\""+ appName.substring(0,appName.lastIndexOf("."))+".*\"})\n");

		String packageName = appName.replace(".", "/");
		String className = appName.substring(appName.lastIndexOf(".") + 1);
		className = className.substring(0, 1).toUpperCase() + className.substring(1) + "Application.java";
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + packageName + "/" + className),"UTF8");

			StringBuilder builder=new StringBuilder();

			builder.append(data);
			int index = builder.lastIndexOf("@");
			builder.insert(index - 1 , sourceBuilder.toString());


			File fileName = new File(destPath + "/" + packageName + "/" + className);

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateTestUtils(String destPath,String appName,List<String> entityName)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);

		for(String str: entityName)
		{
			sourceBuilder.append("\n    " + str + "NewComponent,");
		}
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + appName + "Client/src/testing/utils.ts"),"UTF8");

			StringBuilder builder = addImportForTestUtils(entityName);

			builder.append(data);
			int index = builder.lastIndexOf("entryComponents");
			index = builder.indexOf("[", index);
			builder.insert(index + 1 , sourceBuilder.toString());

			index = builder.lastIndexOf("[");
			builder.insert(index + 1 , sourceBuilder.toString());

			File fileName = new File(destPath + "/" + appName + "Client/src/testing/utils.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static StringBuilder addImportForTestUtils(List<String> entityName)
	{
		StringBuilder builder=new StringBuilder();
		for(String str: entityName)
		{
			String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(str);
			for (int i = 0; i < splittedNames.length; i++) {
				splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
			}
			String moduleName=StringUtils.join(splittedNames, "-");
			builder.append("import {" + str + "NewComponent } from 'src/app/" + moduleName + "/index';" + "\n");
		}

		return builder;
	}


	public static void updateEntitiesJsonFile(String path,List<String> entityNames, String authenticationTable) {

		try {

			JSONArray entityArray = (JSONArray) readJsonFile(path);
			for(String entityName: entityNames)
			{
				if(!entityName.equalsIgnoreCase(authenticationTable)) {
					entityArray.add(entityName.toLowerCase());
				}
			}

			String prettyJsonString = beautifyJson(entityArray, "Array"); 
			writeJsonToFile(path,prettyJsonString);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}

	}

	public static Object readJsonFile(String path) throws IOException, ParseException {

		JSONParser parser = new JSONParser();
		FileReader fr = new FileReader(path);
		Object obj = parser.parse(fr);
		fr.close();
		return obj;
	}

	// type: "Object" , "Array"
	public static String beautifyJson(Object jsonObject, String type)  {
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		JsonParser jp = new JsonParser();
		JsonElement je;
		if(type == "Array") {
			je = jp.parse(((JSONArray)jsonObject).toJSONString());
		}
		else {
			je = jp.parse(((JSONObject)jsonObject).toJSONString());
		}
		return gson.toJson(je);
	}

	public static void writeJsonToFile(String path, String jsonString) throws IOException {
		FileWriter file = new FileWriter(path);
		file.write(jsonString);
		file.close();
	}

}
