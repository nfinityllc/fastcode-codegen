package com.nfinity.entitycodegen;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class GetUserInput {

	public static String getInput(Scanner inputReader, String inputType) {

		System.out.print("Please enter value for " + inputType + ":");
		String value = inputReader.nextLine();
		return value;
	}

	public static UserInput getInput(Scanner inputReader) {
		UserInput input = new UserInput();
		System.out.print("\nFor which schema do you want to generate entities ? "); // sample
		input.setSchemaName(inputReader.nextLine());

		System.out.print("\nFor which tables do you want to generate entities ? "); // sample
		List<String> tableList = new ArrayList<>();
		String tables = inputReader.nextLine();
		String[] words = tables.split(",");
		for (String str : words) {
			tableList.add(str);
			System.out.println(" TABLES " + str);
		}
		input.setTablesList(tableList);

		System.out.print("\nWhat is the package name for entities ? "); // com.nfinity.microsoft.model
		// Getting input in String format
		input.setPackageName(inputReader.nextLine());

		System.out.print("\nWhat is the destination path for entities? "); // root path of the backend
		String destination = inputReader.nextLine();
		destination = destination.replace('\\', '/');
		input.setDestinationPath(destination);

		System.out.print("\nDo you want to generate Audit Entity (yes/no)? ");// no
		String value = inputReader.nextLine();

		if (value.equals("yes") || value.equals("Y") || value.equals("y"))
			input.setAudit(true);
		else
			input.setAudit(false);

		return input;
	}

	public static FieldDetails getEntityDescriptionField(String entityName, List<FieldDetails> fields) {
		int i = 1;
		StringBuilder b = new StringBuilder(MessageFormat
				.format("\nSelect a descriptive field of {0} entity by typing their corresponding number: ", entityName));
		
		List<FieldDetails> fieldsList =new ArrayList<>();
		for (FieldDetails f : fields) {
			if(f.fieldType.equalsIgnoreCase("long") || f.fieldType.contains("int") || f.fieldType.equalsIgnoreCase("string") ||
			f.fieldType.equalsIgnoreCase("boolean") || f.fieldType.equalsIgnoreCase("timestamp") )
				fieldsList.add(f);
		}
		
		for (FieldDetails f : fieldsList) {
			b.append(MessageFormat.format("{0}.{1} ", i, f.getFieldName()));
			i++;
		}
		System.out.println(b.toString());
		Scanner scanner = new Scanner(System.in);
		i = scanner.nextInt();
		while (i < 1 || i > fieldsList.size()) {
			System.out.println("\nInvalid Input \nEnter again :");
			i = scanner.nextInt();
		}
		FieldDetails r = new FieldDetails();
		FieldDetails selected = fieldsList.get(i - 1);
		r.setFieldName(selected.getFieldName());
		if(selected.getFieldType().contains("int"))
		{
		r.setFieldType("Long");
		}
		else if(selected.getFieldType().contains("timestamp"))
			r.setFieldType("Date");	
		else
		r.setFieldType(selected.getFieldType());
		
		r.setIsNullable(selected.getIsNullable());
		r.setIsPrimaryKey(selected.getIsPrimaryKey());
		r.setLength(selected.getLength());
		return r;
	}

	public static List<String> getRelationInput(List<Class<?>> classList, List<String> relationClassList, String source,
			String packageName) {
		List<RelationDetails> relationList = getRelationList(classList, relationClassList);
		List<String> relationInput = new ArrayList<>();
		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName();
			if (!relationClassList.contains(entityName)) {
				String className = entityName.substring(entityName.lastIndexOf(".") + 1);
				EntityDetails details = GetEntityDetails.getDetails(currentClass, entityName, classList);
				Map<String, RelationDetails> relationDetails = details.getRelationsMap();

				for (Map.Entry<String, RelationDetails> entry : relationDetails.entrySet()) {
					for (RelationDetails e : relationList) {
						if (e.geteName().equals(className) && e.getRelation().equals(entry.getValue().getRelation())) {
							System.out.println("\nFor entities " + className + "-" + entry.getValue().geteName()
									+ " having " + entry.getValue().getRelation()
									+ " relationship , which one is the parent entity ? Enter 1 (" + className
									+ ") or 2 (" + entry.getValue().geteName() + ") : ");

							Scanner scanner = new Scanner(System.in);

							int i = scanner.nextInt();
							while (i < 1 || i > 2) {
								System.out.println("\nInvalid Input \nEnter again :");
								i = scanner.nextInt();
							}
							if (i == 1) {
								relationInput.add(className + "-" + entry.getValue().geteName());
							} else if (i == 2) {
								relationInput.add(entry.getValue().geteName() + "-" + className);
							}

						}
					}

				}
			}
		}

		return relationInput;
	}

	public static List<RelationDetails> getRelationList(List<Class<?>> classList, List<String> relationClassList) {
		List<RelationDetails> relationList = new ArrayList<>();
		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName();
			if (!relationClassList.contains(entityName)) {
				String className = entityName.substring(entityName.lastIndexOf(".") + 1);
				EntityDetails details = GetEntityDetails.getDetails(currentClass, entityName, classList);
				Map<String, RelationDetails> relationInput = details.getRelationsMap();
				for (Map.Entry<String, RelationDetails> entry : relationInput.entrySet()) {
					if (entry.getValue().getRelation().equals("ManyToMany")) {
						relationList.add(entry.getValue());
						for (int i = 0; i < relationList.size(); i++) {
							if (relationList.get(i).geteName().contains(className)
									&& relationList.get(i).getRelation().equals(entry.getValue().getRelation())) {
								relationList.remove(i);
							}
						}
					}
				}
			}
		}

		return relationList;
	}

}