package com.nfinity.codegen;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
//import freemarker.template.utility.StringUtil;

//import freemarker.template.Configuration;
@SpringBootApplication
public class CodegenApplication implements ApplicationRunner {
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
		ApplicationContext context = SpringApplication.run(CodegenApplication.class, args);
		FastCodeProperties configProperties = context.getBean(FastCodeProperties.class);

		String prop = configProperties.getConnectionStr();
		boolean b = configProperties.getForce();
		callEntityGen(configProperties);
		// CodeGenerator.Generate(root.get("e"),root.get("s"),root.get("d"),"","");
		// --a com.ninfinity.fastcode. It is a concatenation of groupid and artifact id
		String sourcePackageName = root.get("p");
		sourcePackageName = (sourcePackageName == null) ? root.get("e") : sourcePackageName;
		CodeGenerator.GenerateAll(root.get("a"), sourcePackageName, root.get("s"), root.get("d"), root.get("t"));

	}

	private static void callEntityGen(FastCodeProperties configProperties) {
		String prop = configProperties.getConnectionStr();
		boolean b = configProperties.getForce();
	}

	private static class FastCodeProperties {

		@Value("${fastCode.connectionStr}")
		private String connectionStr;

		public String getConnectionStr() {
			return connectionStr;
		}

		@Value("${fastCode.bootVersion}")
		private String bootVersion;

		public String getBootVersion() {
			return bootVersion;
		}

		@Value("${fastCode.build}")
		private String build;

		public String getBuild() {
			return build;
		}

		@Value("${fastCode.dependencies}")
		private String dependencies;

		public String getDependencies() {
			return dependencies;
		}

		@Value("${fastCode.force}")
		private boolean force;

		public boolean getForce() {
			return force;
		}

		@Value("${fastCode.javaVersion}")
		private String javaVersion;

		public String getJavaVersion() {
			return javaVersion;
		}

		@Value("${fastCode.packaging}")
		private String packaging;

		public String getPackaging() {
			return packaging;
		}

		@Value("${fastCode.version}")
		private String version;

		public String getVersion() {
			return version;
		}

	}

	@Bean
	FastCodeProperties myBean() {
		return new FastCodeProperties();
	}

}
