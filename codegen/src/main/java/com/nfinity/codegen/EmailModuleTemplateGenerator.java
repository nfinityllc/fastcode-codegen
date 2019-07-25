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
	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	static final String FRONTEND_EMAIL_TEMPLATE_FOLDER = "/templates/frontendEmailTemplate";
	
	public static void generateEmailModuleClasses(String destination,String clientSubfolder, String packageName,Boolean audit,Boolean history
			,String schemaName) {

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_EMAIL_TEMPLATE_FOLDER + "/");
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
		
		List<String> filesList = FolderContentReader.getFilesFromFolder(FRONTEND_EMAIL_TEMPLATE_FOLDER);
		Map<String, Object> frontendTemplates = new HashMap<>();
		
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_EMAIL_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_EMAIL_TEMPLATE_FOLDER,"");
			frontendTemplates.put(p, p.substring(0, p.lastIndexOf('.')));
		}

		generateFiles(frontendTemplates,root, destination + "/"+ clientSubfolder);
		generateBackendFiles(root, backendAppFolder);

	}
	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
       
        String destFolderBackend;
     
		destFolderBackend = destPath + "/application/Email";
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailTemplateApplicationLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/Email/Dto" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getEmailTemplateDtoTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/Email" ;
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
		
		destFolderBackend = destPath + "/mail" ;
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
		generateFiles(getEmailControllerTemplates(), root, destFolderBackend);
		
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
	
	private static Map<String, Object> getEmailTemplateApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailTemplates/IEmailAppService.ftl", "IEmailAppService.java");
		backEndTemplate.put("emailTemplates/EmailAppService.ftl", "EmailAppService.java");
		backEndTemplate.put("emailTemplates/EmailMapper.ftl", "EmailMapper.java");
		backEndTemplate.put("emailTemplates/EmailAppServiceTest.ftl", "EmailAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailTemplateManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailTemplates/IEmailManager.ftl", "IEmailManager.java");
		backEndTemplate.put("emailTemplates/EmailManager.ftl", "EmailManager.java");
		backEndTemplate.put("emailTemplates/EmailManagerTest.ftl", "EmailManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailVariableApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailVariableTemplates/IEmailVariableAppService.ftl", "IEmailVariableAppService.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableAppService.ftl", "EmailVariableAppService.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableMapper.ftl", "EmailVariableMapper.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableAppServiceTest.ftl", "EmailVariableAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailVariableManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailVariableTemplates/IEmailVariableManager.ftl", "IEmailVariableManager.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableManager.ftl", "EmailVariableManager.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableManagerTest.ftl", "EmailVariableManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getMailTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailTemplates/IEmailService.ftl", "IEmailService.java");
		backEndTemplate.put("emailTemplates/EmailService.ftl", "EmailService.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailTemplateDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailTemplates/Dto/CreateEmailInput.ftl", "CreateEmailInput.java");
		backEndTemplate.put("emailTemplates/Dto/CreateEmailOutput.ftl", "CreateEmailOutput.java");
		backEndTemplate.put("emailTemplates/Dto/UpdateEmailInput.ftl", "UpdateEmailInput.java");
		backEndTemplate.put("emailTemplates/Dto/UpdateEmailOutput.ftl", "UpdateEmailOutput.java");
		backEndTemplate.put("emailTemplates/Dto/FindEmailByIdOutput.ftl", "FindEmailByIdOutput.java");
		backEndTemplate.put("emailTemplates/Dto/FindEmailByNameOutput.ftl", "FindEmailByNameOutput.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailVariableDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailVariableTemplates/Dto/CreateEmailVariableInput.ftl", "CreateEmailVariableInput.java");
		backEndTemplate.put("emailVariableTemplates/Dto/CreateEmailVariableOutput.ftl", "CreateEmailVariableOutput.java");
		backEndTemplate.put("emailVariableTemplates/Dto/UpdateEmailVariableInput.ftl", "UpdateEmailVariableInput.java");
		backEndTemplate.put("emailVariableTemplates/Dto/UpdateEmailVariableOutput.ftl", "UpdateEmailVariableOutput.java");
		backEndTemplate.put("emailVariableTemplates/Dto/FindEmailVariableByIdOutput.ftl", "FindEmailVariableByIdOutput.java");
		backEndTemplate.put("emailVariableTemplates/Dto/FindEmailVariableByNameOutput.ftl", "FindEmailVariableByNameOutput.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailControllerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();
		
		backEndTemplate.put("emailTemplates/EmailController.ftl", "EmailController.java");
		backEndTemplate.put("emailTemplates/HtmlEmailController.ftl", "HtmlEmailController.java");
		backEndTemplate.put("emailTemplates/MailController.ftl", "MailController.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableController.ftl", "EmailVariableController.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailRepositoriesTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("emailTemplates/IEmailRepository.ftl", "IEmailRepository.java");
		backEndTemplate.put("emailVariableTemplates/IEmailVariableRepository.ftl", "IEmailVariableRepository.java");
	
		return backEndTemplate;
	}
	
	private static Map<String, Object> getEmailEntitiesTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();
		
		backEndTemplate.put("emailTemplates/EmailEntity.ftl", "EmailEntity.java");
		backEndTemplate.put("emailVariableTemplates/EmailVariableEntity.ftl", "EmailVariableEntity.java");

		return backEndTemplate;
	}

}
