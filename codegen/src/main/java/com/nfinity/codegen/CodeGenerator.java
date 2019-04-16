package com.nfinity.codegen;

import com.nfinity.entitycodegen.CGenClassLoader;
import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.FieldDetails;
import com.nfinity.entitycodegen.RelationDetails;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CodeGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static String TEMPLATE_FOLDER = "/templates";
	static String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	static String DTO_TEMPLATE_FOLDER = "/templates/backendTemplates/Dto";
	static String CLIENT_ROOT_FOLDER = "/client";
//	static String clientAppFolder = CLIENT_ROOT_FOLDER + "/src/app";
//	static String BACKEND_ROOT_FOLDER = "/backend";
//	static String backendAppFolder = BACKEND_ROOT_FOLDER + "/src/main/java";

	private static Map<String, Object> buildEntityInfo(String entityName,String packageName,Boolean audit, String sourcePath,
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
		root.put("IEntity", "I" + className);
		root.put("IEntityFile", "i" + moduleName);
		root.put("ApiPath", className.toLowerCase());


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
			String sourcePackageName,Boolean audit, String sourcePath, String destPath, String type,Map<String,EntityDetails> details) {

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
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{

			Generate(entry.getKey(), appName,backEndRootFolder,clientRootFolder, sourcePackageName,audit, sourcePath, destPath, type,entry.getValue());

		}

		generateAuditorController(details, appName, backEndRootFolder,destPath);

	}
	
	private static void generateAuditorController(Map<String, EntityDetails> details, String appName,String backEndRootFolder, String destPath){
		String backendAppFolder = backEndRootFolder + "/src/main/java";
		Map<String, Object> entitiesMap = new HashMap<String,Object>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			
			Map<String, String> entityMap = new HashMap<String,String>();
			String key = entry.getKey();
			String name = key.substring(key.lastIndexOf(".") + 1);
			
			entityMap.put("entity" , name + "Entity");
			entityMap.put("importPkg" , appName + ".model." + name + "Entity");
			entityMap.put("requestMapping" , "/" + name.toLowerCase());
			entityMap.put("method" , "get" + name + "Changes");
			
			entitiesMap.put(name, entityMap);
			
		}
		
		Map<String, Object> root = new HashMap<>();
		root.put("entitiesMap", entitiesMap);
		
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/");
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 });
		
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setTemplateLoader(mtl);
		
		Map<String, Object> template = new HashMap<>();
		// Map<String, Object> backEndTemplate = new HashMap<>();
		template.put("AuditController.java.ftl", "AuditController.java");
		
		String destFolder = destPath + "/" + backendAppFolder + "/" + appName.replace(".", "/") + "/ReSTControllers";
		new File(destFolder).mkdirs();
		generateFiles(template, root, destFolder);
		
	}

	public static void Generate(String entityName, String appName, String backEndRootFolder,String clientRootFolder,String packageName,Boolean audit, String sourcePath, String destPath, String type,EntityDetails details) {
	
		String backendAppFolder = backEndRootFolder + "/src/main/java";
		String clientAppFolder = clientRootFolder + "/src/app";
		Map<String, Object> root = buildEntityInfo(entityName,packageName,audit, sourcePath, type, "",details);
		
		Map<String, Object> uiTemplate2DestMapping = getUITemplates(root.get("ModuleName").toString());

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, TEMPLATE_FOLDER + "/"); // "/templates/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/");
		ClassTemplateLoader ctl2 = new ClassTemplateLoader(CodegenApplication.class, DTO_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/Dto");

		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl, ctl1, ctl2 });

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
			} else {
				destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString();
				generateFiles(uiTemplate2DestMapping, root, destFolder);
				destFolder = destPath +"/"+ backendAppFolder + "/" + appName.replace(".", "/");
				generateBackendFiles(root, destFolder);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString());
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
		backEndTemplate.put("findByNameOutput.java.ftl", "Find" + className + "ByNameOutput.java");

		return backEndTemplate;
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
					System.out.println("\n in try ");
					File fileName = new File(destFolder + "/" +  "Get"+ entry.getValue().geteName() + "Output.java");
					PrintWriter writer = new PrintWriter(fileName);
					System.out.println("\nRoot  " + root.toString() );
					template.process(root, writer);
					writer.flush();

				}
				catch ( Exception  e1) {
					e1.printStackTrace();
				}
			}
			else if(entry.getValue().getRelation().equals("ManyToMany"))
			{
				for(String str : relationInput)
				{
					if(entityName.equals(str.substring(str.lastIndexOf("-")+1).toString()))
					{
						List<FieldDetails> relationEntityFields= entry.getValue().getfDetails();
				     	root.put("RelationEntityFields",relationEntityFields);
						root.put("RelationEntityName", entry.getValue().geteName());
						try {
							Template template = cfg.getTemplate("getOutput.java.ftl");
							System.out.println("\n in try ");
							File fileName = new File(destFolder + "/" +  "Get"+ entry.getValue().geteName() + "Output.java");
							PrintWriter writer = new PrintWriter(fileName);
							System.out.println("\nRoot  " + root.toString() );
							template.process(root, writer);
							writer.flush();

						}
						catch ( Exception  e1) {
							e1.printStackTrace();
						}
					}
				}
				
		    }
		}
	}

}
