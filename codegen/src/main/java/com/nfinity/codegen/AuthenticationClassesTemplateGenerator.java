package com.nfinity.codegen;


import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.nfinity.entitycodegen.EntityDetails;
import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;

public class AuthenticationClassesTemplateGenerator {
	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String SECURITY_CLASSES_TEMPLATE_FOLDER = "/templates/backendTemplates/authenticationTemplates";
	static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";

	public static void generateAutheticationClasses(String destination, String packageName, Boolean history, Boolean cache,Boolean flowable, Boolean scheduler, Boolean email,String authenticationType
			,String schemaName,String authenticationTable,Map<String,EntityDetails> details) {

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, SECURITY_CLASSES_TEMPLATE_FOLDER + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] {ctl};
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);

		String backendAppFolder = destination + "/" + packageName.substring(packageName.lastIndexOf(".") + 1) + "/src/main/java/" + packageName.replace(".", "/");

		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		root.put("History", history);
		root.put("Flowable", flowable);
		root.put("Cache", cache);
		root.put("CommonModulePackage" , packageName.concat(".CommonModule"));
		root.put("AuthenticationType",authenticationType);
		root.put("SchemaName",schemaName);
		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}

		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			if(authenticationTable!=null)
			{
				if(className.equalsIgnoreCase(authenticationTable))
				{
					root.put("ClassName", className);
					root.put("CompositeKeyClasses",entry.getValue().getCompositeKeyClasses());
					root.put("Fields", entry.getValue().getFieldsMap());
					root.put("AuthenticationFields", entry.getValue().getAuthenticationFieldsMap());
					root.put("DescriptiveField", entry.getValue().getEntitiesDescriptiveFieldMap());
					root.put("PrimaryKeys", entry.getValue().getPrimaryKeys());
				}
			}

		}
		
		generateBackendFiles(root, backendAppFolder,authenticationTable);
		generateFrontendAuthorization(destination, packageName, authenticationType, authenticationTable, root, flowable);
		generateAppStartupRunner(details, backendAppFolder, email, scheduler,root);
	}

	private static void generateBackendFiles(Map<String, Object> root, String destPath,String authenticationTable) {
		String authenticationType =root.get("AuthenticationType").toString();
		String destFolderBackend;
		if(authenticationType!="none" && authenticationTable == null)
		{
			destFolderBackend = destPath + "/application/Authorization/User" ;
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserApplicationLayerTemplates(), root, destFolderBackend);

			destFolderBackend = destPath + "/domain/Authorization/User" ;
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserManagerLayerTemplates(), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/User/Dto";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserDtoTemplates(), root, destFolderBackend);

			destFolderBackend = destPath + "/domain/Authorization/Userpermission" ;
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserPermissionManagerLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/Userpermission" ;
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserPermissionApplicationLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/Userpermission/Dto";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserPermissionDtoTemplates(authenticationTable), root, destFolderBackend);
			
			destFolderBackend = destPath + "/domain/Authorization/Userrole" ;
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserRoleManagerLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/Userrole" ;
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserRoleApplicationLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/Userrole/Dto";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserRoleDtoTemplates(authenticationTable), root, destFolderBackend);
		}
		else if(authenticationType!="none" && authenticationTable != null)
		{
			destFolderBackend = destPath + "/domain/Authorization/"+ authenticationTable +"permission";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserPermissionManagerLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/"+ authenticationTable +"permission";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserPermissionApplicationLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/"+ authenticationTable +"permission/Dto";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserPermissionDtoTemplates(authenticationTable), root, destFolderBackend);
			
			destFolderBackend = destPath + "/domain/Authorization/"+ authenticationTable +"role";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserRoleManagerLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/"+ authenticationTable +"role";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserRoleApplicationLayerTemplates(authenticationTable), root, destFolderBackend);

			destFolderBackend = destPath + "/application/Authorization/"+ authenticationTable +"role/Dto";
			new File(destFolderBackend).mkdirs();
			generateFiles(getUserRoleDtoTemplates(authenticationTable), root, destFolderBackend);
		}


		destFolderBackend = destPath;
		new File(destFolderBackend).mkdirs();
		generateFiles(getSecurityConfigurationTemplates(authenticationType), root, destFolderBackend);

		destFolderBackend = destPath + "/security";
		new File(destFolderBackend).mkdirs();
		generateFiles(getSecurityModuleTemplates(authenticationType), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Permission";
		new File(destFolderBackend).mkdirs();
		generateFiles(getPermissionApplicationLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/Authorization/Permission";
		new File(destFolderBackend).mkdirs();
		generateFiles(getPermissionManagerLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Permission/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getPermissionDtoTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Rolepermission";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRolePermissionApplicationLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/Authorization/Rolepermission";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRolePermissionManagerLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Rolepermission/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRolePermissionDtoTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Role";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRoleApplicationLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/Authorization/Role";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRoleManagerLayerTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/application/Authorization/Role/Dto";
		new File(destFolderBackend).mkdirs();
		generateFiles(getRoleDtoTemplates(), root, destFolderBackend);

		destFolderBackend = destPath + "/domain/IRepository";
		new File(destFolderBackend).mkdirs();
		generateFiles(getAuthenticationRepositoriesTemplates(authenticationType,authenticationTable), root, destFolderBackend);

		destFolderBackend = destPath + "/RestControllers";
		new File(destFolderBackend).mkdirs();
		generateFiles(getAuthenticationControllerTemplates(authenticationType,authenticationTable), root, destFolderBackend);

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

	private static Map<String, Object> getUserPermissionApplicationLayerTemplates(String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(authenticationTable!=null)
		{
			backEndTemplate.put("userPermission/IUserpermissionAppService.java.ftl", "I"+authenticationTable+"permissionAppService.java");
			backEndTemplate.put("userPermission/UserpermissionAppService.java.ftl", authenticationTable+"permissionAppService.java");
			backEndTemplate.put("userPermission/UserpermissionMapper.java.ftl", authenticationTable+"permissionMapper.java");
			backEndTemplate.put("userPermission/UserpermissionAppServiceTest.java.ftl", authenticationTable+"permissionAppServiceTest.java");
		}
		else
		{
			backEndTemplate.put("userPermission/IUserpermissionAppService.java.ftl", "IUserpermissionAppService.java");
			backEndTemplate.put("userPermission/UserpermissionAppService.java.ftl", "UserpermissionAppService.java");
			backEndTemplate.put("userPermission/UserpermissionMapper.java.ftl", "UserpermissionMapper.java");
			backEndTemplate.put("userPermission/UserpermissionAppServiceTest.java.ftl", "UserpermissionAppServiceTest.java");
		}
		return backEndTemplate;
	}

	private static Map<String, Object> getUserPermissionManagerLayerTemplates(String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(authenticationTable!=null)
		{
			backEndTemplate.put("userPermission/IUserpermissionManager.java.ftl", "I"+authenticationTable+"permissionManager.java");
			backEndTemplate.put("userPermission/UserpermissionManager.java.ftl", authenticationTable+"permissionManager.java");
			backEndTemplate.put("userPermission/UserpermissionManagerTest.java.ftl",  authenticationTable+"permissionManagerTest.java");
		}
		else
		{
			backEndTemplate.put("userPermission/IUserpermissionManager.java.ftl", "IUserpermissionManager.java");
			backEndTemplate.put("userPermission/UserpermissionManager.java.ftl", "UserpermissionManager.java");
			backEndTemplate.put("userPermission/UserpermissionManagerTest.java.ftl", "UserpermissionManagerTest.java");
		}
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

		backEndTemplate.put("permissions/ipermissionsManager.java.ftl", "IPermissionManager.java");
		backEndTemplate.put("permissions/permissionsManager.java.ftl", "PermissionManager.java");
		backEndTemplate.put("permissions/permissionsManagerTest.java.ftl", "PermissionManagerTest.java");

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

		backEndTemplate.put("roles/irolesManager.java.ftl", "IRoleManager.java");
		backEndTemplate.put("roles/rolesManager.java.ftl", "RoleManager.java");
		backEndTemplate.put("roles/rolesManagerTest.java.ftl", "RoleManagerTest.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getRolePermissionApplicationLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("rolePermission/IRolepermissionAppService.java.ftl", "IRolepermissionAppService.java");
		backEndTemplate.put("rolePermission/RolepermissionAppService.java.ftl", "RolepermissionAppService.java");
		backEndTemplate.put("rolePermission/RolepermissionMapper.java.ftl", "RolepermissionMapper.java");
		backEndTemplate.put("rolePermission/RolepermissionAppServiceTest.java.ftl", "RolepermissionAppServiceTest.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getRolePermissionManagerLayerTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("rolePermission/IRolepermissionManager.java.ftl", "IRolepermissionManager.java");
		backEndTemplate.put("rolePermission/RolepermissionManager.java.ftl", "RolepermissionManager.java");
		backEndTemplate.put("rolePermission/RolepermissionManagerTest.java.ftl", "RolepermissionManagerTest.java");

		return backEndTemplate;
	}
	
	private static Map<String, Object> getUserRoleApplicationLayerTemplates(String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(authenticationTable!=null)
		{
			backEndTemplate.put("userRole/IUserroleAppService.java.ftl", "I"+authenticationTable+"roleAppService.java");
			backEndTemplate.put("userRole/UserroleAppService.java.ftl", authenticationTable+"roleAppService.java");
			backEndTemplate.put("userRole/UserroleMapper.java.ftl", authenticationTable+"roleMapper.java");
			backEndTemplate.put("userRole/UserroleAppServiceTest.java.ftl", authenticationTable+"roleAppServiceTest.java");
		}
		else
		{
			backEndTemplate.put("userRole/IUserroleAppService.java.ftl", "IUserroleAppService.java");
			backEndTemplate.put("userRole/UserroleAppService.java.ftl", "UserroleAppService.java");
			backEndTemplate.put("userRole/UserroleMapper.java.ftl", "UserroleMapper.java");
			backEndTemplate.put("userRole/UserroleAppServiceTest.java.ftl", "UserroleAppServiceTest.java");
		}
		return backEndTemplate;
	}

	private static Map<String, Object> getUserRoleManagerLayerTemplates(String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(authenticationTable!=null)
		{
			backEndTemplate.put("userRole/IUserroleManager.java.ftl", "I"+authenticationTable+"roleManager.java");
			backEndTemplate.put("userRole/UserroleManager.java.ftl", authenticationTable+"roleManager.java");
			backEndTemplate.put("userRole/UserroleManagerTest.java.ftl",  authenticationTable+"roleManagerTest.java");
		}
		else
		{
			backEndTemplate.put("userRole/IUserroleManager.java.ftl", "IUserroleManager.java");
			backEndTemplate.put("userRole/UserroleManager.java.ftl", "UserroleManager.java");
			backEndTemplate.put("userRole/UserroleManagerTest.java.ftl", "UserroleManagerTest.java");
		}
		return backEndTemplate;
	}

	
	private static Map<String, Object> getUserRoleDtoTemplates(String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(authenticationTable!=null)
		{
			backEndTemplate.put("userRole/dtos/CreateUserroleInput.java.ftl", "Create"+authenticationTable+"roleInput.java");
			backEndTemplate.put("userRole/dtos/CreateUserroleOutput.java.ftl", "Create"+authenticationTable+"roleOutput.java");
			backEndTemplate.put("userRole/dtos/UpdateUserroleInput.java.ftl", "Update"+authenticationTable+"roleInput.java");
			backEndTemplate.put("userRole/dtos/UpdateUserroleOutput.java.ftl", "Update"+authenticationTable+"roleOutput.java");
			backEndTemplate.put("userRole/dtos/FindUserroleByIdOutput.java.ftl", "Find"+authenticationTable+"roleByIdOutput.java");
			backEndTemplate.put("userRole/dtos/GetRoleOutput.java.ftl", "GetRoleOutput.java");
			backEndTemplate.put("userRole/dtos/GetCustomUserOutput.java.ftl", "Get"+authenticationTable+"Output.java");
		}
		else
		{
			backEndTemplate.put("userRole/dtos/CreateUserroleInput.java.ftl", "CreateUserroleInput.java");
			backEndTemplate.put("userRole/dtos/CreateUserroleOutput.java.ftl", "CreateUserroleOutput.java");
			backEndTemplate.put("userRole/dtos/UpdateUserroleInput.java.ftl", "UpdateUserroleInput.java");
			backEndTemplate.put("userRole/dtos/UpdateUserroleOutput.java.ftl", "UpdateUserroleOutput.java");
			backEndTemplate.put("userRole/dtos/FindUserroleByIdOutput.java.ftl", "FindUserroleByIdOutput.java");
			backEndTemplate.put("userRole/dtos/GetRoleOutput.java.ftl", "GetRoleOutput.java");
			backEndTemplate.put("userRole/dtos/GetUserOutput.java.ftl", "GetUserOutput.java");

		}
		return backEndTemplate;
	}

	private static Map<String, Object> getUserDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("users/dtos/CreateUserInput.java.ftl", "CreateUserInput.java");
		backEndTemplate.put("users/dtos/CreateUserOutput.java.ftl", "CreateUserOutput.java");
		backEndTemplate.put("users/dtos/UpdateUserInput.java.ftl", "UpdateUserInput.java");
		backEndTemplate.put("users/dtos/UpdateUserOutput.java.ftl", "UpdateUserOutput.java");
		backEndTemplate.put("users/dtos/FindUserWithAllFieldsByIdOutput.java.ftl", "FindUserWithAllFieldsByIdOutput.java");
		backEndTemplate.put("users/dtos/FindUserByIdOutput.java.ftl", "FindUserByIdOutput.java");
		backEndTemplate.put("users/dtos/FindUserByNameOutput.java.ftl", "FindUserByNameOutput.java");
		backEndTemplate.put("users/dtos/GetRoleOutput.java.ftl", "GetRoleOutput.java");
		backEndTemplate.put("users/dtos/LoginUserInput.java.ftl", "LoginUserInput.java");
		return backEndTemplate;
	}

	private static Map<String, Object> getUserPermissionDtoTemplates(String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		if(authenticationTable!=null)
		{
			backEndTemplate.put("userPermission/dtos/CreateUserpermissionInput.java.ftl", "Create"+authenticationTable+"permissionInput.java");
			backEndTemplate.put("userPermission/dtos/CreateUserpermissionOutput.java.ftl", "Create"+authenticationTable+"permissionOutput.java");
			backEndTemplate.put("userPermission/dtos/UpdateUserpermissionInput.java.ftl", "Update"+authenticationTable+"permissionInput.java");
			backEndTemplate.put("userPermission/dtos/UpdateUserpermissionOutput.java.ftl", "Update"+authenticationTable+"permissionOutput.java");
			backEndTemplate.put("userPermission/dtos/FindUserpermissionByIdOutput.java.ftl", "Find"+authenticationTable+"permissionByIdOutput.java");
			backEndTemplate.put("userPermission/dtos/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
			backEndTemplate.put("userPermission/dtos/GetCustomUserOutput.java.ftl", "Get"+authenticationTable+"Output.java");
		}
		else
		{
			backEndTemplate.put("userPermission/dtos/CreateUserpermissionInput.java.ftl", "CreateUserpermissionInput.java");
			backEndTemplate.put("userPermission/dtos/CreateUserpermissionOutput.java.ftl", "CreateUserpermissionOutput.java");
			backEndTemplate.put("userPermission/dtos/UpdateUserpermissionInput.java.ftl", "UpdateUserpermissionInput.java");
			backEndTemplate.put("userPermission/dtos/UpdateUserpermissionOutput.java.ftl", "UpdateUserpermissionOutput.java");
			backEndTemplate.put("userPermission/dtos/FindUserpermissionByIdOutput.java.ftl", "FindUserpermissionByIdOutput.java");
			backEndTemplate.put("userPermission/dtos/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
			backEndTemplate.put("userPermission/dtos/GetUserOutput.java.ftl", "GetUserOutput.java");

		}
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

	private static Map<String, Object> getRolePermissionDtoTemplates() {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("rolePermission/dtos/CreateRolepermissionInput.java.ftl", "CreateRolepermissionInput.java");
		backEndTemplate.put("rolePermission/dtos/CreateRolepermissionOutput.java.ftl", "CreateRolepermissionOutput.java");
		backEndTemplate.put("rolePermission/dtos/UpdateRolepermissionInput.java.ftl", "UpdateRolepermissionInput.java");
		backEndTemplate.put("rolePermission/dtos/UpdateRolepermissionOutput.java.ftl", "UpdateRolepermissionOutput.java");
		backEndTemplate.put("rolePermission/dtos/FindRolepermissionByIdOutput.java.ftl", "FindRolepermissionByIdOutput.java");
		backEndTemplate.put("rolePermission/dtos/GetRoleOutput.java.ftl", "GetRoleOutput.java");
		backEndTemplate.put("rolePermission/dtos/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
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
		//	backEndTemplate.put("roles/dtos/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
		return backEndTemplate;
	}


	private static Map<String, Object> getAuthenticationControllerTemplates(String authenticationType,String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType!="none") {
			if(authenticationTable==null)
			{
				backEndTemplate.put("users/userController.java.ftl", "UserController.java");
				backEndTemplate.put("userPermission/UserpermissionController.java.ftl", "UserpermissionController.java");
				backEndTemplate.put("userRole/UserroleController.java.ftl", "UserroleController.java");
			}
			else
			{
				backEndTemplate.put("userRole/UserroleController.java.ftl", authenticationTable+"roleController.java");
				backEndTemplate.put("userPermission/UserpermissionController.java.ftl", authenticationTable+"permissionController.java");
			}

		}

		backEndTemplate.put("LoginController.java.ftl", "LoginController.java");
		backEndTemplate.put("permissions/permissionsController.java.ftl", "PermissionController.java");
		backEndTemplate.put("rolePermission/RolepermissionController.java.ftl", "RolepermissionController.java");
		backEndTemplate.put("roles/rolesController.java.ftl", "RoleController.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getAuthenticationRepositoriesTemplates(String authenticationType,String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType!="none") {

			if(authenticationTable==null)
			{
				backEndTemplate.put("users/iuserRepository.java.ftl", "IUserRepository.java");
				backEndTemplate.put("userPermission/IUserpermissionRepository.java.ftl", "IUserpermissionRepository.java");
				backEndTemplate.put("userRole/IUserroleRepository.java.ftl", "IUserroleRepository.java");
			}
			else
			{
				backEndTemplate.put("userRole/IUserroleRepository.java.ftl", "I"+authenticationTable+"roleRepository.java");
				backEndTemplate.put("userPermission/IUserpermissionRepository.java.ftl", "I"+authenticationTable+"permissionRepository.java");
			}

		}
		
		backEndTemplate.put("IJwtRepository.java.ftl", "IJwtRepository.java");
		backEndTemplate.put("permissions/ipermissionsRepository.java.ftl", "IPermissionRepository.java");
		backEndTemplate.put("roles/irolesRepository.java.ftl", "IRoleRepository.java");
		backEndTemplate.put("rolePermission/IRolepermissionRepository.java.ftl", "IRolepermissionRepository.java");

		return backEndTemplate;
	}

	public static Map<String, Object> getAuthenticationEntitiesTemplates(String authenticationType,String authenticationTable) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType!="none") {
			if(authenticationTable==null)
			{
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/userEntity.java.ftl", "UserEntity.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserpermissionEntity.java.ftl", "UserpermissionEntity.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserpermissionId.java.ftl", "UserpermissionId.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserroleEntity.java.ftl", "UserroleEntity.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserroleId.java.ftl", "UserroleId.java");
			}
			else
			{
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserpermissionEntity.java.ftl", authenticationTable+"permissionEntity.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserpermissionId.java.ftl", authenticationTable+"permissionId.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserroleEntity.java.ftl", authenticationTable+"roleEntity.java");
				backEndTemplate.put("backendTemplates/authenticationTemplates/entities/UserroleId.java.ftl", authenticationTable+"roleId.java");
			}
		}

		backEndTemplate.put("backendTemplates/authenticationTemplates/entities/JwtEntity.java.ftl", "JwtEntity.java");
		backEndTemplate.put("backendTemplates/authenticationTemplates/entities/permissionEntity.java.ftl", "PermissionEntity.java");
		backEndTemplate.put("backendTemplates/authenticationTemplates/entities/roleEntity.java.ftl", "RoleEntity.java");
		backEndTemplate.put("backendTemplates/authenticationTemplates/entities/RolepermissionEntity.java.ftl", "RolepermissionEntity.java");
		backEndTemplate.put("backendTemplates/authenticationTemplates/entities/RolepermissionId.java.ftl", "RolepermissionId.java");

		return backEndTemplate;
	}

	private static Map<String, Object> getSecurityModuleTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType != "none") {
			backEndTemplate.put("security/JWTAuthenticationFilter.java.ftl", "JWTAuthenticationFilter.java");
			backEndTemplate.put("security/JWTAuthorizationFilter.java.ftl", "JWTAuthorizationFilter.java");
			backEndTemplate.put("security/SecurityConstants.java.ftl", "SecurityConstants.java");
			backEndTemplate.put("security/ConvertToPrivilegeAuthorities.java.ftl", "ConvertToPrivilegeAuthorities.java");
		}

		return backEndTemplate;
	}

	private static Map<String, Object> getSecurityConfigurationTemplates(String authenticationType) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		if(authenticationType != "none") {
			backEndTemplate.put("UserDetailsServiceImpl.java.ftl", "UserDetailsServiceImpl.java");
			backEndTemplate.put("SecurityConfig.java.ftl", "SecurityConfig.java");
		}


		return backEndTemplate;
	}
	
	private static void generateFlowableFiles(String destPath, String appName) {
		String authorizationPath = CodeGenerator.TEMPLATE_FOLDER + "/frontendAuthorization/";
		Map<String, Object> templates = new HashMap<>();
		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, authorizationPath);
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);
		
		templates.put("cookie.service.ts.ftl", "cookie.service.ts");
		generateFiles(templates, null, destPath + "/core/");
	}
	
	private static void generateFrontendAuthorization(String destPath, String appName, String authenticationType, String authenticationTable, Map<String, Object> root, Boolean flowable) {

		String appFolderPath = destPath + "/" + appName.substring(appName.lastIndexOf(".") + 1) + "Client/src/app/";
		List<String> authorizationEntities = new ArrayList<String>();
		String authorizationPath = CodeGenerator.TEMPLATE_FOLDER + "/frontendAuthorization/";

		authorizationEntities.add("role");
		authorizationEntities.add("permission");
		authorizationEntities.add("rolepermission");
		
		List<String> entityList = new ArrayList<String>();
		entityList.add("Role");
		entityList.add("Permission");
		entityList.add("Rolepermission");
		
		if(authenticationTable == null) {
			authorizationEntities.add("user");
			entityList.add("User");
			entityList.add("Userpermission");
		} else {
			entityList.add(authenticationTable + "permission");
		}
		authorizationEntities.add("userpermission");

		CodeGenerator.updateAppModule(destPath, appName.substring(appName.lastIndexOf(".") + 1), entityList);
		CodeGenerator.updateAppRouting(destPath, appName.substring(appName.lastIndexOf(".") + 1), entityList, authenticationType, flowable);

		authorizationEntities.add("login");
		authorizationEntities.add("core");
		authorizationEntities.add("oauth");
		
		for(String entity: authorizationEntities) {
			if(entity == "userpermission" && authenticationTable != null) {
				generateFrontendAuthorizationComponents(appFolderPath + convertCamelCaseToDash(authenticationTable) + "permission", authorizationPath + entity, authenticationType, authenticationTable, root);
			}
			else {
				generateFrontendAuthorizationComponents(appFolderPath + entity, authorizationPath + entity, authenticationType, authenticationTable, root);
			}
			
		}
		
		if(flowable) {
			generateFlowableFiles(appFolderPath, appName);
		}

	}
	
	private static void generateFrontendAuthorizationComponents(String destination, String templatePath, String authenticationType, String authenticationTable, Map<String,Object> root) {
		List<String> fl = FolderContentReader.getFilesFromFolder(templatePath);
		Map<String, Object> templates = new HashMap<>();

		ClassTemplateLoader ctl = new ClassTemplateLoader(CodegenApplication.class, templatePath + "/");
		TemplateLoader[] templateLoadersArray = new TemplateLoader[] { ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(templateLoadersArray);
		cfg.setDefaultEncoding("UTF-8");
		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX);
		cfg.setTemplateLoader(mtl);

		for (String filePath : fl) {
			String p = filePath.replace("BOOT-INF/classes" + templatePath,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + templatePath,"");
			String outputFileName = p.substring(0, p.lastIndexOf('.'));
			if(outputFileName.contains("userpermission") && authenticationTable != null) {
				outputFileName = outputFileName.replace("user", convertCamelCaseToDash(authenticationTable));
			}
			templates.put(p, outputFileName);
		}
		
		if(authenticationTable != null) {
			root.put("moduleName", convertCamelCaseToDash(authenticationTable));
		}
		else {
			root.put("moduleName", "user");
		}

		generateFiles(templates, root, destination);
	}
	
	private static void generateAppStartupRunner(Map<String, EntityDetails> details, String backEndRootFolder,Boolean email, Boolean scheduler,Map<String, Object> root){
		
		Map<String, Object> entitiesMap = new HashMap<String,Object>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{

			Map<String, String> entityMap = new HashMap<String,String>();
			String key = entry.getKey();
			String name = key.substring(key.lastIndexOf(".") + 1);
            
			
			entityMap.put("entity" , name + "Entity");
			entityMap.put("requestMapping" , "/" + name.toLowerCase());
			entityMap.put("method" , "get" + name + "Changes");
			entitiesMap.put(name, entityMap);

		}
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, BACKEND_TEMPLATE_FOLDER + "/");// "/templates/backendTemplates/"); 
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 }); 

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX); 
		cfg.setDefaultEncoding("UTF-8"); 
		cfg.setTemplateLoader(mtl); 

		root.put("entitiesMap", entitiesMap);
		root.put("email", email);
		root.put("scheduler", scheduler);
		
		Map<String, Object> template = new HashMap<>();
		template.put("AppStartupRunner.java.ftl", "AppStartupRunner.java");

		new File(backEndRootFolder).mkdirs();
		generateFiles(template, root, backEndRootFolder);
	}

	private static String convertCamelCaseToDash(String str) {
		String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(str);
		splittedNames[0] = StringUtils.lowerCase(splittedNames[0]);
		for (int i = 0; i < splittedNames.length; i++) {
			splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
		}
		return StringUtils.join(splittedNames, "-");
	}
}
