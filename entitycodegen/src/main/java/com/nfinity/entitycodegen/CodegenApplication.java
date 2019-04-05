package com.nfinity.entitycodegen;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CodegenApplication{

	public static void main(String[] args) {
		SpringApplication.run(CodegenApplication.class, args);
		
		Scanner scanner = new Scanner(System.in);

		UserInput input= GetUserInput.getInput(scanner);
		System.out.println(" package name "  + input.getPackageName() + "\n destination path " + input.getDestinationPath()
		+ "\n schema name   " + input.getSchemaName() + " \n audit " + input.getAudit() 
		+ "\n audit package " + input.getAuditPackage());

		final String tempPackageName= input.getPackageName().concat(".Temp");
		final String destinationPath= input.getDestinationPath().concat("/src/main/java");
		final String targetPath = input.getDestinationPath().concat("/target/classes");

		ReverseMapping.run(tempPackageName, destinationPath,input.getSchemaName());
		try
		{
			Thread.sleep(25000);
		}
		catch (InterruptedException e)
		{
			e.printStackTrace();
		}

		deleteFile(destinationPath + "/orm.xml");
		try {
			Utils.runCommand("mvn compile",input.getDestinationPath());
		} catch (Exception e) {
			System.out.println("Compilation Error");
			e.printStackTrace();
		}
		CGenClassLoader loader = new CGenClassLoader(targetPath);
		ArrayList<Class<?>> entityClasses;
		try {
			entityClasses = loader.findClasses(tempPackageName);
			ClassDetails classDetails = getClasses(entityClasses);
			List<Class<?>> classList = classDetails.getClassesList();
			List<String> relationClassList = classDetails.getRelationClassesList();
			List<String> relationInputList= GetUserInput.getRelationInput(classList, relationClassList,input.getDestinationPath(),tempPackageName,scanner);

			for (Class<?> currentClass : classList) {
				String entityName = currentClass.getName();
				if(!relationClassList.contains(entityName))
				{
					EntityDetails details = GetEntityDetails.getDetails(currentClass,entityName,classList);
					EntityGenerator.Generate(entityName,details,"sample",input.getPackageName(),input.getDestinationPath()+"/src/main/java",relationInputList,input.getAudit(),input.getAuditPackage());
				}

			}
		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();

		}

		if(input.getAudit())
		{
			EntityGenerator.generateAuditEntity(destinationPath, input.getAuditPackage());
		}
		scanner.close();
		deleteDirectory(destinationPath +"/"+ tempPackageName.replaceAll("\\.", "/"));
		System.out.println(" exit " );
	}

	public static void deleteFile(String directory)
	{
		System.out.println(" Directory " + directory);
		File file =new File(directory );
		if(file.exists())
		{
			file.delete();
		}
	}

	public static void deleteDirectory(String directory)
	{
		File file =new File(directory );
		File[] contents = file.listFiles();
		if (contents != null) {
			for (File f : contents) {
				if(f.isDirectory())
					deleteDirectory(f.getAbsolutePath());
				else
					f.delete();
			}
		}
		file.delete();
	}

	public static ClassDetails getClasses(ArrayList<Class<?>> entityClasses)
	{
		List<String> entityClassNames = new ArrayList<>();
		for (Class<?> currentClass : entityClasses) {
			String entityName = currentClass.getName();
			entityClassNames.add(entityName);
		}

		List<String> relationClass = new ArrayList<>();
		List<Class<?>> classList = new ArrayList<>();

		for (Class<?> currentClass : entityClasses) {
			String entityName = currentClass.getName();
			if(entityName.contains("Id"))
			{
				if(!entityName.contains("Tokenizer"))
				{
					String className = entityName.substring(0,entityName.indexOf("Id"));

					if(!entityClassNames.contains(className))
						classList.add(currentClass);
					else
						relationClass.add(className);
				}
			}
			else
			{
				classList.add(currentClass);
			}
		}
		return new ClassDetails(classList,relationClass);
	}

}