package com.ninfinity.codegen;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.HashMap;
import java.util.Map;

//import freemarker.template.utility.StringUtil;

//import freemarker.template.Configuration;
@SpringBootApplication
public class CodegenApplication implements ApplicationRunner{
	static Map<String, String> root = new HashMap<>();
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
	public static void main(String[] args) throws ClassNotFoundException {
		SpringApplication.run(CodegenApplication.class, args);

   CodeGenerator.Generate(root.get("e"),root.get("s"),root.get("d"),"","");
		
	}
	
}
