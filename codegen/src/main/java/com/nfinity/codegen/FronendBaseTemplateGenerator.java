package com.nfinity.codegen;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.function.Consumer;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class FronendBaseTemplateGenerator {
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String FRONTEND_BASE_TEMPLATE_FOLDER = "/templates/frontendBaseTemplate";

	public static void generate(String destination, String clientSubfolder, Boolean email, Boolean scheduler) {
		String command = "ng new " + clientSubfolder + " --skipInstall=true";
		runCommand(command, destination);
		editTsConfigJsonFile(destination + "/" + clientSubfolder + "/tsconfig.json");
		editAngularJsonFile(destination + "/" + clientSubfolder + "/angular.json", clientSubfolder);

		List<String> fl = GetFilesFromFolder.getFilesFromFolder(FRONTEND_BASE_TEMPLATE_FOLDER);
		Map<String, Object> templates = new HashMap<>();

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_BASE_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);

		Map<String, Object> root = new HashMap<>();
		root.put("EmailModule", email);
		root.put("SchedulerModule", scheduler);


		for (String filePath : fl) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_BASE_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_BASE_TEMPLATE_FOLDER,"");
			templates.put(p, p.substring(0, p.lastIndexOf('.')));
		}

		generateFiles(templates,root, destination + "/"+ clientSubfolder);
	}

	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());

				String entryPath = entry.getValue().toString();
				File fileName = new File(destPath + "/" + entryPath); /// new File(destPath + "/" +
				String dirPath = destPath;
				if(destPath.split("/").length > 1) {
					dirPath = dirPath + entryPath.substring(0, entryPath.lastIndexOf('/'));
				}
				System.out.println(dirPath);
				File dir = new File(dirPath);
				if(!dir.exists()) {
					dir.mkdirs();
				};
				PrintWriter writer = new PrintWriter(fileName);
				template.process(root, writer);
				writer.flush();
				writer.close();

			} catch (Exception e1) {
				e1.printStackTrace();

			}
		}
	}

	public static void runCommand(String command, String directory) {
		boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
		ProcessBuilder builder = new ProcessBuilder();
		if (isWindows) {
			builder.command("cmd.exe", "/c", command);
		} else {
			builder.command("sh", "-c", command);
		}
		// builder.directory(new File(System.getProperty("user.home")));
		builder.directory(new File(directory));
		Process process;
		try {
			process = builder.start();
			StreamGobbler streamGobbler = new StreamGobbler(process.getInputStream(), System.out::println);
			Executors.newSingleThreadExecutor().submit(streamGobbler);
			int exitCode;
			exitCode = process.waitFor();

			assert exitCode == 0;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	

	public static File[] getNestedFolders(String folderPath) {
		File dir = new File(folderPath);
		File[] files = dir.listFiles();

		ArrayList<File> folderList = new ArrayList<File>();

		for (File file : files) {
			if (file.isDirectory()) {
				folderList.add(file);
			}
		}

		File[] folderArray = new File[folderList.size()];
		folderArray = folderList.toArray(folderArray);
		return folderArray;
	}

	private static class StreamGobbler implements Runnable {
		private InputStream inputStream;
		private Consumer<String> consumer;

		public StreamGobbler(InputStream inputStream, Consumer<String> consumer) {
			this.inputStream = inputStream;
			this.consumer = consumer;
		}

		@Override
		public void run() {
			new BufferedReader(new InputStreamReader(inputStream)).lines().forEach(consumer);
		}
	}

	public static void editAngularJsonFile(String path, String clientSubfolder) {
		
		try {

			JSONObject jsonObject = readJsonFile(path);
			
			
			
            JSONObject projects = (JSONObject) jsonObject.get("projects");
            JSONObject project = (JSONObject) projects.get(clientSubfolder);
            JSONObject architect = (JSONObject) project.get("architect");
            JSONObject build = (JSONObject) architect.get("build");
            JSONObject options = (JSONObject) build.get("options");
            JSONArray styles = (JSONArray) options.get("styles");
            styles.clear();
            
            JSONObject input = new JSONObject();
            input.put("input", "src/styles/lightgreen-amber.scss");
            
            styles.add(input);
            styles.add("src/styles/styles.scss");
            
            projects.put("fastCodeCore",getFastCodeCoreProjectNode());
            
            String prettyJsonString = beautifyJson(jsonObject); 
            writeJsonToFile(path,prettyJsonString);         

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

    }
	
	public static JSONObject getFastCodeCoreProjectNode() throws ParseException {
		JSONParser parser = new JSONParser();
		JSONObject fccore = (JSONObject) parser.parse("{\r\n" + 
				"      \"root\": \"projects/fast-code-core\",\r\n" + 
				"      \"sourceRoot\": \"projects/fast-code-core/src\",\r\n" + 
				"      \"projectType\": \"library\",\r\n" + 
				"      \"prefix\": \"lib\",\r\n" + 
				"      \"architect\": {\r\n" + 
				"        \"build\": {\r\n" + 
				"          \"builder\": \"@angular-devkit/build-ng-packagr:build\",\r\n" + 
				"          \"options\": {\r\n" + 
				"            \"tsConfig\": \"projects/fast-code-core/tsconfig.lib.json\",\r\n" + 
				"            \"project\": \"projects/fast-code-core/ng-package.json\"\r\n" + 
				"          },\r\n" + 
				"          \"configurations\": {\r\n" + 
				"            \"production\": {\r\n" + 
				"              \"project\": \"projects/fast-code-core/ng-package.prod.json\"\r\n" + 
				"            }\r\n" + 
				"          }\r\n" + 
				"        },\r\n" + 
				"        \"test\": {\r\n" + 
				"          \"builder\": \"@angular-devkit/build-angular:karma\",\r\n" + 
				"          \"options\": {\r\n" + 
				"            \"main\": \"projects/fast-code-core/src/test.ts\",\r\n" + 
				"            \"tsConfig\": \"projects/fast-code-core/tsconfig.spec.json\",\r\n" + 
				"            \"karmaConfig\": \"projects/fast-code-core/karma.conf.js\"\r\n" + 
				"          }\r\n" + 
				"        },\r\n" + 
				"        \"lint\": {\r\n" + 
				"          \"builder\": \"@angular-devkit/build-angular:tslint\",\r\n" + 
				"          \"options\": {\r\n" + 
				"            \"tsConfig\": [\r\n" + 
				"              \"projects/fast-code-core/tsconfig.lib.json\",\r\n" + 
				"              \"projects/fast-code-core/tsconfig.spec.json\"\r\n" + 
				"            ],\r\n" + 
				"            \"exclude\": [\r\n" + 
				"              \"**/node_modules/**\"\r\n" + 
				"            ]\r\n" + 
				"          }\r\n" + 
				"        }\r\n" + 
				"      }\r\n" + 
				"    }");
		return fccore;
	}
	
	public static void editTsConfigJsonFile(String path) {

		try {


            JSONObject jsonObject = readJsonFile(path);
            JSONObject compilerOptions = (JSONObject) jsonObject.get("compilerOptions");
            
            JSONArray fccore = new JSONArray();
            fccore.add("dist/fast-code-core");
            JSONArray fccore1 = new JSONArray();
            fccore1.add("dist/fast-code-core/*");
            
            JSONObject paths = new JSONObject();
            paths.put("fastCodeCore",fccore);
            paths.put("fastCodeCore/*",fccore1);
                        
            compilerOptions.put("paths",paths);
            compilerOptions.put("resolveJsonModule",true);
            compilerOptions.put("esModuleInterop",true);
            compilerOptions.put("allowSyntheticDefaultImports",true);
            
            String prettyJsonString = beautifyJson(jsonObject); 
            writeJsonToFile(path,prettyJsonString);

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

    }
	
	public static JSONObject readJsonFile(String path) throws IOException, ParseException {

		JSONParser parser = new JSONParser();
		FileReader fr = new FileReader(path);
        Object obj = parser.parse(fr);
        fr.close();
        return (JSONObject) obj;
	}

	public static String beautifyJson(JSONObject jsonObject)  {
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
        JsonParser jp = new JsonParser();
        JsonElement je = jp.parse(jsonObject.toJSONString());
        return gson.toJson(je);
	}
	
	public static void writeJsonToFile(String path, String jsonString) throws IOException {
		FileWriter file = new FileWriter(path);
		file.write(jsonString);
        file.close();
	}
}
