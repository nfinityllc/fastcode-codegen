package com.nfinity.entitycodegen;

import java.io.File;
import java.util.Scanner;

import org.assertj.core.api.Assertions;
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
public class GetUserInputTest {

	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	GetUserInput getUserInput;
	
	@Mock
	EntityDetails mockedEntityDetails;
	
    File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(getUserInput);
		destPath = folder.newFolder("tempFolder");
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void getInput_parametersAreValid_returnStrin()
	{
		Scanner scanner = new Scanner(System.in);
		Assertions.assertThat(getUserInput.getInput(scanner, "authentication table")).isEqualTo("user");
	}
	
	@Test
	public void getFieldsInput_parametersAreValid_returnStrin()
	{
		//Scanner scanner = new Scanner(System.in);
		Assertions.assertThat(getUserInput.getFieldsInput(3)).isEqualTo(2);
	}
	
	
	
}
