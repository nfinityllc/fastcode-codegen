package com.nfinity.codegen;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class FlowableFrontendCodeGenerator {
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String FRONTEND_FLOWABLEADMIN_FOLDER = "/src/main/resources/flowable_admin";
	static final String FRONTEND_FLOWABLETASK_TEMPLATE_FOLDER = "/templates/frontendFlowableTaskTemplates";

	public static void generate(String destination, String clientSubfolder) {
		
		try {
			copyDirectoryUsingApache(new File(System.getProperty("user.dir").replace("\\", "/") + FRONTEND_FLOWABLEADMIN_FOLDER), new File(destination + "/"+ clientSubfolder + "/src/flowable_admin"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		List<String> fl = FolderContentReader.getFilesFromFolder(FRONTEND_FLOWABLETASK_TEMPLATE_FOLDER);
		Map<String, Object> templates = new HashMap<>();

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_FLOWABLETASK_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);

		for (String filePath : fl) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_FLOWABLETASK_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_FLOWABLETASK_TEMPLATE_FOLDER,"");
			templates.put(p, p.substring(0, p.lastIndexOf('.')));
		}

		generateFiles(templates,null, destination + "/"+ clientSubfolder + "/projects");
	}

    public static void copyDirectoryUsingApache(File from, File to) throws IOException{
    FileUtils.copyDirectory(from,to);
    }
	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());

				String entryPath = entry.getValue().toString();
				File fileName = new File(destPath + "/" + entryPath); /// new File(destPath + "/" +
				String dirPath = destPath;
				if(destPath.split("/").length > 1) {
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
		

}
