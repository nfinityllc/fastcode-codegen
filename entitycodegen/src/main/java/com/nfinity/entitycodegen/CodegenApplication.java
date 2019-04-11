package com.nfinity.entitycodegen;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CodegenApplication{

    public static void main(String[] args) { 
        SpringApplication.run(CodegenApplication.class, args); 
 
        // added by getachew otheroption = -n=sdemo -j=1.8 
        // You can get the dir, a and g input from the command line 
//    BaseAppGen.CreateBaseApplication("/home/farah/fastCodeGit", "sdemo", "com.example", "web,data-jpa,", true, 
//            " -n=sdemo -j=1.8 "); 
 
        Scanner scanner = new Scanner(System.in); 
 
        UserInput input = GetUserInput.getInput(scanner); 
        System.out.println(" package name " + input.getPackageName() + "\n destination path " 
                + input.getDestinationPath() + "\n schema name   " + input.getSchemaName() + " \n audit " 
                + input.getAudit() + "\n audit package " + input.getAuditPackage()); 
 
        run(input.getSchemaName(),input.getTablesList(),input.getPackageName(),input.getDestinationPath(),input.getAudit(),input.getAuditPackage());
     
    } 
    
    public static void run(String schema,List<String> tableList,String packageName,String destination,Boolean audit,String auditPackage)
    {
    	BaseAppGen.CreateBaseApplication("/home/farah/fastCodeGit", "sdemo", "com.nfinity", "web,data-jpa", true, 
               " -n=sdemo -j=1.8 "); 
 
        final String tempPackageName = packageName.concat(".Temp"); 
        destination = destination.replace('\\', '/');
        final String destinationPath = destination.concat("/src/main/java"); 
        final String targetPath = destination.concat("/target/classes"); 
        String tables="";
        for(int i=0;i<tableList.size();i++)
        {
        	if(!tableList.get(i).isEmpty())
        	{
        	if(i<tableList.size()-1)
        	tables= tables + schema.concat("." + tableList.get(i) + ",");
        	else
            tables= tables + schema.concat("." + tableList.get(i) );
        	}
        }
 
        if(!tables.isEmpty())
        {
        	ReverseMapping.run(tempPackageName, destinationPath, tables); 
        }
        else
        ReverseMapping.run(tempPackageName, destinationPath, schema); 
        try { 
            Thread.sleep(28000); 
        } catch (InterruptedException e) { 
            e.printStackTrace(); 
        } 
 
        deleteFile(destinationPath + "/orm.xml"); 
        try { 
            Utils.runCommand("mvn compile", destination); 
        } catch (Exception e) { 
            System.out.println("Compilation Error"); 
            e.printStackTrace(); 
        } 
        CGenClassLoader loader = new CGenClassLoader(targetPath); 
        
        ArrayList<Class<?>> entityClasses; 
        try { 
            entityClasses = loader.findClasses(tempPackageName); 
            ClassDetails classDetails = getClasses(entityClasses); 
            List<Class<?>> classList = classDetails.getClassesList(); 
            List<String> relationClassList = classDetails.getRelationClassesList(); 
            List<String> relationInputList = GetUserInput.getRelationInput(classList, relationClassList, 
                    destination, tempPackageName); 
 
            for (Class<?> currentClass : classList) { 
                String entityName = currentClass.getName(); 
                if (!relationClassList.contains(entityName)) { 
                    EntityDetails details = GetEntityDetails.getDetails(currentClass, entityName, classList); 
                    EntityGenerator.Generate(entityName, details, "sample", packageName, 
                            destinationPath , relationInputList,audit, auditPackage); 
                } 
 
            } 
        } catch (ClassNotFoundException ex) { 
            ex.printStackTrace(); 
 
        } 
 
        if (audit) { 
            EntityGenerator.generateAuditEntity(destinationPath, auditPackage); 
        } 
     
        deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/")); 
        System.out.println(" exit "); 
    }

	public static void deleteFile(String directory) {
		System.out.println(" Directory " + directory);
		File file = new File(directory);
		if (file.exists()) {
			file.delete();
		}
	}

	public static void deleteDirectory(String directory) {
		File file = new File(directory);
		File[] contents = file.listFiles();
		if (contents != null) {
			for (File f : contents) {
				if (f.isDirectory())
					deleteDirectory(f.getAbsolutePath());
				else
					f.delete();
			}
		}
		file.delete();
	}

	public static ClassDetails getClasses(ArrayList<Class<?>> entityClasses) {
		List<String> entityClassNames = new ArrayList<>();
		for (Class<?> currentClass : entityClasses) {
			String entityName = currentClass.getName();
			entityClassNames.add(entityName);
		}

		List<String> relationClass = new ArrayList<>();
		List<Class<?>> classList = new ArrayList<>();

		for (Class<?> currentClass : entityClasses) {
			String entityName = currentClass.getName();
			if (entityName.contains("Id")) {
				if (!entityName.contains("Tokenizer")) {
					String className = entityName.substring(0, entityName.indexOf("Id"));

					if (!entityClassNames.contains(className))
						classList.add(currentClass);
					else
						relationClass.add(className);
				}
			} else {
				classList.add(currentClass);
			}
		}
		return new ClassDetails(classList, relationClass);
	}


}