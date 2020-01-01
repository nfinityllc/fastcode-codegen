package com.nfinity.codegen;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nfinity.entitycodegen.EntityGenerator;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class SchedulerModuleTemplateGenerator {
	
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/SchedulerModuleTemplates/Scheduler";
	static final String FRONTEND_SCHEDULER_TEMPLATE_FOLDER = "/templates/frontendSchedulerTemplates";
	
	public void generateSchedulerModuleClasses(String destination,String frontendDestination,String clientSubfolder, String packageName,
			Boolean history,String schemaName,String connectionString, String authenticationType) {

		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/");
		Map<String, Object> root = new HashMap<>();
		root.put("AuditPackage", packageName);
		root.put("PackageName", packageName.concat(".Scheduler"));
		root.put("History", history);
		root.put("CommonModulePackage" , packageName.concat(".CommonModule"));
		root.put("Schema",schemaName);
		root.put("AuthenticationType", authenticationType);
		
		Map<String, Object> frontendTemplates = getFrontendTemplates();

		new CodeGeneratorUtils().generateFiles(frontendTemplates,root, frontendDestination + "/"+ clientSubfolder + "/projects/scheduler",FRONTEND_SCHEDULER_TEMPLATE_FOLDER);
		new CodeGeneratorUtils().generateFiles(getTemplates(history), root, backendAppFolder.concat("/Scheduler"),BACKEND_TEMPLATE_FOLDER);
		
		Map<String,Object> propertyInfo = getInfoForQuartzPropertiesFile(connectionString, schemaName);
		generateQuartzProperties(propertyInfo, destination + "/src/main/resources");

	}
	
	private static Map<String, Object> getFrontendTemplates() {
		List<String> filesList = FolderContentReader.getFilesFromFolder(FRONTEND_SCHEDULER_TEMPLATE_FOLDER);
		Map<String, Object> frontendTemplates = new HashMap<>();
		
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_SCHEDULER_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_SCHEDULER_TEMPLATE_FOLDER,"");
			frontendTemplates.put(p, p.substring(0, p.lastIndexOf('.')));
		}
		
		return frontendTemplates;
	}
	
	private Map<String, Object> getTemplates(Boolean history){
		List<String> filesList = FolderContentReader.getFilesFromFolder(BACKEND_TEMPLATE_FOLDER);
		Map<String, Object> templates = new HashMap<>();
		
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + BACKEND_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + BACKEND_TEMPLATE_FOLDER,"");
			//String outputFileName = p.substring(0, p.lastIndexOf('.'));
			if(!p.contains("quartz.properties.ftl"))
			templates.put(p, p.substring(0, p.lastIndexOf('.')));
			
			
		}
		
		return templates;
	}

	private static Map<String,Object> getInfoForQuartzPropertiesFile(String connectionString, String schemaName){
		Map<String,Object> propertyInfo = new HashMap<String,Object>();

		propertyInfo.put("connectionStringInfo", new EntityGenerator().parseConnectionString(connectionString));
		propertyInfo.put("Schema", schemaName);
		
		return propertyInfo;
	}

	
	private static void generateQuartzProperties(Map<String, Object> root, String destPath)
	{

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("quartz.properties.ftl", "quartz.properties");
		new File(destPath).mkdirs();
		new CodeGeneratorUtils().generateFiles(backEndTemplate, root, destPath,BACKEND_TEMPLATE_FOLDER);
	}

}
