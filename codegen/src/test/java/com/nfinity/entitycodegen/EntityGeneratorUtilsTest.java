package com.nfinity.entitycodegen;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


@RunWith(SpringJUnit4ClassRunner.class)
public class EntityGeneratorUtilsTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	EntityGeneratorUtils entityGeneratorUtils;
	
    File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(entityGeneratorUtils);
		destPath = folder.newFolder("tempFolder");
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void parseConnectionString_connectionStringIsvalid_returnMap()
	{
		String conn = "jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode";
		Map<String, String> connectionStringMap = new HashMap<String, String>();
		connectionStringMap.put("url", "jdbc:postgresql://localhost:5432/Demo");
		connectionStringMap.put("username", "postgres");
		connectionStringMap.put("password", "fastcode");
		
		Assertions.assertThat(entityGeneratorUtils.parseConnectionString(conn)).isEqualTo(connectionStringMap);
	}
	
	@Test
	public void getPrimaryKeysFromList_fieldsListIsvalid_returnList()
	{
		List<String> primaryKeys= new ArrayList<String>();
		List<FieldDetails> fieldsList= new ArrayList<FieldDetails>();
		FieldDetails details = new FieldDetails();
		details.setFieldName("UserName");
		details.setFieldType("String");
		fieldsList.add(details);
		
		FieldDetails details1 = new FieldDetails();details = new FieldDetails();
		details1.setFieldName("UserId");
		details1.setFieldType("Long");
		details1.setIsPrimaryKey(true);
		fieldsList.add(details1);
		
		primaryKeys.add(details1.getFieldName());
		
		Assertions.assertThat(entityGeneratorUtils.getPrimaryKeysFromList(fieldsList)).isEqualTo(primaryKeys);
	}
	
	@Test
	public void getPrimaryKeysFromMap_fieldsMapIsvalid_returnMap()
	{
		Map<String,String> primaryKeys = new HashMap<>();
		Map<String, FieldDetails> fieldsMap = new HashMap<>();
		FieldDetails details = new FieldDetails();
		details.setFieldName("UserName");
		details.setFieldType("String");
		fieldsMap.put(details.getFieldName(), details);
		
		FieldDetails details1 = new FieldDetails();details = new FieldDetails();
		details1.setFieldName("UserId");
		details1.setFieldType("Long");
		details1.setIsPrimaryKey(true);
		fieldsMap.put(details1.getFieldName(), details1);
		
		primaryKeys.put(details1.getFieldName(),details1.getFieldType());
		Assertions.assertThat(entityGeneratorUtils.getPrimaryKeysFromMap(fieldsMap)).isEqualTo(primaryKeys);
		
	}
	
	@Test
	public void getEntityTemplate_entityNameIsNotNull_returnMap()
	{
		String className = "Entity1";
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entityTemplate/entity.java.ftl", className + "Entity.java");
		
		Assertions.assertThat(entityGeneratorUtils.getEntityTemplate(className)).isEqualTo(backEndTemplate);
	}
	
	@Test
	public void getIdClassTemplate_entityNameIsNotNull_returnMap()
	{
		String className = "Entity1";
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("entityTemplate/idClass.java.ftl", className + "Id.java");
		
		Assertions.assertThat(entityGeneratorUtils.getIdClassTemplate(className)).isEqualTo(backEndTemplate);
	}
	
	@Test
	public void deleteFile_directoryIsValidAndFileExists_returnNothing() throws IOException
	{
		File file = folder.newFile("test.xml");
		entityGeneratorUtils.deleteFile(file.getAbsolutePath());
	}
	
	@Test
	public void deleteDirectory_directoryIsValidAndFileExists_returnNothing() throws IOException
	{
		File file = folder.newFolder("tempFolder","test");
		entityGeneratorUtils.deleteDirectory(file.getAbsolutePath());
	}
	
	
//	@Test
//	public void filterOnlyRelevantEntities_entityNameIsNotNull_returnMap()
//	{
//		String className = "Entity1";
//		Map<String, Object> backEndTemplate = new HashMap<>();
//		backEndTemplate.put("entityTemplate/idClass.java.ftl", className + "Id.java");
//		
//		Assertions.assertThat(entityGeneratorUtils.getEntityTemplate(className)).isEqualTo(backEndTemplate);
//	}
//
//	public List<Class<?>> filterOnlyRelevantEntities(ArrayList<Class<?>> entityClasses) {
//		List<Class<?>> relevantEntities = entityClasses.stream()
//				.filter((e) -> !(e.getName().endsWith("Id$Tokenizer") || e.getName().endsWith("JvCommit") || e.getName().endsWith("JvCommitProperty") || e.getName().endsWith("JvCommitPropertyId") || e.getName().endsWith("JvSnapshot") || e.getName().endsWith("JvGlobalIdent")  ))
//				.collect(Collectors.toList());
//		return relevantEntities;
//	}
//	
//	public List<String> findCompositePrimaryKeyClasses(ArrayList<Class<?>> entityClasses) {
//		List<String> compositeKeyEntities = new ArrayList<>(); 
//		List<Class<?>> otherEntities = entityClasses.stream().filter((e) -> e.getName().endsWith("Id")) 
//				.collect(Collectors.toList()); 
//		List<Class<?>> relevantEntities = entityClasses.stream() 
//				.filter((e) -> !(e.getName().endsWith("Id") || e.getName().endsWith("Id$Tokenizer") || e.getName().endsWith("JvCommit") || e.getName().endsWith("JvCommitProperty") || e.getName().endsWith("JvCommitPropertyId") || e.getName().endsWith("JvSnapshot") || e.getName().endsWith("JvGlobalIdent"))) 
//				.collect(Collectors.toList()); 
//		for (Class<?> currentClass : otherEntities) { 
//			String className = currentClass.getName().substring(0, currentClass.getName().indexOf("Id")); 
//			Class<?> entity = relevantEntities.stream().filter((r) -> r.getName().endsWith(className)).findAny().orElse(null); 
//			if (entity != null) 
//			{
//
//				compositeKeyEntities.add(className.substring(className.lastIndexOf(".")+1));
//			}
//		} 
//		return compositeKeyEntities; 
//	}


}
