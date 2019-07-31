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

public class EmailModuleTemplateGenerator {
	
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/emailTemplates/EmailBuilder";
	static final String FRONTEND_EMAIL_TEMPLATE_FOLDER = "/templates/frontendEmailTemplate";
	
	public static void generateEmailModuleClasses(String destination,String frontendDestination,String clientSubfolder, String packageName,Boolean audit,Boolean history,
			String authenticationType,String schemaName) {

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_EMAIL_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl,ctl1 };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);
		
		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/");
		
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", packageName.concat(".EmailBuilder"));
		root.put("AuthenticationType", authenticationType);
		root.put("Audit", audit);
		root.put("History", history);
		root.put("CommonModulePackage" , packageName.concat(".CommonModule"));
		root.put("Schema",schemaName);
		
		List<String> filesList = FolderContentReader.getFilesFromFolder(FRONTEND_EMAIL_TEMPLATE_FOLDER);
		Map<String, Object> frontendTemplates = new HashMap<>();
		
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_EMAIL_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_EMAIL_TEMPLATE_FOLDER,"");
			frontendTemplates.put(p, p.substring(0, p.lastIndexOf('.')));
		}

		generateFiles(frontendTemplates,root, frontendDestination + "/"+ clientSubfolder + "/projects");
		generateBackendFiles(root, backendAppFolder);

	}
	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
       
        String destFolderBackend;
        destPath=destPath.concat("/EmailBuilder");
       
        new File(destPath).mkdirs();
		generateFiles(getEmailConfigurationTemplate(), root, destPath);
		
		destFolderBackend = destPath + "/application/EmailTemplate";
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailTemplateApplicationLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/EmailTemplate/Dto" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailTemplateDtoTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/EmailTemplate" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailTemplateManagerLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/EmailVariable" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailVariableApplicationLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/EmailVariable/Dto" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailVariableDtoTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/EmailVariable" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailVariableManagerLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/mail" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getMailTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/model" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailEntitiesTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/IRepository" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailRepositoriesTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/RestControllers" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailControllerTemplates(Boolean.parseBoolean(root.get("History").toString())), root, destFolderBackend);
		
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
	
	private static Map<String, Object> getEmailConfigurationTemplate() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("MailConfiguration.ftl", "MailConfiguration.java");
		return backEndTemplate;
	}
	private static Map<String, Object> getEmailTemplateApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/EmailTemplate/IEmailTemplateAppService.ftl", "IEmailTemplateAppService.java");
		backEndTemplate.put("application/EmailTemplate/EmailTemplateAppService.ftl", "EmailTemplateAppService.java");
		backEndTemplate.put("application/EmailTemplate/EmailTemplateMapper.ftl", "EmailTemplateMapper.java");
		backEndTemplate.put("application/EmailTemplate/EmailTemplateAppServiceTest.ftl", "EmailTemplateAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailTemplateManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("domain/EmailTemplate/IEmailTemplateManager.ftl", "IEmailTemplateManager.java");
		backEndTemplate.put("domain/EmailTemplate/EmailTemplateManager.ftl", "EmailTemplateManager.java");
		backEndTemplate.put("domain/EmailTemplate/EmailTemplateManagerTest.ftl", "EmailTemplateManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailVariableApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/EmailVariable/IEmailVariableAppService.ftl", "IEmailVariableAppService.java");
		backEndTemplate.put("application/EmailVariable/EmailVariableAppService.ftl", "EmailVariableAppService.java");
		backEndTemplate.put("application/EmailVariable/EmailVariableMapper.ftl", "EmailVariableMapper.java");
		backEndTemplate.put("application/EmailVariable/EmailVariableAppServiceTest.ftl", "EmailVariableAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailVariableManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("domain/EmailVariable/IEmailVariableManager.ftl", "IEmailVariableManager.java");
		backEndTemplate.put("domain/EmailVariable/EmailVariableManager.ftl", "EmailVariableManager.java");
		backEndTemplate.put("domain/EmailVariable/EmailVariableManagerTest.ftl", "EmailVariableManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getMailTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/Mail/IEmailService.ftl", "IEmailService.java");
		backEndTemplate.put("application/Mail/EmailService.ftl", "EmailService.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailTemplateDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/EmailTemplate/Dto/CreateEmailTemplateInput.ftl", "CreateEmailTemplateInput.java");
		backEndTemplate.put("application/EmailTemplate/Dto/CreateEmailTemplateOutput.ftl", "CreateEmailTemplateOutput.java");
		backEndTemplate.put("application/EmailTemplate/Dto/UpdateEmailTemplateInput.ftl", "UpdateEmailTemplateInput.java");
		backEndTemplate.put("application/EmailTemplate/Dto/UpdateEmailTemplateOutput.ftl", "UpdateEmailTemplateOutput.java");
		backEndTemplate.put("application/EmailTemplate/Dto/FindEmailTemplateByIdOutput.ftl", "FindEmailTemplateByIdOutput.java");
		backEndTemplate.put("application/EmailTemplate/Dto/FindEmailTemplateByNameOutput.ftl", "FindEmailTemplateByNameOutput.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailVariableDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/EmailVariable/Dto/CreateEmailVariableInput.ftl", "CreateEmailVariableInput.java");
		backEndTemplate.put("application/EmailVariable/Dto/CreateEmailVariableOutput.ftl", "CreateEmailVariableOutput.java");
		backEndTemplate.put("application/EmailVariable/Dto/UpdateEmailVariableInput.ftl", "UpdateEmailVariableInput.java");
		backEndTemplate.put("application/EmailVariable/Dto/UpdateEmailVariableOutput.ftl", "UpdateEmailVariableOutput.java");
		backEndTemplate.put("application/EmailVariable/Dto/FindEmailVariableByIdOutput.ftl", "FindEmailVariableByIdOutput.java");
		backEndTemplate.put("application/EmailVariable/Dto/FindEmailVariableByNameOutput.ftl", "FindEmailVariableByNameOutput.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailControllerTemplates(Boolean history) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(history) {
		backEndTemplate.put("RestControllers/EmailAuditController.ftl", "EmailAuditController.java");
		}
		backEndTemplate.put("RestControllers/EmailTemplateController.ftl", "EmailTemplateController.java");
		backEndTemplate.put("RestControllers/HtmlEmailController.ftl", "HtmlEmailController.java");
		backEndTemplate.put("RestControllers/MailController.ftl", "MailController.java");
		backEndTemplate.put("RestControllers/EmailVariableController.ftl", "EmailVariableController.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailRepositoriesTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("domain/IRepository/IEmailTemplateRepository.ftl", "IEmailTemplateRepository.java");
		backEndTemplate.put("domain/IRepository/IEmailVariableRepository.ftl", "IEmailVariableRepository.java");
	
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailEntitiesTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();
		
		backEndTemplate.put("domain/model/EmailTemplateEntity.ftl", "EmailTemplateEntity.java");
		backEndTemplate.put("domain/model/EmailVariableEntity.ftl", "EmailVariableEntity.java");

		return backEndTemplate;
	}

}
