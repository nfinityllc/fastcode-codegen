package com.nfinity.codegen;

import com.google.common.base.CaseFormat;
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

	public static UserInput composeInput(FastCodeProperties configProperties) {
		UserInput input = new UserInput();
		Scanner scanner = new Scanner(System.in);
		//System.out.println(" v " + root.get("c") + "\n ss " + root.get("s"));
		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// /Users/getachew/fc/exer/root
        input.setUpgrade(root.get("upgrade") == null
                ? false
                : (root.get("upgrade").toLowerCase().equals("true") ? true : false));
		input.setConnectionStr(root.get("c") != null ? root.get("c")
				: (configProperties.getConnectionStr() != null ? configProperties.getConnectionStr()
						: GetUserInput.getInput(scanner, "DB Connection String")));
		input.setSchemaName(root.get("s") == null ? GetUserInput.getInput(scanner, "Db schema") : root.get("s"));
		input.setDestinationPath(
				root.get("d") == null ? GetUserInput.getInput(scanner, "destination folder") : root.get("d"));
		input.setGroupArtifactId(
				root.get("a") == null ? GetUserInput.getInput(scanner, "application name") : root.get("a"));
		input.setGenerationType(
				root.get("t") == null ? GetUserInput.getInput(scanner, "generation type") : root.get("t"));
		//		input.setAudit(root.get("audit") == null
		//				? (GetUserInput.getInput(scanner, "auditing").toLowerCase().equals("true") ? true : false)
		//				: (root.get("audit").toLowerCase().equals("true") ? true : false));
		input.setEmail(root.get("email") == null
				? (GetUserInput.getInput(scanner, "email-module").toLowerCase().equals("true") ? true : false)
						: (root.get("email").toLowerCase().equals("true") ? true : false));
		input.setScheduler(root.get("scheduler") == null
				? (GetUserInput.getInput(scanner, "scheduler-module").toLowerCase().equals("true") ? true : false)
						: (root.get("scheduler").toLowerCase().equals("true") ? true : false));
		input.setFlowable(root.get("flowable") == null
				? (GetUserInput.getInput(scanner, "flowable-module").toLowerCase().equals("true") ? true : false)
						: (root.get("flowable").toLowerCase().equals("true") ? true : false));
		input.setHistory(root.get("h") == null
				? (GetUserInput.getInput(scanner, "history").toLowerCase().equals("true") ? true : false)
						: (root.get("h").toLowerCase().equals("true") ? true : false));

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
		} 
		else if (value>1) {
			scanner.nextLine();
			System.out.print("\nDo you want to enable auditing ? (y/n)");
			String str= scanner.nextLine();
			if(str.equalsIgnoreCase("y") || str.equalsIgnoreCase("yes") )
			{
				input.setAudit(true);
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

		//		input.setDatabaseAuthentication(root.get("db-autentication") == null
		//				? (GetUserInput.getInput(scanner, "database authentication").toLowerCase().equals("true") ? true : false)
		//				: (root.get("audit").toLowerCase().equals("true") ? true : false));

		return input;
	}

	public static void main(String[] args) throws ClassNotFoundException, IOException {
		ApplicationContext context = SpringApplication.run(CodegenApplication.class, args);
		FastCodeProperties configProperties = context.getBean(FastCodeProperties.class);

		UserInput input = composeInput(configProperties);
		
		File dir = new File(input.getDestinationPath());
		if(!dir.exists()) {
			dir.mkdirs();
		};

        GitRepositoryManager.setDestinationPath(input.getDestinationPath());
        String sourceBranch = "";
        if(GitRepositoryManager.isGitInstalled()) {
            if(!GitRepositoryManager.isGitInitialized()) {
                GitRepositoryManager.initializeGit();
                System.out.print("Git repository initialized.");
            }
            //Clean up old files if needed
        }
        else {
            System.out.print("Git repository could not be initialized, as Git is not installed on your system.");
            return;
        }
        if(input.getUpgrade()) {
			if(GitRepositoryManager.hasUncommittedChanges()) {
				System.out.print("\nGit has uncommitted changes. ");
				return;
			}
			else {
                sourceBranch = GitRepositoryManager.getCurrentBranch();
                if(!GitRepositoryManager.createUpgradeBranch()) {
                    System.out.print("Unable to create upgrade branch.");
                    return;
                }
            }
		}
        else {
        	GitRepositoryManager.CopyGitFiles();
		}

		String groupArtifactId = input.getGroupArtifactId().isEmpty() ? "com.group.demo" : input.getGroupArtifactId();
		String artifactId = groupArtifactId.substring(groupArtifactId.lastIndexOf(".") + 1);
		String groupId = groupArtifactId.substring(0, groupArtifactId.lastIndexOf("."));

		// c=jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// String connectionString = root.get("c");
		String dependencies ="web,data-jpa,data-rest";
		if(input.getAuthenticationType()!="none")
		{
			dependencies = dependencies.concat(",security");
		}
		if(input.getEmail() || input.getScheduler())
		{
			dependencies = dependencies.concat(",mail");
		}

		BaseAppGen.CreateBaseApplication(input.getDestinationPath(), artifactId, groupId, dependencies,
				true, "-n=" + artifactId + "  -j=1.8 ");
		Map<String, EntityDetails> details = EntityGenerator.generateEntities(input.getConnectionStr(),
				input.getSchemaName(), null, groupArtifactId, input.getDestinationPath() + "/" + artifactId,
				input.getAudit(),input.getHistory(),input.getFlowable(),input.getAuthenticationSchema(),input.getAuthenticationType());

		PomFileModifier.update(input.getDestinationPath() + "/" + artifactId + "/pom.xml",input.getAuthenticationType(),input.getScheduler(),input.getHistory(),input.getFlowable());
		CommonModuleTemplateGenerator.generateCommonModuleClasses(input.getDestinationPath()+ "/" + artifactId, groupArtifactId, input.getAudit());
		BaseAppGen.CompileApplication(input.getDestinationPath() + "/" + artifactId);
		
		FronendBaseTemplateGenerator.generate(input.getDestinationPath(), artifactId + "Client",input.getEmail(),input.getScheduler(),input.getFlowable(), input.getAuthenticationType(), input.getAuthenticationSchema());

		if(input.getFlowable()) {
			FlowableBackendCodeGenerator.generateFlowableClasses(input.getDestinationPath() + "/" + artifactId, groupArtifactId, input.getAuthenticationType(), input.getAuthenticationSchema(),input.getSchemaName(), details, input.getHistory());
		}
		
		if(!input.getAuthenticationType().equals("none"))
		{
			AuthenticationClassesTemplateGenerator.generateAutheticationClasses(input.getDestinationPath(), groupArtifactId, input.getAudit(),
					input.getHistory(),input.getFlowable(),input.getAuthenticationType(),input.getSchemaName(),input.getAuthenticationSchema(),details);
		}

		CodeGenerator.GenerateAll(artifactId, artifactId + "Client", groupArtifactId, groupArtifactId, input.getAudit(),
				input.getHistory(),
				input.getDestinationPath() + "/" + artifactId + "/target/classes/"
						+ (groupArtifactId + ".model").replace(".", "/"),
						input.getDestinationPath(), input.getGenerationType(), details, input.getConnectionStr(),
						input.getSchemaName(),input.getAuthenticationType(),input.getScheduler(),input.getEmail(),input.getFlowable(),input.getAuthenticationSchema());

		if(input.getEmail())
		{
			EmailModuleTemplateGenerator.generateEmailModuleClasses(input.getDestinationPath() + "/" + artifactId,input.getDestinationPath(), artifactId + "Client", groupArtifactId, input.getAudit(), input.getHistory(),input.getAuthenticationType(), input.getSchemaName());
		}
		if(input.getScheduler())
		{
			SchedulerModuleTemplateGenerator.generateSchedulerModuleClasses(input.getDestinationPath() + "/" + artifactId,input.getDestinationPath(), artifactId + "Client", groupArtifactId, input.getAudit(), input.getHistory(), input.getSchemaName(),
					input.getConnectionStr());
		}
		if(input.getFlowable())
		{
			FlowableFrontendCodeGenerator.generate(input.getDestinationPath(), artifactId + "Client");
		}

		GitRepositoryManager.addToGitRepository(input.getUpgrade(), sourceBranch);

        System.out.println("\n Code generation Completed ...");
        System.exit(1);
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

	private static class FastCodeProperties {

		@Value("${fastCode.connectionStr:#{null}}")
		private Optional<String> connectionStr;
		@Value("${fastCode.username:#{null}}")
		private Optional<String> username;
		@Value("${fastCode.password:#{null}}")
		private Optional<String> password;

		public String getConnectionStr() {

			return connectionStr.isPresent()
					? (connectionStr.get() + "username=" + username.get() + ";password=" + password.get())
							: null;
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

		@Value("${fastCode.useGit}")
		private Optional<String> useGit;

		public String getUseGit() {
			return useGit.isPresent() ? useGit.get() : null;
		}
	}

	@Bean
	FastCodeProperties myBean() {
		return new FastCodeProperties();
	}

}
