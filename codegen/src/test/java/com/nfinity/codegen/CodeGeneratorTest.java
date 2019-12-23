package com.nfinity.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.mock;
import static org.mockito.ArgumentMatchers.any;

import java.util.HashMap;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.FieldDetails;
import com.nfinity.entitycodegen.RelationDetails;

@RunWith(SpringJUnit4ClassRunner.class)
public class CodeGeneratorTest {
	
	@InjectMocks
	CodeGenerator codeGenerator;
	
	@Mock
	CodeGenerator mockedCodeGenerator;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(codeGenerator);

	}
	
	String testValue = "abc";

	@After
	public void tearDown() throws Exception {
	}
	
	@Test 
	public void buildEntityInfo_parameterListIsValid_ReturnMap()
	{
		Assertions.assertThat(codeGenerator.buildEntityInfo(testValue,testValue,true,testValue,testValue, new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue)
				,testValue,true,testValue,testValue,true,true)).size().isEqualTo(24);
	}
	
	@Test
	public void convertCamelCaseToKebaCase_StringIsValid_ReturnString()
	{
		String str = "testString";
		
		Assertions.assertThat(CodeGenerator.camelCaseToKebabCase(str)).isEqualTo("test-string");
	}
	
	@Test
	public void generateAllModulesForEntities_detailsMapIsNotEmpty_ReturnList()
	{
		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		EntityDetails entityDetails = new EntityDetails();
		details.put("com.fastcode.Entity1",new EntityDetails());
		details.put("com.fastcode.Entity2",new EntityDetails());
		
		
		Mockito.doNothing().when(mockedCodeGenerator).Generate(testValue, testValue, testValue, testValue, testValue, true, testValue, testValue,testValue, new EntityDetails(), testValue, true, true, true, testValue, testValue, true);
		
		Assertions.assertThat(codeGenerator.generateAllModulesForEntities(details, testValue, testValue, testValue, true, true, testValue, testValue, testValue, testValue, testValue, true, true, true, testValue).size()).isEqualTo(2);
	}
}
