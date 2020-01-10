package com.nfinity.entitycodegen;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.nfinity.codegen.CommandUtils;

@RunWith(SpringJUnit4ClassRunner.class)
public class EntityDetailsTest {

	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	EntityDetails entityDetails;

	@Mock
	CommandUtils mockedCommandUtils;

	File destPath;

	private static URLClassLoader classLoader;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(entityDetails);
		destPath = folder.newFolder("tempFolder");

	}

	@After
	public void tearDown() throws Exception {


	}

	//	@Test
	//	public void retreiveEntityFieldsAndRships_parametersAreValid_returnEntityDetails()
	//	{
	//		
	//	}

//	@Test
//	public void getFields_parametersAreValid_returnFieldsList() throws IOException, ClassNotFoundException
//	{
//		String path= System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/testFiles/javaFiles/Blog.java";
//		File file1 = new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/testFiles/javaFiles");
//		File file = folder.newFolder("com","nfin");
//		FileUtils.copyDirectory(file1, file);
//		System.out.println(" pa "  + file.getAbsolutePath().replace("\\", "/") + "/") ;
//		//		ClassLoader classloader = Thread.currentThread().getContextClassLoader();
//		//		Class<?> cs = classloader.loadClass(file.getAbsolutePath().replace("\\", "/") +"/Blog.java/");
//		//		
//		//File file = new File("c:\\other_classes\\"); 
//
//		//convert the file to URL format
//		URL url = file.toURI().toURL(); 
//		URL[] urls = new URL[]{url}; 
//
//		//load this folder into Class loader
//		ClassLoader cl = new URLClassLoader(urls); 
//
//		//load the Address class in 'c:\\other_classes\\'
//		Class  cls = cl.loadClass("/com/nfin/testemaa/domain/model/Temp/Blog.class");		
//		//		classLoader = new URLClassLoader(new URL[]{new File(path).toURI().toURL()},Thread.currentThread().getContextClassLoader());
//		//		ArrayList<Class<?>> classes = new ArrayList<Class<?>>();
//		//
//		//		//for (Map.Entry<String, String> entry : classFiles.entrySet()) {
//		//			Class<?> cs = classLoader.loadClass(path);
//		//
//		//			classes.add(cs);
//		//		//}
//		//		ClassLoader classloader = Thread.currentThread().getContextClassLoader();
//		//		InputStream is = classloader.getResourceAsStream("Blog.java");
//
//
//
//	}


}
