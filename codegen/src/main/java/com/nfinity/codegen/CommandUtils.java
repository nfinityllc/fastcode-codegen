package com.nfinity.codegen;

import java.io.*;

class CommandUtils {
    private static ProcessBuilder builder = null;

    public static String runProcess(String[] command, String path, Boolean writeOutput) {
        try {
            if (builder == null)
                builder = new ProcessBuilder();

            File cmdDirectory = new File(path);

            Process process;
            builder.command(command);
            builder.directory(cmdDirectory);

            // System.out.println("" + builder.directory());
            // System.out.println("" + builder.command());

            process = builder.start();
            StringBuilder outputValue = new StringBuilder();

            BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = br.readLine()) != null) {
                if (writeOutput) {
                    System.out.println(line);
                }
                outputValue.append(line);
                outputValue.append("\n");
            }
            int exitCode = 0;
            exitCode = process.waitFor();
            assert exitCode == 0;
            return outputValue.toString().trim();
        } catch (Exception e) {
            throw new InternalError(e);
        }
    }

    static String runProcess(String command, String path) {
        String[] builderCommand = getBuilderCommand(command);
        return runProcess(builderCommand, path, true);
    }

    static String runGitProcess(String args, String path) {
        String command = "git " + args;
        String[] builderCommand = getBuilderCommand(command);
        return runProcess(builderCommand, path, true);
    }

    private static String[] getBuilderCommand(String command) {
        String[] builderCommand;
        boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
        if (isWindows) {
            builderCommand = new String[] { "cmd.exe", "/c", command };
        } else {
            builderCommand = new String[] { "sh", "-c", command };
        }
        return builderCommand;
    }
}
