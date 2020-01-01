package com.nfinity.codegen;

import java.io.File;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

import freemarker.template.Configuration;
import freemarker.template.Template;

public class CodeGeneratorUtils {
	
    public static URL toURL(File file) {
        try {
            return file.toURI().toURL();
        } catch (MalformedURLException e) {
            throw new InternalError(e);
        }
    }
    
    
    public void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath, String templateFolderPath) {
    	Configuration cfg = FreeMarkerConfiguration.configure(templateFolderPath);
    	
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
                System.out.println("file name " +fileName);
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