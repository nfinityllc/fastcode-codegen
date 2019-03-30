package com.ninfinity.codegen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;


public class GetUserInput {


	public static UserInput getInput(Scanner inputReader)
	{
		UserInput input = new UserInput();
		System.out.print("\nFor which schema do you want to generate entities ? ");
		input.setSchemaName(inputReader.nextLine());

		System.out.print("\nWhat is the package name for entities ? ");
		//Getting input in String format
		input.setPackageName(inputReader.nextLine());

		System.out.print("\nWhat is the destination path for entities? ");
		input.setDestinationPath(inputReader.nextLine());

		System.out.print("\nDo you want to generate Audit Entity (yes/no)? ");
		String value =inputReader.nextLine();

		if(value.equals("yes") || value.equals("Y") || value.equals("y") )
			input.setAudit(true);
		else
			input.setAudit(false);

		return input;
	}

	public static List<String> getRelationInput(List<String> classList, List<String> relationClassList, String source,String packageName, Scanner scanner)
	{
		List<RelationDetails> relationList = getRelationList(classList, relationClassList,source,packageName);
		List<String> relationInput= new ArrayList<>();
		for(String str : classList)
		{
			if(!relationClassList.contains(str))
			{
				String className = packageName.concat("." + str);
				EntityDetails details = GetEntityDetails.getDetails(source,className);
				Map<String,RelationDetails> relationDetails = details.getRelationsMap();

				for (Map.Entry<String, RelationDetails> entry : relationDetails.entrySet()) {
					for(RelationDetails e : relationList)
					{
						if(e.geteName().equals(str) && e.getRelation().equals(entry.getValue().getRelation()))
						{
							System.out.println("\nFor entities " + str + "-" + entry.getValue().geteName() + " having " + entry.getKey()
							+ " relationship , which one is the owner entity ? ");

							String parent = scanner.nextLine();

							if(parent.equalsIgnoreCase(str))
								relationInput.add(str + "-" + entry.getValue().geteName());
							if(parent.equalsIgnoreCase(entry.getValue().geteName()))
								relationInput.add(entry.getValue().geteName() + "-" + str);

						}
					}

				}
			}
		}

		return relationInput;
	}

	public static List<RelationDetails> getRelationList(List<String> classList, List<String> relationClassList, String source,String packageName)
	{
		List<RelationDetails> relationList = new ArrayList<>();
		for(String str : classList)
		{
			if(!relationClassList.contains(str))
			{
				String className = packageName.concat("." + str);
				EntityDetails details = GetEntityDetails.getDetails(source,className);
				Map<String,RelationDetails> relationInput = details.getRelationsMap();
				for (Map.Entry<String, RelationDetails> entry : relationInput.entrySet()) {
					if(entry.getKey().equals("ManyToMany") || entry.getKey().equals("OneToOne"))
					{
						relationList.add(entry.getValue());
						for(int i=0; i<relationList.size();i++)
						{
							if(relationList.get(i).geteName().contains(str) && relationList.get(i).getRelation().equals(entry.getKey()))
							{
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
