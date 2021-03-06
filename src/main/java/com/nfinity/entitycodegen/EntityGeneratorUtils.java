package com.nfinity.entitycodegen;

import static java.util.Map.Entry.comparingByKey;
import static java.util.stream.Collectors.toMap;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

@Component
public class EntityGeneratorUtils {
	
	public Map<String, String> parseConnectionString(String connectionString) {
		Map<String, String> connectionStringMap = new HashMap<String, String>();

		String[] urlArr = connectionString.split("\\?");
		connectionStringMap.put("url", urlArr[0]);

		if(!urlArr[1].isEmpty()) {
			String[] paramsArr = urlArr[1].split("\\;");
			for (String param : paramsArr) {
				String[] paramArr = param.split("\\=");
				connectionStringMap.put(paramArr[0], paramArr[1]);
			}
		}

		return connectionStringMap;
	}
	
	public List<String> getPrimaryKeysFromList(List<FieldDetails> fieldsList)
	{
		List<String> primaryKeys= new ArrayList<String>();
		for(FieldDetails f : fieldsList)
		{
			if(f.getIsPrimaryKey())
				primaryKeys.add(f.getFieldName());
		}

		return primaryKeys;
	}

	public Map<String,String> getPrimaryKeysFromMap(Map<String, FieldDetails> fieldsMap)
	{
		Map<String,String> primaryKeys = new HashMap<>();
		for (Map.Entry<String, FieldDetails> entry : fieldsMap.entrySet()) {
			if(entry.getValue().getIsPrimaryKey())
			{
				if(entry.getValue().getFieldType().equalsIgnoreCase("long"))
					primaryKeys.put(entry.getValue().getFieldName(),"Long");
				else
					primaryKeys.put(entry.getValue().getFieldName(), entry.getValue().getFieldType());
			}
		}
		Map<String, String> sortedKeys =primaryKeys
				.entrySet()
				.stream()
				.sorted(comparingByKey())
				.collect(
						toMap(e -> e.getKey(), e -> e.getValue(),
								(e1, e2) -> e2, LinkedHashMap::new));
		return sortedKeys;
	}
	
	public Map<String, Object> getEntityTemplate(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entityTemplate/entity.java.ftl", className + "Entity.java");
		return backEndTemplate;
	}

	public Map<String, Object> getIdClassTemplate(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entityTemplate/idClass.java.ftl", className + "Id.java");
		return backEndTemplate;
	}
	
	public List<Class<?>> filterOnlyRelevantEntities(ArrayList<Class<?>> entityClasses) {
		List<Class<?>> relevantEntities = entityClasses.stream()
				.filter((e) -> !(e.getName().endsWith("Id$Tokenizer") || e.getName().endsWith("JvCommit") || e.getName().endsWith("JvCommitProperty") || e.getName().endsWith("JvCommitPropertyId") || e.getName().endsWith("JvSnapshot") || e.getName().endsWith("JvGlobalIdent")  ))
				.collect(Collectors.toList());
		return relevantEntities;
	}

	public List<String> findCompositePrimaryKeyClasses(ArrayList<Class<?>> entityClasses) {
		List<String> compositeKeyEntities = new ArrayList<>(); 
		List<Class<?>> otherEntities = entityClasses.stream().filter((e) -> e.getName().endsWith("Id")) 
				.collect(Collectors.toList()); 
		List<Class<?>> relevantEntities = entityClasses.stream() 
				.filter((e) -> !(e.getName().endsWith("Id") || e.getName().endsWith("Id$Tokenizer") || e.getName().endsWith("JvCommit") || e.getName().endsWith("JvCommitProperty") || e.getName().endsWith("JvCommitPropertyId") || e.getName().endsWith("JvSnapshot") || e.getName().endsWith("JvGlobalIdent"))) 
				.collect(Collectors.toList()); 
		for (Class<?> currentClass : otherEntities) { 
			String className = currentClass.getName().substring(0, currentClass.getName().indexOf("Id")); 
			Class<?> entity = relevantEntities.stream().filter((r) -> r.getName().endsWith(className)).findAny().orElse(null); 
			if (entity != null) 
			{

				compositeKeyEntities.add(className.substring(className.lastIndexOf(".")+1));
			}
		} 
		return compositeKeyEntities; 
	}
	
	public void deleteFile(String directory) {
		File file = new File(directory);
		if (file.exists()) {
			file.delete();
		}
	}

	public void deleteDirectory(String directory) {
		File file = new File(directory);
		File[] contents = file.listFiles();
		if (contents != null) {
			for (File f : contents) {
				if (f.isDirectory())
					deleteDirectory(f.getAbsolutePath());
				else
					f.delete();
			}
		}
		file.delete();
	}
	
}
