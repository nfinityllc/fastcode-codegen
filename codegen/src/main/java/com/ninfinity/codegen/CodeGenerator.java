package com.ninfinity.codegen;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import java.io.File;
import java.io.PrintWriter;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.jar.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.autoconfigure.SpringBootApplication;




//import freemarker.template.utility.StringUtil;


//import freemarker.template.Configuration;
@SpringBootApplication
public class CodeGenerator {

	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);

	public static void Generate(String entityName, String sourcePath, String destPath) {
		Generate(entityName, sourcePath, destPath, "", "");
	}

	public static void Generate(String entityName, String sourcePath, String destPath, String type, String modName) {

		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		String packageName = className.concat("s");
		String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(className);
		splittedNames[0] = StringUtils.lowerCase(splittedNames[0]);
		String instanceName = StringUtils.join(splittedNames);
		for (int i = 0; i < splittedNames.length; i++) {
			splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
		}
		String moduleName = StringUtils.isNotEmpty(modName) ? modName : StringUtils.join(splittedNames, "-");

		Map<String, Object> root = new HashMap<>();
		root.put("ModuleName", moduleName);
		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("InstanceName", instanceName);
		root.put("IEntity", "I" + className);
		root.put("IEntityFile", "i" + moduleName);
		root.put("ApiPath", className.toLowerCase());

		Map<String, Object> uiTemplate = getUITemplates(root.get("ModuleName").toString());
		Map<String, Object> otherTemplate = new HashMap<String, Object>();
		// Map<String, Object> backendDtoTemplate =
		// getBackendTemplates(root.get("ClassName").toString());
		// Defining paths for tempaltes

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, "/templates/");
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, "/templates/backendTemplates/");
		ClassTemplateLoader ctl2 = new ClassTemplateLoader(CodegenApplication.class, "/templates/backendTemplates/Dto");

		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl, ctl1, ctl2 });
		cfg.setDefaultEncoding("UTF-8");

		cfg.setTemplateLoader(mtl);

		try {
			getJarInfo(sourcePath,entityName);
			EntityDetails fieldsObj = getFieldNames(sourcePath, entityName);
			Map<String, FieldDetails> actualFieldNames = fieldsObj.getFieldsMap();

			Map<String, RelationDetails> relationMap = fieldsObj.getRelationsMap();
			List<String> searchFields = new ArrayList<>();

			for (Map.Entry<String, FieldDetails> entry : actualFieldNames.entrySet()) {
				if (entry.getValue().getFieldType().equalsIgnoreCase("String"))
					searchFields.add(entry.getValue().getFieldName());

			}

			if (type.equalsIgnoreCase("other")) {
				cfg.setDirectoryForTemplateLoading(new File(sourcePath + "/templates/"));
				otherTemplate = getOtherTemplates(root.get("ClassName").toString(), sourcePath + "/templates/");
			} else {
				cfg.setTemplateLoader(mtl);
			}

			root.put("Fields", actualFieldNames);
			root.put("SearchFields", searchFields);
			root.put("Relationship", relationMap);

			String destFolder = destPath + "/fcclient/src/app/" + root.get("ModuleName").toString();
			new File(destFolder).mkdirs();
			if (type.equalsIgnoreCase("other")) {
				generateFiles(otherTemplate, root, destFolder);
			} else if (type.equalsIgnoreCase("ui"))
				generateFiles(uiTemplate, root, destFolder);
			else if (type == "backend") {
				generateBackendFiles(root, destPath);
			} else {
				generateFiles(uiTemplate, root, destFolder);
				generateBackendFiles(root, destPath);
			}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}

	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
		String destFolderBackend = destPath + "/src/main/java/com/nfinity/fastcode/application/Authorization/"
				+ root.get("PackageName").toString();
		new File(destFolderBackend).mkdirs();
		generateFiles(getApplicationTemplates(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/src/main/java/com/nfinity/fastcode/application/Authorization/"
				+ root.get("PackageName").toString() + "/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getDtos(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/src/main/java/com/nfinity/fastcode/domain/Authorization/"
				+ root.get("PackageName").toString();
		new File(destFolderBackend).mkdirs();
		generateFiles(getDomainTemplates(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/src/main/java/com/nfinity/fastcode/domain/IRepository";
		generateFiles(getRepositoryTemplates(root.get("ClassName").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/src/main/java/com/nfinity/fastcode/ReSTControllers";
		generateFiles(getControllerTemplates(root.get("ClassName").toString()), root, destFolderBackend);
	}

	private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());
				File fileName = new File(destPath + "/" + entry.getValue().toString());
				PrintWriter writer = new PrintWriter(fileName);
				System.out.println("\nRoot  " + root.toString());
				template.process(root, writer);
				writer.flush();

			} catch (Exception e1) {
				e1.printStackTrace();

			}
		}
	}

	private static Map<String, Object> getUITemplates(String moduleName) {
		Map<String, Object> uiTemplate = new HashMap<>();
		// Map<String, Object> backEndTemplate = new HashMap<>();
		uiTemplate.put("iitem.ts.ftl", "i" + moduleName + ".ts");
		uiTemplate.put("item.service.ts.ftl", moduleName + ".service.ts");

		uiTemplate.put("item-list.component.ts.ftl", moduleName + "-list.component.ts");
		uiTemplate.put("item-list.component.html.ftl", moduleName + "-list.component.html");
		uiTemplate.put("item-list.component.scss.ftl", moduleName + "-list.component.scss");
		uiTemplate.put("item-list.component.spec.ts.ftl", moduleName + "-list.component.spec.ts");

		uiTemplate.put("item-new.component.ts.ftl", moduleName + "-new.component.ts");
		uiTemplate.put("item-new.component.html.ftl", moduleName + "-new.component.html");
		uiTemplate.put("item-new.component.scss.ftl", moduleName + "-new.component.scss");
		uiTemplate.put("item-new.component.spec.ts.ftl", moduleName + "-new.component.spec.ts");

		uiTemplate.put("item-details.component.ts.ftl", moduleName + "-details.component.ts");
		uiTemplate.put("item-details.component.html.ftl", moduleName + "-details.component.html");
		uiTemplate.put("item-details.component.scss.ftl", moduleName + "-details.component.scss");
		uiTemplate.put("item-details.component.spec.ts.ftl", moduleName + "-details.component.spec.ts");

		return uiTemplate;
	}

	private static Map<String, Object> getOtherTemplates(String className, String templateFolder) {
		// Map<String, Object> uiTemplate = new HashMap<>();
		Map<String, Object> otherTemplates = new HashMap<>();
		// uiTemplate.put("iitem.ts.ftl","i" + moduleName + ".ts");
		// otherTemplates.put("manager.java.ftl",className + "Manager.java");

		File folder = new File(templateFolder);
		File[] tempFiles = folder.listFiles();

		String fileNameCExt = "";
		String fileName = "";
		for (int i = 0; i < tempFiles.length; i++) {
			if (tempFiles[i].isFile() && tempFiles[i].getName().toLowerCase().endsWith(".ftl")) {
				fileNameCExt = tempFiles[i].getName();
				// fileName = FilenameUtils.removeExtension(fileNameCExt);
				otherTemplates.put(fileNameCExt, fileName);
			}
		}
		return otherTemplates;
	}

	private static Map<String, Object> getApplicationTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("iappService.java.ftl", "I" + className + "AppService.java");
		backEndTemplate.put("appService.java.ftl", className + "AppService.java");
		backEndTemplate.put("mapper.java.ftl", className + "Mapper.java");
		backEndTemplate.put("appServiceTest.java.ftl", className + "AppServiceTest.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getRepositoryTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("irepository.java.ftl", "I" + className + "Repository.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getControllerTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("controller.java.ftl", className + "Controller.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getDomainTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("manager.java.ftl", className + "Manager.java");
		backEndTemplate.put("imanager.java.ftl", "I" + className + "Manager.java");
		backEndTemplate.put("managerTest.java.ftl", className + "ManagerTest.java");
		backEndTemplate.put("entity.java.ftl", className + "Entity.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getDtos(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("createInput.java.ftl", "Create" + className + "Input.java");
		backEndTemplate.put("createOutput.java.ftl", "Create" + className + "Output.java");
		backEndTemplate.put("updateInput.java.ftl", "Update" + className + "Input.java");
		backEndTemplate.put("updateOutput.java.ftl", "Update" + className + "Output.java");
		backEndTemplate.put("findByIdOutput.java.ftl", "Find" + className + "ByIdOutput.java");
		backEndTemplate.put("findByNameOutput.java.ftl", "Find" + className + "ByNameOutput.java");

		return backEndTemplate;
	}
  private static void getJarInfo(String jarPath,String entityName) {
	try{
	CGenClassLoader loader = new CGenClassLoader(jarPath);
	ArrayList<Class<?>> list = loader.findClasses("com.ninfinity.entitycodegen");
    Class<?> cls = loader.findClass(entityName);
	JarFile jarFile = new JarFile(jarPath);
	Enumeration e = jarFile.entries();
	
	URL[] urls = { new URL("jar:file:" + jarPath+"!/") };
	URLClassLoader cl = URLClassLoader.newInstance(urls);
	
	while (e.hasMoreElements()) {
		JarEntry je = (JarEntry) e.nextElement(); 
		
		/*if(je.isDirectory() || !je.getName().endsWith(".class")){
			continue;
		}	*/
		String className = je.getName(); //.substring(0,je.getName().length()-6);
		//className = className.replace("!/", ".");
		//className = className.replace('/','.'); 
		System.out.println(className);
		//Class<?> c = cl.loadClass(className);
	}
	}
	catch (ClassNotFoundException e) {
		e.printStackTrace();

	}
	catch(Exception ex){
		String x = ex.getMessage();
	}
  }
	private static EntityDetails getFieldNames(String entityPath, String entityName) {

		File file = new File(entityPath);
		// URI uri = file.toURI();
		URL url = FileUtils.toURL(file);
		URL[] urlList = { url };

		//URLClassLoader loader = URLClassLoader.newInstance(urlList);
		CGenClassLoader loader = new CGenClassLoader(entityPath);
		Map<String, FieldDetails> fieldsMap = new HashMap<>();
		Map<String, RelationDetails> relationsMap = new HashMap<>();
		List<RelationDetails> relationList = new ArrayList<>();

		try {
			Class<?> clazz = loader.findClass(entityName);// loader.loadClass(entityName);
			Field[] fields = clazz.getDeclaredFields();

			for (Field field : fields) {
				FieldDetails details = new FieldDetails();
				RelationDetails relation = new RelationDetails();
				String str = field.getType().toString();
				int index = str.lastIndexOf(".") + 1;
				details.setFieldName(field.getName());
				details.setFieldType(str.substring(index));

				System.out.println("\n Field \n " + field.getName() + " type  " + details.getFieldType());
				Annotation[] annotations = field.getDeclaredAnnotations();

				for (Annotation a : annotations) {
					System.out.println("\n annotations \n " + a);
					if (a.annotationType().toString().equals("interface javax.persistence.Column")) {
						String column = a.toString();
						index = column.indexOf("nullable");
						Boolean nullable = Boolean.valueOf(column.substring(index + 9, column.indexOf(",", index)));
						details.setIsNullable(nullable);

						index = column.indexOf("length");
						int length = Integer.valueOf(column.substring(index + 7, column.indexOf(",", index)));
						details.setLength(length);

					}
					if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
						details.setIsPrimaryKey(true);
					}
					if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
						relation.setRelation("ManyToOne");
						relation.setfName(field.getName());
						relation.seteName(details.getFieldType());
					}

					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
						String joinColumn = a.toString();
						index = joinColumn.indexOf("name");
						relation.setJoinColumn(joinColumn.substring(index + 5, joinColumn.indexOf(",", index)));
					}

					if (a.annotationType().toString().equals("interface javax.persistence.OneToMany")) {
						String relationalEntity = a.toString();
						index = relationalEntity.indexOf("targetEntity");
						String entityPackage = relationalEntity.substring(index + 19,
								relationalEntity.indexOf(",", index));
						String targetEntity = entityPackage.substring(entityPackage.lastIndexOf(".") + 1);

						Boolean isJoinTable = checkJoinTable(entityPackage, targetEntity);
						if (isJoinTable) {
							List<Map<String, String>> joinInfo = getFieldsIfJoinTable(entityPackage, targetEntity);
							relation.setRelation("ManyToMany");
							relation.setJoinTable(targetEntity);
							for (Map<String, String> map : joinInfo) {
								String className = entityName.substring(entityName.lastIndexOf(".") + 1);

								if (className.equals(map.get("fieldType"))) {
									relation.setJoinColumn(map.get("joinColumn"));
									relation.setReferenceColumn(map.get("referenceColumn"));
								} else {

									relation.setfName(map.get("fieldName"));
									details.setFieldName(map.get("fieldName"));
									details.setFieldType(map.get("fieldType"));
									relation.seteName(map.get("fieldType"));
									relation.setInverseJoinColumn(map.get("joinColumn"));
									relation.setInverseReferenceColumn(map.get("referenceColumn"));
								}
							}
						} else {
							relation.setRelation("OneToMany");
							details.setFieldName(targetEntity.toLowerCase());
							details.setFieldType(targetEntity);
							relation.seteName(targetEntity);
							relation.setfName(targetEntity.toLowerCase());
							index = relationalEntity.indexOf("mappedBy");
							relation.setMappedBy(
									relationalEntity.substring(index + 9, relationalEntity.indexOf(",", index)));

						}

					}

				}

				System.out.println(
						"\n relation details " + relation.getRelation() + " == en type " + details.getFieldType()
								+ " -- r entity name" + relation.geteName() + "-- field name " + relation.getfName());
				if (relation.geteName() != null)
					relationsMap.put(relation.getRelation(), relation);

				// relationList.add(relation);

				fieldsMap.put(details.getFieldName(), details);

			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();

		}

		return new EntityDetails(fieldsMap, relationsMap);
	}

	private static Boolean checkJoinTable(String EntityPackage, String EntityName) {

		try {
			Class<?> myClass = Class.forName(EntityPackage);
			Object classObj = (Object) myClass.newInstance();
			Annotation[] classAnnotations = classObj.getClass().getAnnotations();

			for (Annotation a : classAnnotations) {
				System.out.println("Class anno" + a.annotationType().toString());
				if (a.annotationType().toString().equals("interface javax.persistence.IdClass")) {
					System.out.println("inside ID check");
					return true;
				}
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return false;

	}

	private static List<Map<String, String>> getFieldsIfJoinTable(String EntityPackage, String EntityName) {
		System.out.println("\n entity package " + EntityPackage);
		List<Map<String, String>> relationShipFields = new ArrayList<>();

		Class<?> myClass;
		try {
			myClass = Class.forName(EntityPackage);
			Object classObj = (Object) myClass.newInstance();

			Field[] fields = classObj.getClass().getDeclaredFields();
			System.out.println("\n inside try ");
			for (Field field : fields) {
				Annotation[] annotations = field.getDeclaredAnnotations();
				Map<String, String> relationFields = new HashMap<>();
				for (Annotation a : annotations) {
					if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
						String str = field.getType().toString();
						int index = str.lastIndexOf(".") + 1;
						relationFields.put("fieldName", field.getName());
						relationFields.put("fieldType", str.substring(index));

					}
					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
						String str = a.toString();
						int index = str.indexOf("name");
						relationFields.put("joinColumn", str.substring(index + 5, str.indexOf(",", index)));
					}
				}

				if (relationFields.get("fieldType") != null) {
					System.out.println(" a   a  " + relationFields.get("fieldType"));
					String entity = StringUtils.substringBeforeLast(EntityPackage, ".");
					String referenceColumn = findPrimaryKey(entity.concat("." + relationFields.get("fieldType")),
							relationFields.get("fieldType"));
					if (referenceColumn != null)
						relationFields.put("referenceColumn", referenceColumn);
				}

				if (relationFields.get("fieldName") != null)
					relationShipFields.add(relationFields);

			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}

		return relationShipFields;
	}

	private static String findPrimaryKey(String entityPackage, String entityName) {
		String primaryKey = null;
		Class<?> myClass;
		try {
			myClass = Class.forName(entityPackage);
			Object classObj = (Object) myClass.newInstance();
			Field[] fields = classObj.getClass().getDeclaredFields();
			for (Field field : fields) {
				Annotation[] annotations = field.getDeclaredAnnotations();

				for (Annotation a : annotations) {
					if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
						primaryKey = field.getName();
						return primaryKey;
					}
				}
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}

		return null;
	}

}
