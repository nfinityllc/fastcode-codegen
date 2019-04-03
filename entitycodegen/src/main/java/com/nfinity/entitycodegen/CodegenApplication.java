package com.nfinity.entitycodegen;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.google.common.reflect.ClassPath;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

@SpringBootApplication
public class CodegenApplication {
	static final String packageName = "com.ninfinity.model";

	public static void main(String[] args) throws ClassNotFoundException {
		SpringApplication.run(CodegenApplication.class, args);

		Scanner scanner = new Scanner(System.in);

		UserInput input = GetUserInput.getInput(scanner);
		System.out
				.println(" package name " + input.getPackageName() + "\n destination path " + input.getDestinationPath()
						+ "\n schema name   " + input.getSchemaName() + " \n audit " + input.getAudit());

		String workingDir = System.getProperty("user.dir") + "/src/main/java";
		ReverseMapping.run(packageName, workingDir, input.getSchemaName());
		try {
			Thread.sleep(22000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		deleteOrm(workingDir);
		ClassDetails classDetails = getClasses(packageName);
		List<String> classList = classDetails.getClassesList();
		List<String> relationClassList = classDetails.getRelationClassesList();

		List<String> relationInputList = GetUserInput.getRelationInput(classList, relationClassList, workingDir,
				packageName, scanner);

		for (String str : classList) {
			if (!relationClassList.contains(str)) {
				String className = packageName.concat("." + str);
				EntityDetails details = GetEntityDetails.getDetails(workingDir, className);
				EntityGenerator.Generate(className, details, input.getSchemaName(), input.getPackageName(),
						input.getDestinationPath(), relationInputList, input.getAudit());

			}
		}

		if (input.getAudit()) {
			EntityGenerator.generateAuditEntity(input.getDestinationPath(), input.getPackageName());
		}
		scanner.close();
	}

	public static ClassDetails getClasses(String packageName) {
		List<String> list = new ArrayList<>();
		List<String> relationClass = new ArrayList<>();
		List<String> classList = new ArrayList<>();
		final ClassLoader loader = Thread.currentThread().getContextClassLoader();

		try {
			for (final ClassPath.ClassInfo info : ClassPath.from(loader).getTopLevelClasses()) {
				if (info.getName().startsWith(packageName)) {
					final Class<?> clazz = info.load();
					String className = clazz.toString();
					className = className.substring(className.lastIndexOf(".") + 1).trim();
					list.add(className);
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		for (String str : list) {
			if (str.contains("Id")) {
				String className = str.substring(0, str.indexOf("Id"));
				if (!list.contains(className))
					classList.add(className);
				else
					relationClass.add(className);
			} else
				classList.add(str);
		}

		return new ClassDetails(classList, relationClass);
	}

	public static void deleteOrm(String directory) {
		File file = new File(directory + "/orm.xml");
		if (file.exists()) {
			file.delete();
		}
	}

}
