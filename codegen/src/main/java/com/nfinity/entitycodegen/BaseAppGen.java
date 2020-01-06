package com.nfinity.entitycodegen;

import java.io.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.FileSystemUtils;

import com.nfinity.codegen.CommandUtils;

@Component
public class BaseAppGen {
	
    public static ProcessBuilder builder = null;
    
    @Autowired
    CommandUtils commandUtils;

//    private static void RunProcess(String[] builderCommand, String dir) throws Exception {
//        if (builder == null)
//            builder = new ProcessBuilder();
//
//        File cmdDirectory = new File(dir);
//
//        Process process;
//        builder.command(builderCommand);
//        builder.directory(cmdDirectory);
//
//        System.out.println("" + builder.directory());
//        System.out.println("" + builder.command());
//
//        process = builder.start();
//        StreamGobbler streamGobbler = null;
//        if (process != null) {
//            streamGobbler = new StreamGobbler(process.getInputStream(), System.out::println);
//        }
//        if (streamGobbler != null) {
//            Executors.newSingleThreadExecutor().submit(streamGobbler);
//        }
//        int exitCode = 0;
//        if (process != null) {
//            exitCode = process.waitFor();
//
//            process.destroy();
//        }
//
//        assert exitCode == 0;
//    }

    public void CompileApplication(String destDirectory)  {

        boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");

        String[] builderCommand;
        if (isWindows) {
            builderCommand = new String[] { "cmd.exe", "/c", "mvn" + " clean" };
        } else {
            builderCommand = new String[] { "sh", "-c", "mvn" + " clean" };
        }
        
        try {
        	commandUtils.runProcess(builderCommand, destDirectory,true);

        builderCommand = isWindows ? new String[] { "cmd.exe", "/c", "mvn" + " compile" }
                : new String[] { "sh", "-c", "mvn" + " compile" };

        commandUtils.runProcess(builderCommand, destDirectory,true);

         }
         catch(Exception ex){
            ex.printStackTrace();
         }
    }

    /*
     * dir="/Users/getachew/fc/exer" a="sdemo" g="com.nfinity" d="web,data-jpa"
     */
    public void CreateBaseApplication(String directory, String appName, String groupId, String dependency,
            boolean overRide, String otherOptions) {
       
    	boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
        String cliCommand = " -b=2.1.9.RELEASE " + "-a=" + appName + " -g=" + groupId + " -d=" + dependency + " " + otherOptions + " "
                + appName;
        String[] builderCommand;
        if (isWindows) {
            builderCommand = new String[] { "cmd.exe", "/c", "spring" + " init" + cliCommand };
        } else {
            builderCommand = new String[] { "sh", "-c", "spring" + " init" + cliCommand };
        }
        String cmdDirectory;
        if (!directory.isEmpty()) {
            cmdDirectory = directory;
        } else {
            cmdDirectory = System.getProperty("user.home");
        }

        try {
            File destDir = new File(cmdDirectory + "/" + appName);
         
            if (destDir.exists() && overRide)
            {
                FileSystemUtils.deleteRecursively(destDir);
            }

            commandUtils.runProcess(builderCommand, cmdDirectory,true);

            CompileApplication(destDir.getPath());

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }

}