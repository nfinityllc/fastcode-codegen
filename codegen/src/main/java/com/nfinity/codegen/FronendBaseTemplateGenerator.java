package com.nfinity.codegen;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.function.Consumer;
import org.apache.commons.io.IOCase;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.springframework.util.ResourceUtils;



public class FronendBaseTemplateGenerator {
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String FRONTEND_BASE_TEMPLATE_FOLDER = "/templates/frontendBaseTemplate";

	public static void generate(String destination, String clientSubfolder) {
		File directory = new File(destination + "/"+ clientSubfolder);
		if (!directory.exists()) {
			directory.mkdir();
		}
		//String command = "ng new client --skipInstall=true";
		String command = "ng new "+ clientSubfolder + " --skipInstall=true";
		runCommand(command, destination);
		System.out.println(System.getProperty("user.dir"));

		// create client folder if it doesn't exist

		generate(getTemplateFolder() +	"/frontendBaseTemplate",
				FRONTEND_BASE_TEMPLATE_FOLDER, destination + "/"+ clientSubfolder + "/");
		// generate("F:/projects/New
		// folder/codegen/codegen/src/main/resources/templates/frontendBaseTemplate",FRONTEND_BASE_TEMPLATE_FOLDER,
		// destination + "/generatedProject/src/app");

	}

	private static void generate(String path, String parent, String destination) {
		System.out.println("path:" + path);
		File[] fl = getFilesFromFolder(path);
		Map<String, Object> templates = new HashMap<>();

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, parent + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");

		cfg.setTemplateLoader(mtl);
		System.out.println("destination:" + destination);
		System.out.println("files:" + fl.length);
		if (fl.length > 0) {

			for (File file : fl) {
				String filename = file.getName();
				templates.put(filename, filename.substring(0, filename.lastIndexOf('.')));
			}
		}

		generateFiles(templates, null, destination);

		File[] folderList = getNestedFolders(path);
		for (File folder : folderList) {
			String folderName = folder.getName();
			String newPath = path + "/" + folderName;
			String newParent = parent + "/" + folderName;
			String newDestination = destination + "/" + folderName;

			File directory = new File(newDestination);
			if (!directory.exists()) {
				directory.mkdir();
			}
			generate(newPath, newParent, newDestination);
		}

	}

	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());

				File fileName = new File(destPath + "/" + entry.getValue().toString()); /// new File(destPath + "/" +
																						/// entry.getValue().toString());
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
			builder.command("sh", "-c", "ls", command);
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

	public static File[] getFilesFromFolder(String folderPath) {

		File dir = new File(folderPath);
		FileFilter fileFilter = new WildcardFileFilter("*.ftl", IOCase.INSENSITIVE);
		File[] fileList = dir.listFiles(fileFilter);

		return fileList;
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
	public static String getTemplateFolder() {
		String path= 	System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/templates";
			try {
			 path = ResourceUtils.getFile("classpath:templates").getPath();
			return path;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return path;
	}
}
