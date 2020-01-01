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
	
	//static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String BACKEND_EMAIL_TEMPLATE_FOLDER = "/templates/backendTemplates/emailTemplates/EmailBuilder";
	static final String FRONTEND_EMAIL_TEMPLATE_FOLDER = "/templates/frontendEmailTemplate";
	
	public void generateEmailModuleClasses(String destination,String frontendDestination,String clientSubfolder, String packageName,Boolean history,
			String authenticationType,String schemaName) {

//		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, BACKEND_EMAIL_TEMPLATE_FOLDER + "/");
//		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_EMAIL_TEMPLATE_FOLDER + "/");
//		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl,ctl1 };
//		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
//		cfg.setDefaultEncoding("UTF-8");
//		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
//		cfg.setTemplateLoader(mtl);
//		
		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/") + "/EmailBuilder";
		
		Map<String, Object> root = new HashMap<>();

		root.put("AuditPackage", packageName);
		root.put("PackageName", packageName.concat(".EmailBuilder"));
		root.put("AuthenticationType", authenticationType);
		root.put("History", history);
		root.put("CommonModulePackage" , packageName.concat(".CommonModule"));
		root.put("Schema",schemaName);
		
		frontendDestination = frontendDestination + "/"+ clientSubfolder + "/projects/ip-email-builder";
		new CodeGeneratorUtils().generateFiles(getTemplates(FRONTEND_EMAIL_TEMPLATE_FOLDER, history), root, frontendDestination,FRONTEND_EMAIL_TEMPLATE_FOLDER);
		new CodeGeneratorUtils().generateFiles(getTemplates(BACKEND_EMAIL_TEMPLATE_FOLDER, history), root, backendAppFolder,BACKEND_EMAIL_TEMPLATE_FOLDER);

	}
	
	
	private Map<String, Object> getTemplates(String path, Boolean history){
		List<String> filesList = FolderContentReader.getFilesFromFolder(path);
		Map<String, Object> templates = new HashMap<>();
		
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + path,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + path,"");
			if(history || !p.contains("EmailAuditController")){
				templates.put(p, p.substring(0, p.lastIndexOf('.')));
			}
		}
		
		return templates;
	}
	
	
//	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath,Configuration cfg) {
//		
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
//			
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
	
}
