package com.nfinity.codegen;

class GitRepositoryManager {
    private static String destinationPath = null;
    private static String command = null;

    static void addToGitRepository(String path) {
        destinationPath = path;
        // Check if the application is already initialized as a git repository
        if (GitRepositoryManager.isGitInitialized()) {
            // Check to ensure that there are no un-committed local changes in the
            // repository- TODO
            // exit if there are un-committed local changes

            // Delete if upgrade orphan branch exists
            deleteUpgradeBranchIfExists();
            mergeToMasterBranch();
        } else {
            // Initialize the directory as git repository
            initializeGit();
            // Add code to master branch
            createMasterBranch();
        }
    }

    private static void createMasterBranch() {
        command = "git add *";
        CommandUtils.runProcess(command, destinationPath);

        command = "git commit -m \"Initial code commit\"";
        CommandUtils.runProcess(command, destinationPath);
    }

    private static void initializeGit() {
        // Initialize directory as git repository
        command = "git init";
        CommandUtils.runProcess(command, destinationPath);

        // Set required configuration
        command = "git config --global user.name \"fastCode\"";
        CommandUtils.runProcess(command, destinationPath);

        command = "git config --global user.email \"info@nfinityllc.com\"";
        CommandUtils.runProcess(command, destinationPath);
    }

    private static void mergeToMasterBranch() {
        // Create an orphan branch to stage the new changes
        command = "git checkout --orphan upgrade_application";
        CommandUtils.runProcess(command, destinationPath);
        // Add all files to the upgrade branch
        command = "git add *";
        CommandUtils.runProcess(command, destinationPath);
        // Commit the changes to the upgrade branch
        command = "git commit -m \"Upgrade at \""
                + new java.text.SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date());
        CommandUtils.runProcess(command, destinationPath);
        // Switch to master branch for merging
        command = "git checkout master";
        CommandUtils.runProcess(command, destinationPath);
        // Merge changes from Upgrade branch to master branch
        command = "git merge --allow-unrelated-histories upgrade_application";
        CommandUtils.runProcess(command, destinationPath);
    }

    private static void deleteUpgradeBranchIfExists() {
        // Check if orphan branch exists
        command = "git rev-parse --verify upgrade_application";
        String output = CommandUtils.runProcess(command, destinationPath);
        if (output.toLowerCase().contains("fatal")) {
            // Delete the branch since all the changes are merged and committed in the
            // master branch
            command = "git branch -D upgrade_application";
            CommandUtils.runProcess(command, destinationPath);
        }
    }

    private static Boolean isGitInitialized() {
        command = "git rev-parse --is-inside-work-tree";
        String commandResult = CommandUtils.runProcess(command, destinationPath);
        return commandResult.trim().equalsIgnoreCase("true");
    }

}
