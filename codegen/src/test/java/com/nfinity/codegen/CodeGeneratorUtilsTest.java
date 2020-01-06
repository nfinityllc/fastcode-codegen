package com.nfinity.codegen;

import static org.mockito.ArgumentMatchers.anyString;

import java.io.File;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
public class CodeGeneratorUtilsTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	CodeGeneratorUtils codeGeneratorUtils;
	
	@Mock
	CodeGenerator mockedCodeGenerator;
	
	@Mock
	CodeGeneratorUtils mockedUtils;
	
	@Mock
	FolderContentReader folderContentReader;
	
    File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(codeGeneratorUtils);
		destPath = folder.newFolder("tempFolder");
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void toUrl_PathIsValid_ReturnURI() throws MalformedURLException {
		Assertions.assertThat(codeGeneratorUtils.toURL(destPath)).isEqualTo(destPath.toURI().toURL());
	}
	
	@Test
	public void readFilesFromDirectory_PathIsValid_ReturnList() throws MalformedURLException {
		
		List<String> filesList = new ArrayList<String>();
        filesList.add("/SearchUtils.java.ftl");
        filesList.add("/SearchFields.java.ftl");
        
        Mockito.doReturn(filesList).when(folderContentReader).getFilesFromFolder(anyString());
        
		Assertions.assertThat(codeGeneratorUtils.readFilesFromDirectory(destPath.getAbsolutePath())).isEqualTo(filesList);
	}
	
	@Test
	public void replaceFileNames_PathIsValid_ReturnList() throws MalformedURLException {
		
		List<String> filesList = new ArrayList<String>();
        filesList.add("/SearchUtils.java.ftl");
        filesList.add("/SearchFields.java.ftl");
      
        Mockito.doReturn(filesList).when(mockedUtils).readFilesFromDirectory(anyString());
        
		Assertions.assertThat(codeGeneratorUtils.replaceFileNames(filesList,destPath.getAbsolutePath())).isEqualTo(filesList);
	}
	
	@Test
	public void convertCamelCaseToKebaCase_StringIsValid_ReturnString()
	{
		String str = "testString";
		Assertions.assertThat(codeGeneratorUtils.camelCaseToKebabCase(str)).isEqualTo("test-string");
	}
	
	@Test
	public void generateFiles_parametersAreValid_ReturnNothing()
	{
		String str = "testString";
		Assertions.assertThat(codeGeneratorUtils.camelCaseToKebabCase(str)).isEqualTo("test-string");
	}
	
	

}
