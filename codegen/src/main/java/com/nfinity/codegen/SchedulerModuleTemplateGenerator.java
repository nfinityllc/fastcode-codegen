package com.nfinity.codegen;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class SchedulerModuleTemplateGenerator {
	
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/SchedulerModuleTemplates";
	static final String FRONTEND_SCHEDULER_TEMPLATE_FOLDER = "/templates/frontendSchedulerTemplates";
	
	public static void generateSchedulerModuleClasses(String destination,String clientSubfolder, String packageName,Boolean audit,Boolean history
			,String schemaName) {

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_SCHEDULER_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl,ctl1 };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);
		
		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/");
		
		Map<String, Object> root = new HashMap<>();
		System.out.println("PASSS "+ packageName);
		root.put("PackageName", packageName);
		root.put("Audit", audit);
		root.put("History", history);
		root.put("CommonModulePackage" , "com.nfinity.fastcode");
		root.put("Schema",schemaName);
		
		List<String> filesList = ReadFiles.getFilesFromFolder(FRONTEND_SCHEDULER_TEMPLATE_FOLDER);
		Map<String, Object> frontendTemplates = new HashMap<>();
		
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_SCHEDULER_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_SCHEDULER_TEMPLATE_FOLDER,"");
			frontendTemplates.put(p, p.substring(0, p.lastIndexOf('.')));
		}

		generateFiles(frontendTemplates,root, destination + "/"+ clientSubfolder);
		generateBackendFiles(root, backendAppFolder);

	}
	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
       
        String destFolderBackend;
     
        destFolderBackend = destPath ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerConfigurationTemplates(), root, destFolderBackend);
        
		destFolderBackend = destPath + "/application/Scheduler/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerDtoTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/SchedulerService" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerServiceTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/jobs" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerJobsTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/Constants" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerConstantsTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/error" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerErrorTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/Scheduler" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerManagerTemplates(), root, destFolderBackend);
		
		
		destFolderBackend = destPath + "/domain/model" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerEntitiesTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/IRepository" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerRepositoriesTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/RestControllers" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSchedulerControllerTemplates(), root, destFolderBackend);
		
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
				System.out.println(dirPath);
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
	
	private static Map<String, Object> getSchedulerServiceTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("SchedulerService/CGenClassLoader.ftl", "CGenClassLoader.java");
		backEndTemplate.put("SchedulerService/JobsListener.ftl", "JobsListener.java");
		backEndTemplate.put("SchedulerService/SchedulerService.ftl", "SchedulerService.java");
		backEndTemplate.put("SchedulerService/SchedulerServiceTest.ftl", "SchedulerServiceTest.java");
		backEndTemplate.put("SchedulerService/SchedulerServiceUtil.ftl", "SchedulerServiceUtil.java");
		backEndTemplate.put("SchedulerService/SchedulerServiceUtilTest.ftl", "SchedulerServiceUtilTest.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerManagerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("domain/Scheduler/IJobHistoryManager.ftl", "IJobHistoryManager.java");
		backEndTemplate.put("domain/Scheduler/JobHistoryManager.ftl", "JobHistoryManager.java");
		backEndTemplate.put("domain/Scheduler/JobDetailsManager.ftl", "JobDetailsManager.java");
		backEndTemplate.put("domain/Scheduler/TriggerDetailsManager.ftl", "TriggerDetailsManager.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerErrorTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("error/ApiError.ftl", "ApiError.java");
		backEndTemplate.put("error/ApiSubError.ftl", "ApiSubError.java");
		backEndTemplate.put("error/RestExceptionHandler.ftl", "RestExceptionHandler.java");
	
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerJobsTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("jobs/sampleJob.ftl", "sampleJob.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerConstantsTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("Constants/QuartzConstants.ftl", "QuartzConstants.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerConfigurationTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("AutowiringSpringBeanJobFactory.ftl", "AutowiringSpringBeanJobFactory.java");
		backEndTemplate.put("BeanUtil.ftl", "BeanUtil.java");
		backEndTemplate.put("QuartzSchedulerConfig.ftl", "QuartzSchedulerConfig.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/Scheduler/Dto/FindByJobInput.ftl", "FindByJobInput.java");
		backEndTemplate.put("application/Scheduler/Dto/GetJobOutput.ftl", "GetJobOutput.java");
		backEndTemplate.put("application/Scheduler/Dto/GetTriggerOutput.ftl", "GetTriggerOutput.java");
		backEndTemplate.put("application/Scheduler/Dto/JobDetails.ftl", "JobDetails.java");
		backEndTemplate.put("application/Scheduler/Dto/JobListOutput.ftl", "JobListOutput.java");
		backEndTemplate.put("application/Scheduler/Dto/TriggerCreationDetails.ftl", "TriggerCreationDetails.java");
		backEndTemplate.put("application/Scheduler/Dto/TriggerDetails.ftl", "TriggerDetails.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerControllerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();
		
		backEndTemplate.put("RestControllers/JobController.ftl", "JobController.java");
		backEndTemplate.put("RestControllers/TriggerController.ftl", "TriggerController.java");
	
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerRepositoriesTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("domain/IRepository/IJobDetailsRepository.ftl", "IJobDetailsRepository.java");
		backEndTemplate.put("domain/IRepository/IJobHistoryRepository.ftl", "IJobHistoryRepository.java");
		backEndTemplate.put("domain/IRepository/ITriggerDetailsRepository.ftl", "ITriggerDetailsRepository.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSchedulerEntitiesTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();
		
		backEndTemplate.put("domain/Scheduler/JobDetailsEntity.ftl", "JobDetailsEntity.java");
		backEndTemplate.put("domain/Scheduler/JobHistoryEntity.ftl", "JobHistoryEntity.java");
		backEndTemplate.put("domain/Scheduler/TriggerDetailsEntity.ftl", "TriggerDetailsEntity.java");
		
		return backEndTemplate;
	}

}
