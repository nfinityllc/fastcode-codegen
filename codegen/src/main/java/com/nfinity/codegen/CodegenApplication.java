package com.nfinity.codegen;

import com.nfinity.entitycodegen.BaseAppGen;
import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGenerator;
import com.nfinity.entitycodegen.GetUserInput;
import com.nfinity.entitycodegen.UserInput;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;


@SpringBootApplication
public class CodegenApplication implements ApplicationRunner {
	static Map<String, String> root = new HashMap<>();

	public static UserInput composeInput() {
		UserInput input = new UserInput();
		Scanner scanner = new Scanner(System.in);
		input.setSchemaName(root.get("s") == null ? GetUserInput.getInput(scanner, "Db schema") : root.get("s"));
		input.setDestinationPath(
				root.get("d") == null ? GetUserInput.getInput(scanner, "destination folder") : root.get("d"));
		input.setGroupArtifactId(
				root.get("a") == null ? GetUserInput.getInput(scanner, "application name") : root.get("a"));
		input.setGenerationType(
				root.get("t") == null ? GetUserInput.getInput(scanner, "generation type") : root.get("t"));
		return input;
	}

	public static void main(String[] args) throws ClassNotFoundException {
		ApplicationContext context = SpringApplication.run(CodegenApplication.class, args);
		FastCodeProperties configProperties = context.getBean(FastCodeProperties.class);

		/*
		ResourceScanner scanner = new ResourceScanner();
		String[] files;
		try {
			files = scanner.getResourcesNamesIn("templates/frontendBaseTemplate/");
			for(String f: files){
				System.out.println("res uri:" + f);
			}
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
		Resource[] resources;
		try {
			resources = resolver.getResources("classpath:templates/frontendBaseTemplate/*");
			for(Resource r: resources){
				System.out.println("res uri:" + r.getURI());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		System.out.println(System.getProperty("java.class.path"));
		System.out.println(System.getProperty("user.dir"));
		String prop = configProperties.getConnectionStr();
		boolean b = configProperties.getForce();
		callEntityGen(configProperties);
		// CodeGenerator.Generate(root.get("e"),root.get("s"),root.get("d"),"","");
		// --a com.ninfinity.fastcode. It is a concatenation of groupid and artifact id
		UserInput input  = composeInput();
		//Scanner scanner = new Scanner(System.in);  
		
		String sourcePackageName = root.get("p");
		sourcePackageName = (sourcePackageName == null) ? root.get("e") : sourcePackageName;
		String groupArtifactId =  input.getGroupArtifactId().isEmpty() ? "com.group.demo" : input.getGroupArtifactId();
		String artifactId = groupArtifactId.substring(groupArtifactId.lastIndexOf(".") + 1);
		String groupId = groupArtifactId.substring(0, groupArtifactId.lastIndexOf("."));	
		
		
		BaseAppGen.CreateBaseApplication(input.getDestinationPath(), artifactId, groupId, "web,data-jpa,data-rest", true,"-n=" + artifactId +"  -j=1.8 ");
		Map<String, EntityDetails> details = EntityGenerator.generateEntities(input.getSchemaName(), null, groupArtifactId + ".domain.model",
		input.getDestinationPath() + "/" + artifactId, false, "");
		BaseAppGen.CompileApplication(input.getDestinationPath()+ "/" + artifactId);
		
		FronendBaseTemplateGenerator.generate(input.getDestinationPath(), artifactId + "Client");
		// String destination = root.get("d") + "/" + artifactId;

		CodeGenerator.GenerateAll(artifactId, artifactId + "Client", groupArtifactId, groupArtifactId ,false,
		 input.getDestinationPath()+"/" + artifactId + "/target/classes/" + (groupArtifactId + ".model").replace(".", "/"),
		input.getDestinationPath(), input.getGenerationType(), details);

		// String destination = "F:\\projects\\New folder\\fbaseTempDes";
		// destination = root.get("d") + "/fbaseTempDes";
		// FronendBaseTemplateGenerator.generate(destination);
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
