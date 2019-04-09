package com.nfinity.entitycodegen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class GetUserInput {

	public static UserInput getInput(Scanner inputReader) {
		UserInput input = new UserInput();
		System.out.print("\nFor which schema do you want to generate entities ? "); // sample
		input.setSchemaName(inputReader.nextLine());

		System.out.print("\nWhat is the package name for entities ? "); // com.nfinity.microsoft.model
		// Getting input in String format
		input.setPackageName(inputReader.nextLine());

		System.out.print("\nWhat is the destination path for entities? "); // root path of the backend
		input.setDestinationPath(inputReader.nextLine());

		System.out.print("\nDo you want to generate Audit Entity (yes/no)? ");// no
		String value = inputReader.nextLine();

		if (value.equals("yes") || value.equals("Y") || value.equals("y"))
			input.setAudit(true);
		else
			input.setAudit(false);

		if (input.getAudit()) {
			System.out.print("\nWhat is the package name for Audit Entity ?");
			String auditPackage = inputReader.nextLine();
			input.setAuditPackage(auditPackage.isEmpty() ? input.getPackageName().concat(".Audit") : auditPackage);
		}

		return input;
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
									+ " having " + entry.getKey() + " relationship , which one is the owner entity ? Enter 1 or 2 : ");

							Scanner scanner = new Scanner(System.in);
							int i = scanner.nextInt();
							while(i<1 && i>2)
							{
								System.out.println("\nInvalid Input \nEnter again :");
								i = scanner.nextInt();
							}
							if(i==1)
							{
								relationInput.add(className + "-" + entry.getValue().geteName());
							}
							else if(i==2)
							{
								relationInput.add(entry.getValue().geteName() + "-" + className);	
							}
							
//							String parent = scanner.nextLine();
//
//							if (parent.equalsIgnoreCase(className))
//								relationInput.add(className + "-" + entry.getValue().geteName());
//							if (parent.equalsIgnoreCase(entry.getValue().geteName()))
//								relationInput.add(entry.getValue().geteName() + "-" + className);
//							
							scanner.close();

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
					if (entry.getKey().equals("ManyToMany")) {
						relationList.add(entry.getValue());
						for (int i = 0; i < relationList.size(); i++) {
							if (relationList.get(i).geteName().contains(className)
									&& relationList.get(i).getRelation().equals(entry.getKey())) {
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
