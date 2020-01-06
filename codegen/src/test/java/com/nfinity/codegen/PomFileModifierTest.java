package com.nfinity.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.any;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
public class PomFileModifierTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	PomFileModifier pomFileModifier;
	
	@Mock
	PomFileModifier mockedPomFileModifier;
	
	File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(pomFileModifier);
		destPath = folder.newFolder("tempFolder");
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void updatePomFile_parametersAreValid_ReturnNothing() throws IOException {
		
		File file = folder.newFile("pom.xml");
		String filePath = file.getAbsolutePath().replace('\\', '/');
		String fileDest = filePath.substring(0,filePath.lastIndexOf("/"));
	
		
//		System.out.println(destPath.getAbsolutePath());
//        Resource rs = resourcePatternResolver.getResource(destPath.getAbsolutePath());
//        System.out.println(" RRS " + rs );
//        Assertions.assertThat(resourceScanner.getResource(destPath.getAbsolutePath())).isEqualTo(rs);
		Mockito.doNothing().when(mockedPomFileModifier).addDependenciesAndPluginsToPom(anyString(),any(List.class));
		pomFileModifier.updatePomFile(destPath.getAbsolutePath(), "database", true);
		
		Mockito.verify(mockedPomFileModifier,Mockito.never()).addDependenciesAndPluginsToPom(anyString(),any(List.class));

    }

}
