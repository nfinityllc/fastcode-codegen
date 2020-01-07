package com.nfinity.entitycodegen;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class GetUserInput {

	@Autowired
	EntityDetails entityDetails;
	
	public String getInput(Scanner inputReader, String inputType) {

		System.out.print("Please enter value for " + inputType + ":");
		String value = inputReader.nextLine();
		return value;
	}
	
	public List<FieldDetails> getFilteredFieldsList(List<FieldDetails> fields)
	{
		List<FieldDetails> fieldsList = new ArrayList<>();
		for (FieldDetails f : fields) {
			if (f.fieldType.equalsIgnoreCase("long") || f.fieldType.equalsIgnoreCase("integer") || f.fieldType.equalsIgnoreCase("double")
					|| f.fieldType.equalsIgnoreCase("short") || f.fieldType.equalsIgnoreCase("string") || f.fieldType.equalsIgnoreCase("boolean")
					|| f.fieldType.equalsIgnoreCase("timestamp") || f.fieldType.equalsIgnoreCase("date"))
				fieldsList.add(f);
		}
		return fieldsList;
	}
	
	public int getFieldsInput(int size)
	{
		System.out.print("\nPlease enter value between (1-" +size+ ") :");
		Scanner scanner = new Scanner(System.in);
		int index = scanner.nextInt();
		while (index < 1 || index > size) {
			System.out.println("\nInvalid Input \nEnter again :");
			index = scanner.nextInt();
		}
		return index;
	}
	
	public FieldDetails getEntityDescriptionField(String entityName, List<FieldDetails> fields) {
		int index = 1;
		StringBuilder builder = new StringBuilder(MessageFormat.format(
				"\nSelect a descriptive field of {0} entity by typing their corresponding number: ", entityName));

		List<FieldDetails> fieldsList = getFilteredFieldsList(fields);
		
		for (FieldDetails f : fieldsList) {
			builder.append(MessageFormat.format("{0}.{1} ", index, f.getFieldName()));
			index++;
		}
		System.out.println(builder.toString());
		index= getFieldsInput(fieldsList.size());
		
//		FieldDetails updatedFieldDetails = new FieldDetails();
		FieldDetails selected = fieldsList.get(index - 1);
//		updatedFieldDetails.setFieldName(selected.getFieldName());
//		System.out.println(" Sleected field type " + selected.getFieldType());
////		if (selected.getFieldType().contains("int")) {
////			updatedFieldDetails.setFieldType("Long");
////		} else if (selected.getFieldType().contains("timestamp"))
////			updatedFieldDetails.setFieldType("Date");
////		else
////			updatedFieldDetails.setFieldType(selected.getFieldType());
//        updatedFieldDetails.setFieldType(selected.getFieldType());
//		updatedFieldDetails.setIsNullable(selected.getIsNullable());
//		updatedFieldDetails.setIsPrimaryKey(selected.getIsPrimaryKey());
//		updatedFieldDetails.setLength(selected.getLength());
		return selected;
	}

//	public List<String> getRelationInput(List<Class<?>> classList, List<String> relationClassList, String source,
//			String packageName) {
//		List<RelationDetails> relationList = getRelationList(classList, relationClassList);
//		List<String> relationInput = new ArrayList<>();
//		for (Class<?> currentClass : classList) {
//			String entityName = currentClass.getName();
//			if (!relationClassList.contains(entityName)) {
//				String className = entityName.substring(entityName.lastIndexOf(".") + 1);
//				EntityDetails details = entityDetails.retreiveEntityFieldsAndRships(currentClass, entityName,
//						classList);
//				Map<String, RelationDetails> relationDetails = details.getRelationsMap();
//
//				for (Map.Entry<String, RelationDetails> entry : relationDetails.entrySet()) {
//					for (RelationDetails e : relationList) {
//						if (e.geteName().equals(className) && e.getcName().equals(entry.getValue().geteName())&& e.getRelation().equals(entry.getValue().getRelation())) {
//							System.out.println("\nFor entities " + className + "-" + entry.getValue().geteName()
//									+ " having " + entry.getValue().getRelation()
//									+ " relationship , which one is the parent entity ? \n1. " + className
//									+ "\n2. " + entry.getValue().geteName() + "");
//
//						//	Scanner scanner = new Scanner(System.in);
//
//							int index = getFieldsInput(2);
////							while (i < 1 || i > 2) {
////								System.out.println("\nInvalid Input \nEnter again :");
////								i = scanner.nextInt();
////							}
//							if (index == 1) {
//								relationInput.add(className + "-" + entry.getValue().geteName());
//							} else if (index == 2) {
//								relationInput.add(entry.getValue().geteName() + "-" + className);
//							}
//
//						}
//					}
//
//				}
//			}
//		}
//
//		return relationInput;
//	}

//	public List<RelationDetails> getRelationList(List<Class<?>> classList, List<String> relationClassList) {
//		List<RelationDetails> relationList = new ArrayList<>();
//		for (Class<?> currentClass : classList) {
//			String entityName = currentClass.getName();
//			if (!relationClassList.contains(entityName)) {
//				String className = entityName.substring(entityName.lastIndexOf(".") + 1);
//				EntityDetails details = entityDetails.retreiveEntityFieldsAndRships(currentClass, entityName,
//						classList);
//				Map<String, RelationDetails> relationInput = details.getRelationsMap();
//				for (Map.Entry<String, RelationDetails> entry : relationInput.entrySet()) {
//					if (entry.getValue().getRelation().equals("ManyToMany")) {
//						relationList.add(entry.getValue());
//						for (int i = 0; i < relationList.size(); i++) {
//							if (relationList.get(i).geteName().contains(className)
//									&& relationList.get(i).getRelation().equals(entry.getValue().getRelation())) {
//								relationList.remove(i);
//							}
//						}
//					}
//				}
//			}
//		}
//
//		return relationList;
//	}

}