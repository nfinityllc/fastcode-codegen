package com.nfinity.codegen;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.stereotype.Component;

@Component
public class CommonModuleTemplateGenerator {

	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/commonModuleTemplates/commonmodule";
	
	@Autowired
	CodeGeneratorUtils generatorUtils;
	
	public void generateCommonModuleClasses(String destination, String packageName) {

		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/") + "/commonmodule";
		
		Map<String, Object> root = new HashMap<>();
		packageName = packageName.concat(".commonmodule");
		root.put("PackageName", packageName);
		generatorUtils.generateFiles(getTemplates(BACKEND_TEMPLATE_FOLDER), root, backendAppFolder, BACKEND_TEMPLATE_FOLDER);

	}
	
	public Map<String, Object> getTemplates(String path) {
		List<String> filesList = generatorUtils.readFilesFromDirectory(path);
		filesList = generatorUtils.replaceFileNames(filesList, path);
		Map<String, Object> templates = new HashMap<>();
		
		for (String filePath : filesList) {
			templates.put(filePath, filePath.substring(0, filePath.lastIndexOf('.')));
		}
		
		return templates;
	}

}
