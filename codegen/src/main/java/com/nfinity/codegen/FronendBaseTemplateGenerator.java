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
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.security.CodeSource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.function.Consumer;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.filefilter.DirectoryFileFilter;
import org.apache.commons.io.filefilter.RegexFileFilter;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ApplicationContext;

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

	public static void generate(String destination, String clientSubfolder) {
		String command = "ng new " + clientSubfolder + " --skipInstall=true";
		runCommand(command, destination);
		editTsConfigJsonFile(destination + "/" + clientSubfolder + "/tsconfig.json");
		editAngularJsonFile(destination + "/" + clientSubfolder + "/angular.json", clientSubfolder);

		List<String> fl = getFilesFromFolder(FRONTEND_BASE_TEMPLATE_FOLDER);
		Map<String, Object> templates = new HashMap<>();

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, FRONTEND_BASE_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);



		for (String filePath : fl) {
			String p = filePath.replace("BOOT-INF/classes" + FRONTEND_BASE_TEMPLATE_FOLDER,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + FRONTEND_BASE_TEMPLATE_FOLDER,"");
			templates.put(p, p.substring(0, p.lastIndexOf('.')));
		}


		generateFiles(templates, null, destination + "/"+ clientSubfolder);

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
			builder.command("sh", "-c", "ls");
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

	public static List<String> getFilesFromFolder(String folderPath) {

		try {
			Path myPath;
			URI uri = FronendBaseTemplateGenerator.class.getResource(folderPath).toURI();
			List<String> list = new ArrayList<String>();
			if (uri.getScheme().equals("jar")) {
				list = getFilesFromJar(folderPath);
			} else {
				Collection<File> files = getFilesFromFileSystem(new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/"+ folderPath));
				for(File file:files) {
					if(file.isFile())
						list.add(file.getAbsolutePath());
				}
			}
			return list;

		}
		catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	private static Collection<File> getFilesFromFileSystem(File path){
		Collection<File> files = org.apache.commons.io.FileUtils.listFilesAndDirs(
				path,
				new RegexFileFilter("^(.*?)"), 
				DirectoryFileFilter.DIRECTORY
				);
		return files;
	}

	private static List<String> getFilesFromJar(String path) throws IOException{
		CodeSource src = FronendBaseTemplateGenerator.class.getProtectionDomain().getCodeSource();
		List<String> list = new ArrayList<String>();
		if( src != null ) {
			java.net.URL jar = src.getLocation();
			ZipInputStream zip = new ZipInputStream( jar.openStream());
			ZipEntry ze = null;

			while( ( ze = zip.getNextEntry() ) != null ) {
				String entryName = ze.getName();
				if( entryName.startsWith("BOOT-INF/classes" + path) && entryName.endsWith(".ftl") ) {
					list.add( entryName );
				}
			}
		}
		return list;
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
	
	public static void editTsConfigJsonFile(String path) {

		try {


            JSONObject jsonObject = readJsonFile(path);
            JSONObject compilerOptions = (JSONObject) jsonObject.get("compilerOptions");
            compilerOptions.put("resolveJsonModule",true);
            compilerOptions.put("esModuleInterop",true);
            
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
