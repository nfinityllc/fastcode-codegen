package com.nfinity.entitycodegen;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.util.FileSystemUtils;

import java.io.*;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class BaseAppGen {
    public static ProcessBuilder builder = null;

    private static void RunProcess(String[] builderCommand, String dir) throws Exception {
        if (builder == null)
            builder = new ProcessBuilder();

        File cmdDirectory = new File(dir);

        Process process;
        builder.command(builderCommand);
        builder.directory(cmdDirectory);

        System.out.println("" + builder.directory());
        System.out.println("" + builder.command());

        process = builder.start();
        StreamGobbler streamGobbler = null;
        if (process != null) {
            streamGobbler = new StreamGobbler(process.getInputStream(), System.out::println);
        }
        if (streamGobbler != null) {
            Executors.newSingleThreadExecutor().submit(streamGobbler);
        }
        int exitCode = 0;
        if (process != null) {
            exitCode = process.waitFor();

            process.destroy();
        }

        assert exitCode == 0;
    }

    public static void CompileApplication(String destDirectory) throws Exception {

        boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");

        String[] builderCommand;
        if (isWindows) {
            builderCommand = new String[] { "cmd.exe", "/c", "mvn" + " clean" };
        } else {
            builderCommand = new String[] { "sh", "-c", "mvn" + " clean" };
        }

        // String[] builderCommand = new String[] { "cmd.exe", "/c", "mvn" + " clean" };

        RunProcess(builderCommand, destDirectory);

        builderCommand = isWindows ? new String[] { "cmd.exe", "/c", "mvn" + " compile" }
                : new String[] { "sh", "-c", "mvn" + " compile" };

        // builderCommand = new String[] { "cmd.exe", "/c", "mvn" + " compile" };

        RunProcess(builderCommand, destDirectory);

        /*
         * builderCommand = new String[] { "cmd.exe", "/c", "mvn" + " install" };
         * 
         * RunProcess(builderCommand, destDirectory);
         */
    }

    /*
     * dir="/Users/getachew/fc/exer" a="sdemo" g="com.nfinity" d="web,data-jpa"
     */
    public static void CreateBaseApplication(String dir, String a, String g, String d, boolean overRide,
            String otherOptions) {
        String appName = a.substring(a.lastIndexOf(".") + 1);
        boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
        String cliCommand = " -a=" + a + " -g=" + g + " -d=" + d + " " + appName + " " + otherOptions;
        String[] builderCommand;
        if (isWindows) {
            builderCommand = new String[] { "cmd.exe", "/c", "spring" + " init" + cliCommand };
        } else {
            builderCommand = new String[] { "sh", "-c", "spring" + " init" + cliCommand };
        }
        String cmdDirectory;
        if (!dir.isEmpty()) {
            cmdDirectory = dir;
        } else {
            cmdDirectory = System.getProperty("user.home");
        }

        try {
            File destDir = new File(cmdDirectory + "/" + appName);
            if (destDir.exists() && overRide)
                FileSystemUtils.deleteRecursively(destDir);

            RunProcess(builderCommand, cmdDirectory);

            // if (!destDir.exists())
            // destDir.mkdir();
            CompileApplication(destDir.getPath());

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }

    private static class StreamGobbler implements Runnable {
        private InputStream inputStream;
        private Consumer<String> consumer;

        StreamGobbler(InputStream inputStream, Consumer<String> consumer) {
            this.inputStream = inputStream;
            this.consumer = consumer;
        }

        @Override
        public void run() {
            new BufferedReader(new InputStreamReader(inputStream)).lines().forEach(consumer);
        }
    }
}