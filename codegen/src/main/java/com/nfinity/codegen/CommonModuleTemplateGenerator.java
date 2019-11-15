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

public class CommonModuleTemplateGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/commonModuleTemplates/CommonModule";
	
	public static void generateCommonModuleClasses(String destination, String packageName) {

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl};
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);
		
		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/");
		
		Map<String, Object> root = new HashMap<>();
		root.put("AuditPackage", packageName);
		packageName = packageName.concat(".CommonModule");
		root.put("PackageName", packageName);
		generateBackendFiles(root, backendAppFolder);

	}
	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
       
        String destFolderBackend;
        destPath=destPath.concat("/CommonModule");
        
        destFolderBackend = destPath;
		new File(destFolderBackend).mkdirs();
		generateFiles(getCommonModuleTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application";
		new File(destFolderBackend).mkdirs();
		generateFiles(getCommonModuleApplicationLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getCommonModuleDomainLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/error" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getCommonModuleErrorTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/logging" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getCommonModuleLoggingTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/Search" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getCommonModuleSearchTemplates(), root, destFolderBackend);
		
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
	
	private static Map<String, Object> getCommonModuleTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("CorsConfig.java.ftl", "CorsConfig.java");

		return backEndTemplate;
	}
	private static Map<String, Object> getCommonModuleApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("application/OffsetBasedPageRequest.java.ftl", "OffsetBasedPageRequest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getCommonModuleDomainLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("domain/emptyJsonResponse.ftl", "EmptyJsonResponse.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getCommonModuleErrorTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("error/ApiError.java.ftl", "ApiError.java");
		backEndTemplate.put("error/ApiSubError.java.ftl", "ApiSubError.java");
		backEndTemplate.put("error/ApiValidationError.java.ftl", "ApiValidationError.java");
		backEndTemplate.put("error/RestExceptionHandler.java.ftl", "RestExceptionHandler.java");
		backEndTemplate.put("error/ExceptionMessageConstants.java.ftl", "ExceptionMessageConstants.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getCommonModuleLoggingTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("logging/LoggingHelper.java.ftl", "LoggingHelper.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getCommonModuleSearchTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("Search/SearchCriteria.java.ftl", "SearchCriteria.java");
		backEndTemplate.put("Search/SearchFields.java.ftl", "SearchFields.java");
		backEndTemplate.put("Search/SearchUtils.java.ftl", "SearchUtils.java");
		
		return backEndTemplate;
	}
	
}
