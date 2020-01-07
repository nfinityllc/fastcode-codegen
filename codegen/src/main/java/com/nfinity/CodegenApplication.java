package com.nfinity;

import com.google.common.base.CaseFormat;
import com.nfinity.codegen.GenerateAllModules;
import com.nfinity.entitycodegen.BaseAppGen;
import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGenerator;
import com.nfinity.entitycodegen.GetUserInput;
import com.nfinity.entitycodegen.UserInput;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@SpringBootApplication
public class CodegenApplication implements ApplicationRunner {
	static Map<String, String> root = new HashMap<>();

	public static UserInput composeInput(GetUserInput getUserInput) {
		UserInput input = new UserInput();
		Scanner scanner = new Scanner(System.in);
		//System.out.println(" v " + root.get("c") + "\n ss " + root.get("s"));
		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode
		// /Users/getachew/fc/exer/root
		input.setUpgrade(root.get("upgrade") == null
				? false
						: (root.get("upgrade").toLowerCase().equals("true") ? true : false));
		input.setConnectionStr(root.get("conn") != null ? root.get("conn")
				: (getUserInput.getInput(scanner, "DB Connection String")));
		//input.setConnectionStr("jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode");
		
		input.setSchemaName(root.get("s") == null ? getUserInput.getInput(scanner, "Db schema") : root.get("s"));
		input.setDestinationPath(
				root.get("d") == null ? getUserInput.getInput(scanner, "destination folder") : root.get("d"));
		input.setGroupArtifactId(
				root.get("a") == null ? getUserInput.getInput(scanner, "application name") : root.get("a"));
		input.setGenerationType(
				root.get("t") == null ? getUserInput.getInput(scanner, "generation type") : root.get("t"));
		input.setCache(root.get("c") == null ? (getUserInput.getInput(scanner, "cache").toLowerCase().equals("true") ? true : false)
		       : (root.get("c").toLowerCase().equals("true") ? true : false));

		input.setEmail(root.get("email") == null 
                ? (getUserInput.getInput(scanner, "email-module").toLowerCase().equals("true") ? true : false) 
                        : (root.get("email").toLowerCase().equals("true") ? true : false)); 
        input.setScheduler(root.get("scheduler") == null 
                ? (getUserInput.getInput(scanner, "scheduler-module").toLowerCase().equals("true") ? true : false) 
                        : (root.get("scheduler").toLowerCase().equals("true") ? true : false)); 
        input.setFlowable(root.get("flowable") == null 
                ? (getUserInput.getInput(scanner, "flowable-module").toLowerCase().equals("true") ? true : false) 
                        : (root.get("flowable").toLowerCase().equals("true") ? true : false)); 

		System.out.print("\nSelect Authentication and Authorization method :");
		System.out.print("\n1. none");
		System.out.print("\n2. database");
		System.out.print("\n3. ldap");

		System.out.print("\n4. oidc");
		System.out.print("\nEnter 1,2,3 or 4 : ");
		int value = scanner.nextInt();
		while (value < 1 || value > 4) {

			System.out.println("\nInvalid Input \nEnter again :");
			value = scanner.nextInt();
		}
		if (value == 1) {
			input.setAuthenticationType("none");
			input.setFlowable(false);
		} 
		else if (value>1) {
			scanner.nextLine();
			
			 System.out.print("\nDo you want to enable history ? (y/n)"); 
			 String str= scanner.nextLine(); 
	            if(str.equalsIgnoreCase("y") || str.equalsIgnoreCase("yes")) 
	            { 
	                input.setHistory(true); 
	            } 
			System.out.print("\nDo you have your own user table? (y/n)");
			str= scanner.nextLine();
			if(str.equalsIgnoreCase("y") || str.equalsIgnoreCase("yes"))
			{
				System.out.print("\nEnter table name :");
				str= scanner.nextLine();
				if(str.contains("_"))
				{
					str=CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, str);
				}
				input.setAuthenticationSchema(str.substring(0, 1).toUpperCase() + str.substring(1));
			}

			if (value == 2) {
				input.setAuthenticationType("database");
			}
			else if (value == 3) {
				input.setAuthenticationType("ldap");
			}
			else if (value == 4) {
				input.setAuthenticationType("oidc");
			}
		}

		return input;
	}

	public static void main(String[] args) throws ClassNotFoundException, IOException {
		ApplicationContext context = SpringApplication.run(CodegenApplication.class, args);

		UserInput input = composeInput(context.getBean(GetUserInput.class));
		GenerateAllModules generate = context.getBean(GenerateAllModules.class);
		generate.generateCode(input);

	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		System.out.println("# NonOptionArgs: " + args.getNonOptionArgs().size());

		System.out.println("NonOptionArgs:");
		args.getNonOptionArgs().forEach(System.out::println);

		System.out.println("# OptionArgs: " + args.getOptionNames().size());
		System.out.println("OptionArgs:");

		args.getOptionNames().forEach(optionName -> {
			root.put(optionName, args.getOptionValues(optionName).get(0));
			System.out.println(optionName + "=" + args.getOptionValues(optionName));
		});
	}


}
