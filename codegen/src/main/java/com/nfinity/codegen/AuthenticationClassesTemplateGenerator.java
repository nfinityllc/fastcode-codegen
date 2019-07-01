package com.nfinity.codegen;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class AuthenticationClassesTemplateGenerator {
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String SECURITY_CLASSES_TEMPLATE_FOLDER = "/templates/backendTemplates/authenticationTemplates";
	
	public static void generateAutheticationClasses(String destination, String packageName,Boolean audit,Boolean history,String authenticationType
			,String schemaName) {
	//	Map<String, Object> templates = new HashMap<>();

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, SECURITY_CLASSES_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);
		
		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/");
		
		Map<String, Object> root = new HashMap<>();
		System.out.println("PASSS "+ packageName);
		root.put("PackageName", packageName);
		root.put("Audit", audit);
		root.put("History", history);
		root.put("CommonModulePackage" , "com.nfinity.fastcode");
		root.put("AuthenticationType",authenticationType);
		root.put("Schema",schemaName);
		
		generateBackendFiles(root, backendAppFolder);

	}
	
	private static void generateBackendFiles(Map<String, Object> root, String destPath) {
        String authenticationType =root.get("AuthenticationType").toString();
        String destFolderBackend;
        if(authenticationType=="database")
        {
		destFolderBackend = destPath + "/application/Authorization/Users" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getUserApplicationLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/Authorization/Users" ;
		new File(destFolderBackend).mkdirs();
		generateFiles(getUserManagerLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Users/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getUserDtoTemplates(), root, destFolderBackend);
        }
        
        destFolderBackend = destPath;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSecurityConfigurationTemplates(root.get("AuthenticationType").toString()), root, destFolderBackend);
        
        destFolderBackend = destPath + "/security";
		new File(destFolderBackend).mkdirs();
		generateFiles(getSecurityModuleTemplates(root.get("AuthenticationType").toString()), root, destFolderBackend);
        
		destFolderBackend = destPath + "/application/Authorization/Permissions";
		new File(destFolderBackend).mkdirs();
		generateFiles(getPermissionApplicationLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/Authorization/Permissions";
		new File(destFolderBackend).mkdirs();
		generateFiles(getPermissionManagerLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/Authorization/Permissions/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getPermissionDtoTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/Authorization/Roles";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRoleApplicationLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/Authorization/Roles";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRoleManagerLayerTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/application/Authorization/Roles/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRoleDtoTemplates(), root, destFolderBackend);
		
		destFolderBackend = destPath + "/domain/IRepository";
		new File(destFolderBackend).mkdirs();
		generateFiles(getAuthenticationRepositoriesTemplates(root.get("AuthenticationType").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/RestControllers";
		new File(destFolderBackend).mkdirs();
		generateFiles(getAuthenticationControllerTemplates(root.get("AuthenticationType").toString()), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/model";
		new File(destFolderBackend).mkdirs();
		generateFiles(getAuthenticationEntitiesTemplates(root.get("AuthenticationType").toString()), root, destFolderBackend);

		
		
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
				writer.close();

			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}
	
	private static Map<String, Object> getUserApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("users/iuserAppService.java.ftl", "IUserAppService.java");
		backEndTemplate.put("users/userAppService.java.ftl", "UserAppService.java");
		backEndTemplate.put("users/userMapper.java.ftl", "UserMapper.java");
		backEndTemplate.put("users/userAppServiceTest.java.ftl", "UserAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getUserManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("users/iuserManager.java.ftl", "IUserManager.java");
		backEndTemplate.put("users/userManager.java.ftl", "UserManager.java");
		backEndTemplate.put("users/userManagerTest.java.ftl", "UserManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getPermissionApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("permissions/ipermissionsAppService.java.ftl", "IPermissionAppService.java");
		backEndTemplate.put("permissions/permissionsAppService.java.ftl", "PermissionAppService.java");
		backEndTemplate.put("permissions/permissionsMapper.java.ftl", "PermissionMapper.java");
		backEndTemplate.put("permissions/permissionsAppServiceTest.java.ftl", "PermissionAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getPermissionManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("permissions/ipermissionsManager.java.ftl", "IPermissionsManager.java");
		backEndTemplate.put("permissions/permissionsManager.java.ftl", "PermissionsManager.java");
		backEndTemplate.put("permissions/permissionsManagerTest.java.ftl", "PermissionsManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getRoleApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("roles/irolesAppService.java.ftl", "IRoleAppService.java");
		backEndTemplate.put("roles/rolesAppService.java.ftl", "RoleAppService.java");
		backEndTemplate.put("roles/rolesMapper.java.ftl", "RoleMapper.java");
		backEndTemplate.put("roles/rolesAppServiceTest.java.ftl", "RoleAppServiceTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getRoleManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("roles/irolesManager.java.ftl", "IRolesManager.java");
		backEndTemplate.put("roles/rolesManager.java.ftl", "RolesManager.java");
		backEndTemplate.put("roles/rolesManagerTest.java.ftl", "RoleManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getUserDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("users/dtos/CreateUserInput.java.ftl", "CreateUserInput.java");
		backEndTemplate.put("users/dtos/CreateUserOutput.java.ftl", "CreateUserOutput.java");
		backEndTemplate.put("users/dtos/UpdateUserInput.java.ftl", "UpdateUserInput.java");
		backEndTemplate.put("users/dtos/UpdateUserOutput.java.ftl", "UpdateUserOutput.java");
		backEndTemplate.put("users/dtos/FindUserByIdOutput.java.ftl", "FindUserByIdOutput.java");
		backEndTemplate.put("users/dtos/FindUserByNameOutput.java.ftl", "FindUserByNameOutput.java");
		backEndTemplate.put("users/dtos/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
		backEndTemplate.put("users/dtos/GetRoleOutput.java.ftl", "GetRoleOutput.java");
		backEndTemplate.put("users/dtos/LoginUserInput.java.ftl", "LoginUserInput.java");
		return backEndTemplate;
	}
	
	private static Map<String, Object> getPermissionDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("permissions/dtos/CreatePermissionInput.java.ftl", "CreatePermissionInput.java");
		backEndTemplate.put("permissions/dtos/CreatePermissionOutput.java.ftl", "CreatePermissionOutput.java");
		backEndTemplate.put("permissions/dtos/UpdatePermissionInput.java.ftl", "UpdatePermissionInput.java");
		backEndTemplate.put("permissions/dtos/UpdatePermissionOutput.java.ftl", "UpdatePermissionOutput.java");
		backEndTemplate.put("permissions/dtos/FindPermissionByIdOutput.java.ftl", "FindPermissionByIdOutput.java");
		backEndTemplate.put("permissions/dtos/FindPermissionByNameOutput.java.ftl", "FindPermissionByNameOutput.java");
		
		return backEndTemplate;
	}
	
	private static Map<String, Object> getRoleDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("roles/dtos/CreateRoleInput.java.ftl", "CreateRoleInput.java");
		backEndTemplate.put("roles/dtos/CreateRoleOutput.java.ftl", "CreateRoleOutput.java");
		backEndTemplate.put("roles/dtos/UpdateRoleInput.java.ftl", "UpdateRoleInput.java");
		backEndTemplate.put("roles/dtos/UpdateRoleOutput.java.ftl", "UpdateRoleOutput.java");
		backEndTemplate.put("roles/dtos/FindRoleByIdOutput.java.ftl", "FindRoleByIdOutput.java");
		backEndTemplate.put("roles/dtos/FindRoleByNameOutput.java.ftl", "FindRoleByNameOutput.java");
		backEndTemplate.put("roles/dtos/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
		return backEndTemplate;
	}
	
	
	private static Map<String, Object> getAuthenticationControllerTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType=="database") {
		backEndTemplate.put("users/userController.java.ftl", "UserController.java");
		}
		
		backEndTemplate.put("permissions/permissionsController.java.ftl", "PermissionController.java");
		backEndTemplate.put("roles/rolesController.java.ftl", "RoleController.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getAuthenticationRepositoriesTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType=="database") {
		backEndTemplate.put("users/iuserRepository.java.ftl", "IUsersRepository.java");
		backEndTemplate.put("users/UsersCustomRepositoryImpl.java.ftl", "UsersCustomRepositoryImpl.java");
		backEndTemplate.put("users/UsersCustomRepository.java.ftl", "UsersCustomRepository.java");
		
		}
		
		backEndTemplate.put("permissions/ipermissionsRepository.java.ftl", "IPermissionsRepository.java");
		backEndTemplate.put("roles/irolesRepository.java.ftl", "IRolesRepository.java");
		backEndTemplate.put("roles/RolesCustomRepositoryImpl.java.ftl", "RolesCustomRepositoryImpl.java");
		backEndTemplate.put("roles/RolesCustomRepository.java.ftl", "RolesCustomRepository.java");
		return backEndTemplate;
	}
	
	private static Map<String, Object> getAuthenticationEntitiesTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType=="database") {
		backEndTemplate.put("entities/userEntity.java.ftl", "UsersEntity.java");
		}
		
		backEndTemplate.put("entities/permissionEntity.java.ftl", "PermissionsEntity.java");
		backEndTemplate.put("entities/roleEntity.java.ftl", "RolesEntity.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getSecurityModuleTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType != "none") {
		backEndTemplate.put("security/JWTAuthenticationFilter.java.ftl", "JWTAuthenticationFilter.java");
		backEndTemplate.put("security/JWTAuthorizationFilter.java.ftl", "JWTAuthorizationFilter.java");
		backEndTemplate.put("security/SecurityConstants.java.ftl", "SecurityConstants.java");
		}
	
		return backEndTemplate;
	}
	
	private static Map<String, Object> getSecurityConfigurationTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType != "none") {
			if(authenticationType == "database")
			{
				backEndTemplate.put("BeanConfig.java.ftl", "BeanConfig.java");
				backEndTemplate.put("AuditorAwareImpl.java.ftl", "AuditorAwareImpl.java");
				backEndTemplate.put("UserDetailsServiceImpl.java.ftl", "UserDetailsServiceImpl.java");
			}
		backEndTemplate.put("SecurityConfig.java.ftl", "SecurityConfig.java");
		}
		

		return backEndTemplate;
	}
}
