package com.nfinity.codegen;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.FieldDetails;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class FlowableBackendCodeGenerator {
    static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
    static final String FLOWABLE_BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/flowableTemplates";

    public static void generateFlowableClasses(Map<String, EntityDetails> details, String destination, String packageName, String authenticationType, String authenticationTable) {
        ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, FLOWABLE_BACKEND_TEMPLATE_FOLDER + "/");
        TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl};
        MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
        cfg.setDefaultEncoding("UTF-8");
        cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
        cfg.setTemplateLoader(mtl);

        String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/");
        Map<String, Object> root = new HashMap<>();
        //root.put("AuditPackage", packageName);
        //packageName = packageName.concat(".CommonModule");
        
        root.put("PackageName", packageName);
        root.put("AuthenticationType", authenticationType);
        if(authenticationTable !=null) {
        	root.put("AuthenticationTable", authenticationTable);
        	root.put("AuthenticationFields", getCustomUserAuthFieldsMap(details, authenticationTable));;
        }
        else
            root.put("AuthenticationTable", "User");
        //root.put("Audit", audit);

        generateFlowableFiles(root, backendAppFolder, authenticationType);
    }

    private static void generateFlowableFiles(Map<String, Object> root, String destPath, String authenticationType) {
        String destFolderBackend;
        destFolderBackend = destPath + "/application/Flowable";
        new File(destFolderBackend).mkdirs();
        generateFiles(getFlowableApplicationTemplates(authenticationType), root, destFolderBackend);

        destFolderBackend = destPath + "/domain";
        new File(destFolderBackend).mkdirs();
        generateFiles(getFlowableCustomSchemaTemplates(), root, destFolderBackend);

        destFolderBackend = destPath + "/domain/Flowable/Tokens";
        new File(destFolderBackend).mkdirs();
        generateFiles(getFlowableDomainTokensTemplates(), root, destFolderBackend);

        if(!authenticationType.equalsIgnoreCase("none")) {
            destFolderBackend = destPath + "/domain/Flowable/Users";
            new File(destFolderBackend).mkdirs();
            generateFiles(getFlowableDomainUsersTemplates(), root, destFolderBackend);

            destFolderBackend = destPath + "/domain/Flowable/Groups";
            new File(destFolderBackend).mkdirs();
            generateFiles(getFlowableDomainGroupsTemplates(), root, destFolderBackend);

            destFolderBackend = destPath + "/domain/Flowable/Privileges";
            new File(destFolderBackend).mkdirs();
            generateFiles(getFlowableDomainPrivilegesTemplates(), root, destFolderBackend);

            destFolderBackend = destPath + "/domain/Flowable/PrivilegeMappings";
            new File(destFolderBackend).mkdirs();
            generateFiles(getFlowableDomainPrivilegeMappingsTemplates(), root, destFolderBackend);

            destFolderBackend = destPath + "/domain/Flowable/Memberships";
            new File(destFolderBackend).mkdirs();
            generateFiles(getFlowableDomainMembershipsTemplates(), root, destFolderBackend);

        }
        destFolderBackend = destPath + "/domain/IRepository";
        new File(destFolderBackend).mkdirs();
        generateFiles(getFlowableRepositoryTemplates(authenticationType), root, destFolderBackend);

    }

    private static Map<String, Object> getFlowableApplicationTemplates(String authenticationType) {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("FlowableIdentityService.java.ftl", "FlowableIdentityService.java");
        if(!authenticationType.equalsIgnoreCase("none")) {
            flowableBackendTemplate.put("ActIdUserMapper.java.ftl", "ActIdUserMapper.java");
            flowableBackendTemplate.put("ActIdGroupMapper.java.ftl", "ActIdGroupMapper.java");
        }
        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableDomainUsersTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("Users/ActIdUserEntity.java.ftl", "ActIdUserEntity.java");
        flowableBackendTemplate.put("Users/ActIdUserManager.java.ftl", "ActIdUserManager.java");
        flowableBackendTemplate.put("Users/ActIdUserManagerTest.java.ftl", "ActIdUserManagerTest.java");
        flowableBackendTemplate.put("Users/IActIdUserManager.java.ftl", "IActIdUserManager.java");

        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableDomainTokensTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("Tokens/ActIdTokenEntity.java.ftl", "ActIdTokenEntity.java");
        flowableBackendTemplate.put("Tokens/ActIdTokenManager.java.ftl", "ActIdTokenManager.java");
        flowableBackendTemplate.put("Tokens/ActIdTokenManagerTest.java.ftl", "ActIdTokenManagerTest.java");
        flowableBackendTemplate.put("Tokens/IActIdTokenManager.java.ftl", "IActIdTokenManager.java");

        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableDomainPrivilegesTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("Privileges/ActIdPrivEntity.java.ftl", "ActIdPrivEntity.java");
        flowableBackendTemplate.put("Privileges/ActIdPrivManager.java.ftl", "ActIdPrivManager.java");
        flowableBackendTemplate.put("Privileges/ActIdPrivManagerTest.java.ftl", "ActIdPrivManagerTest.java");
        flowableBackendTemplate.put("Privileges/IActIdPrivManager.java.ftl", "IActIdPrivManager.java");

        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableDomainPrivilegeMappingsTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("PrivilegeMappings/ActIdPrivMappingEntity.java.ftl", "ActIdPrivMappingEntity.java");
        flowableBackendTemplate.put("PrivilegeMappings/ActIdPrivMappingManager.java.ftl", "ActIdPrivMappingManager.java");
        flowableBackendTemplate.put("PrivilegeMappings/ActIdPrivMappingManagerTest.java.ftl", "ActIdPrivMappingManagerTest.java");
        flowableBackendTemplate.put("PrivilegeMappings/IActIdPrivMappingManager.java.ftl", "IActIdPrivMappingManager.java");

        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableDomainMembershipsTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("Memberships/ActIdMembershipEntity.java.ftl", "ActIdMembershipEntity.java");
        flowableBackendTemplate.put("Memberships/ActIdMembershipManager.java.ftl", "ActIdMembershipManager.java");
        flowableBackendTemplate.put("Memberships/ActIdMembershipManagerTest.java.ftl", "ActIdMembershipManagerTest.java");
        flowableBackendTemplate.put("Memberships/IActIdMembershipManager.java.ftl", "IActIdMembershipManager.java");
        flowableBackendTemplate.put("Memberships/MembershipId.java.ftl", "MembershipId.java");

        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableDomainGroupsTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("Groups/ActIdGroupEntity.java.ftl", "ActIdGroupEntity.java");
        flowableBackendTemplate.put("Groups/ActIdGroupManager.java.ftl", "ActIdGroupManager.java");
        flowableBackendTemplate.put("Groups/ActIdGroupManagerTest.java.ftl", "ActIdGroupManagerTest.java");
        flowableBackendTemplate.put("Groups/IActIdGroupManager.java.ftl", "IActIdGroupManager.java");

        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableRepositoryTemplates(String authenticationType) {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("Tokens/IActIdTokenRepository.java.ftl", "IActIdTokenRepository.java");
        if(!authenticationType.equalsIgnoreCase("none")) {
            flowableBackendTemplate.put("Users/IActIdUserRepository.java.ftl", "IActIdUserRepository.java");
            flowableBackendTemplate.put("Groups/IActIdGroupRepository.java.ftl", "IActIdGroupRepository.java");
            flowableBackendTemplate.put("Privileges/IActIdPrivRepository.java.ftl", "IActIdPrivRepository.java");
            flowableBackendTemplate.put("PrivilegeMappings/IActIdPrivMappingRepository.java.ftl", "IActIdPrivMappingRepository.java");
            flowableBackendTemplate.put("Memberships/IActIdMembershipRepository.java.ftl", "IActIdMembershipRepository.java");
        }
        return flowableBackendTemplate;
    }

    private static Map<String, Object> getFlowableCustomSchemaTemplates() {
        Map<String, Object> flowableBackendTemplate = new HashMap<>();

        flowableBackendTemplate.put("CustomSchemaFilter.java.ftl", "CustomSchemaFilter.java");
        flowableBackendTemplate.put("CustomSchemaFilterProvider.java.ftl", "CustomSchemaFilterProvider.java");

        return flowableBackendTemplate;
    }

    private static void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath) {
        for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
            try {
                Template template = cfg.getTemplate(entry.getKey());

                String entryPath = entry.getValue().toString();
                File fileName = new File(destPath + "/" + entry.getValue().toString());

                String dirPath = destPath;
                if(destPath.split("/").length > 1 && entryPath.split("/").length > 1) {
                    dirPath = dirPath + entryPath.substring(0, entryPath.lastIndexOf('/'));
                }
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
    
    private static Map<String, FieldDetails> getCustomUserAuthFieldsMap(Map<String, EntityDetails> details, String authenticationTable) {
    	
    	for(Map.Entry<String, EntityDetails> entityDetail: details.entrySet()) {
    		if( entityDetail.getKey().contentEquals(authenticationTable)) {
    			return entityDetail.getValue().getAuthenticationFieldsMap();
    		}
    	}
    	
    	return null;
    }

}
