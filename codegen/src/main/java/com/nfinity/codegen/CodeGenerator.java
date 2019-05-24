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
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.apache.commons.io.FileUtils;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CodeGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static String TEMPLATE_FOLDER = "/templates";
	static String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	static String DTO_TEMPLATE_FOLDER = "/templates/backendTemplates/Dto";
	static String UTIL_TEMPLATE_FOLDER = "/templates/backendTemplates/util";
	static String ERROR_TEMPLATE_FOLDER = "/templates/backendTemplates/error";
	static String SEARCH_TEMPLATE_FOLDER = "/templates/backendTemplates/search";
	static String CLIENT_ROOT_FOLDER = "/client";
//	static String clientAppFolder = CLIENT_ROOT_FOLDER + "/src/app";
//	static String BACKEND_ROOT_FOLDER = "/backend";
//	static String backendAppFolder = BACKEND_ROOT_FOLDER + "/src/main/java";

	private static Map<String, Object> buildEntityInfo(String entityName,String packageName,Boolean audit,Boolean history, String sourcePath,
			String type, String modName,EntityDetails details) {
		Map<String, Object> root = new HashMap<>();
		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		//String packageName = className.concat("s");
		String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(className);
		splittedNames[0] = StringUtils.lowerCase(splittedNames[0]);
		String instanceName = StringUtils.join(splittedNames);
		for (int i = 0; i < splittedNames.length; i++) {
			splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
		}
		String moduleName = StringUtils.isNotEmpty(modName) ? modName : StringUtils.join(splittedNames, "-");

		root.put("ModuleName", moduleName);
		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("InstanceName", instanceName);
		root.put("RelationInput",details.getRelationInput());
		root.put("Audit", audit);
		root.put("History", history);
		root.put("IEntity", "I" + className);
		root.put("IEntityFile", "i" + moduleName);
		root.put("ApiPath", className.substring(0, 1).toLowerCase() + className.substring(1));


		Map<String, FieldDetails> actualFieldNames = details.getFieldsMap();

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
	public static void GenerateAll(String backEndRootFolder, String clientRootFolder, String appName,
			String sourcePackageName,Boolean audit,Boolean history, String sourcePath, String destPath, String type,Map<String,EntityDetails> details, String connectionString, String schema) {

		//backendAppFolder = backEndRootFolder + "/src/main/java";
		//clientAppFolder = clientRootFolder + "/src/app";
		//CGenClassLoader loader = new CGenClassLoader(sourcePath);
		// String packageName = "com.ninfinity.entitycodegen.model"; // you can also
		// pass other package names or root package
		// name like com.ninfinity.entitycodegen

		// generate base angular app
		/*File directory = new File(destPath + "/"+ clientRootFolder);
		if (!directory.exists()) {
			directory.mkdir();
		}*/
		//FronendBaseTemplateGenerator.generate(destPath, CLIENT_ROOT_FOLDER);

		// generate all modules for each entity
		List<String> entityNames=new ArrayList<String>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			entityNames.add(className);
			Generate(entry.getKey(), appName,backEndRootFolder,clientRootFolder, sourcePackageName,audit,history, sourcePath, destPath, type,entry.getValue());

		}

		ModifyPomFile.update(destPath + "/" + backEndRootFolder + "/pom.xml");
		if(history)
		generateAuditorController(details, appName, sourcePackageName,backEndRootFolder,destPath);
		
		updateAppRouting(destPath,appName.substring(appName.lastIndexOf(".") + 1), entityNames);
	    updateAppModule(destPath,appName.substring(appName.lastIndexOf(".") + 1), entityNames);
	    updateTestUtils(destPath,appName.substring(appName.lastIndexOf(".") + 1), entityNames);
	    updateEntitiesJsonFile(destPath + "/" + appName.substring(appName.lastIndexOf(".") + 1) + "Client/src/app/common/components/main-nav/entities.json",entityNames);
	    
	    Map<String,Object> propertyInfo = getInfoForApplicationPropertiesFile(appName.substring(appName.lastIndexOf(".") + 1), connectionString, schema);
		generateApplicationProperties(propertyInfo, destPath + "/" + backEndRootFolder + "/src/main/resources");

	}
	
	private static Map<String,Object> getInfoForApplicationPropertiesFile(String appName, String connectionString, String schema){
		Map<String,Object> propertyInfo = new HashMap<String,Object>();
		
		propertyInfo.put("connectionStringInfo", EntityGenerator.parseConnectionString(connectionString));
		propertyInfo.put("appName", appName);
		propertyInfo.put("schema", schema);
		
		return propertyInfo;
	}
	
	private static void generateAuditorController(Map<String, EntityDetails> details, String appName,String packageName,String backEndRootFolder, String destPath){
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
		
		Map<String, Object> root = new HashMap<>();
		root.put("entitiesMap", entitiesMap);
		root.put("PackageName", packageName);
		
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/");
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 });
		
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(mtl);
		
		Map<String, Object> template = new HashMap<>();
		template.put("AuditController.java.ftl", "AuditController.java");
		
		String destFolder = destPath + "/" + backendAppFolder + "/" + appName.replace(".", "/") + "/RestControllers";
		new File(destFolder).mkdirs();
		generateFiles(template, root, destFolder);
		
	}

	public static void Generate(String entityName, String appName, String backEndRootFolder,String clientRootFolder,String packageName,Boolean audit,Boolean history, String sourcePath, String destPath, String type,EntityDetails details) {
	
		String backendAppFolder = backEndRootFolder + "/src/main/java";
		String clientAppFolder = clientRootFolder + "/src/app";
		Map<String, Object> root = buildEntityInfo(entityName,packageName,audit,history, sourcePath, type, "",details);
		
		Map<String, Object> uiTemplate2DestMapping = getUITemplates(root.get("ModuleName").toString());

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, TEMPLATE_FOLDER + "/"); // "/templates/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/");
		ClassTemplateLoader ctl2 = new ClassTemplateLoader(CodegenApplication.class, DTO_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/Dto");
		ClassTemplateLoader ctl3 = new ClassTemplateLoader(CodegenApplication.class, UTIL_TEMPLATE_FOLDER + "/");
		ClassTemplateLoader ctl4 = new ClassTemplateLoader(CodegenApplication.class, ERROR_TEMPLATE_FOLDER + "/");
		ClassTemplateLoader ctl5 = new ClassTemplateLoader(CodegenApplication.class, SEARCH_TEMPLATE_FOLDER + "/");
		
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl, ctl1, ctl2,ctl3,ctl4,ctl5});

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
				generateBackendFiles(root, destFolder);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString());
				generateUtilsAndCorsConfig(root, destFolder);
				generateError(root, destFolder);
				generateSearch(root, destFolder);
			} else {
				destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString();
				generateFiles(uiTemplate2DestMapping, root, destFolder);
				destFolder = destPath +"/"+ backendAppFolder + "/" + appName.replace(".", "/");
				generateBackendFiles(root, destFolder);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString());
				generateUtilsAndCorsConfig(root, destFolder);
				generateError(root, destFolder);
				generateSearch(root, destFolder);
			}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}

	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
		String destFolderBackend = destPath + "/application/" + root.get("ClassName").toString();
		new File(destFolderBackend).mkdirs();
		generateFiles(getApplicationTemplates(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/application/" + root.get("ClassName").toString() + "/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getDtos(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/" + root.get("ClassName").toString();
		new File(destFolderBackend).mkdirs();
		generateFiles(getDomainTemplates(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/IRepository";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRepositoryTemplates(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/RestControllers";
		new File(destFolderBackend).mkdirs();
		generateFiles(getControllerTemplates(root.get("ClassName").toString()), root, destFolderBackend);
	}

	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());
				File fileName = new File(destPath + "/" + entry.getValue().toString());
				PrintWriter writer = new PrintWriter(fileName);
				System.out.println("\nRoot  " + root.toString());
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

	private static Map<String, Object> getRepositoryTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("irepository.java.ftl", "I" + className + "Repository.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getControllerTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("controller.java.ftl", className + "Controller.java");
		backEndTemplate.put("emptyJsonResponse.java.ftl","EmptyJsonResponse.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getDomainTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("manager.java.ftl", className + "Manager.java");
		backEndTemplate.put("imanager.java.ftl", "I" + className + "Manager.java");
		backEndTemplate.put("managerTest.java.ftl", className + "ManagerTest.java");
	
		return backEndTemplate;
	}

	private static Map<String, Object> getDtos(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("createInput.java.ftl", "Create" + className + "Input.java");
		backEndTemplate.put("createOutput.java.ftl", "Create" + className + "Output.java");
		backEndTemplate.put("updateInput.java.ftl", "Update" + className + "Input.java");
		backEndTemplate.put("updateOutput.java.ftl", "Update" + className + "Output.java");
		backEndTemplate.put("findByIdOutput.java.ftl", "Find" + className + "ByIdOutput.java");
		return backEndTemplate;
	}
	
	private static void generateUtilsAndCorsConfig(Map<String, Object> root, String destPath)
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("loggingHelper.java.ftl", "LoggingHelper.java");
		backEndTemplate.put("offsetBasedPageRequest.java.ftl", "OffsetBasedPageRequest.java");
		String destFolder = destPath + "/Utils";
		new File(destFolder).mkdirs();
		generateFiles(backEndTemplate, root, destFolder);
		backEndTemplate=new HashMap<>();
		backEndTemplate.put("corsConfig.java.ftl","CorsConfig.java");
		generateFiles(backEndTemplate, root, destPath);
	}
	
	private static void generateError(Map<String, Object> root, String destPath)
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("apiError.java.ftl", "ApiError.java");
		backEndTemplate.put("apiSubError.java.ftl", "ApiSubError.java");
		backEndTemplate.put("apiValidationError.java.ftl", "ApiValidationError.java");
		backEndTemplate.put("restExceptionHandler.java.ftl", "RestExceptionHandler.java");
		String destFolder = destPath + "/Error";
		new File(destFolder).mkdirs();
		generateFiles(backEndTemplate, root, destFolder);
	}

	private static void generateSearch(Map<String, Object> root, String destPath)
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("searchCriteria.java.ftl", "SearchCriteria.java");
		backEndTemplate.put("searchFields.java.ftl", "SearchFields.java");
		String destFolder = destPath + "/Search";
		new File(destFolder).mkdirs();
		generateFiles(backEndTemplate, root, destFolder);
	}
	
	private static void generateRelationDto(EntityDetails details,Map<String,Object> root, String destPath,String entityName)
	{
		

		String destFolder = destPath + "/application/" + root.get("ClassName").toString() + "/Dto";
		new File(destFolder).mkdirs();

		Map<String,RelationDetails> relationDetails = details.getRelationsMap();
		List<String> relationInput = details.getRelationInput();

		for (Map.Entry<String, RelationDetails> entry : relationDetails.entrySet()) {
			if(entry.getValue().getRelation().equals("ManyToOne"))
			{
				List<FieldDetails> relationEntityFields= entry.getValue().getfDetails();
		     	root.put("RelationEntityFields",relationEntityFields);
				root.put("RelationEntityName", entry.getValue().geteName());
				try {
					Template template = cfg.getTemplate("getOutput.java.ftl");
					File fileName = new File(destFolder + "/" +  "Get"+ entry.getValue().geteName() + "Output.java");
					PrintWriter writer = new PrintWriter(fileName);
					System.out.println("\nRoot  " + root.toString() );
					template.process(root, writer);
					writer.flush();
					writer.close();

				}
				catch ( Exception  e1) {
					e1.printStackTrace();
				}
			}
			else if(entry.getValue().getRelation().equals("ManyToMany"))
			{
				for(String str : relationInput)
				{
					if(entityName.equals(str.substring(0,str.lastIndexOf("-")).toString()))
					{
						List<FieldDetails> relationEntityFields= entry.getValue().getfDetails();
				     	root.put("RelationEntityFields",relationEntityFields);
						root.put("RelationEntityName", entry.getValue().geteName());
						try {
							Template template = cfg.getTemplate("getOutput.java.ftl");
							File fileName = new File(destFolder + "/" +  "Get"+ entry.getValue().geteName() + "Output.java");
							PrintWriter writer = new PrintWriter(fileName);
							System.out.println("\nRoot  " + root.toString() );
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
		}
	}
	
	private static void generateApplicationProperties(Map<String, Object> root, String destPath)
	{
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
	
	public static void updateAppRouting(String destPath,String appName, List<String> entityName)
	{
		StringBuilder sourceBuilder=new StringBuilder();

		for(String str: entityName)
		{
		sourceBuilder.append("\n  " +" { path: '" + str.toLowerCase() + "', component: " + str + "ListComponent, canActivate: [ AuthGuard ]  },");
		sourceBuilder.append("\n  " + " { path: '" + str.toLowerCase() + "/new', component: " + str + "NewComponent ,canActivate: [ AuthGuard ]  }," + "\n");
		sourceBuilder.append("\n  " + " { path: '" + str.toLowerCase() + "/:id', component: " +str + "DetailsComponent ,canActivate: [ AuthGuard ]  }," );
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
	
	public static void updateEntitiesJsonFile(String path,List<String> entityNames) {

		try {
            JSONArray entityArray = (JSONArray) readJsonFile(path);
            for(String entityName: entityNames)
    		{
            	entityArray.add(entityName.toLowerCase());
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
