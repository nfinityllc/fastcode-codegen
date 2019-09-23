package [=PackageName];

import [=PackageName].domain.model.*;
import [=PackageName].domain.Authorization.Permission.IPermissionManager;
import [=PackageName].domain.Authorization.Rolepermission.IRolepermissionManager;
import [=PackageName].domain.Authorization.Role.IRoleManager;
<#if !authenticationTable??>
import [=PackageName].domain.Authorization.User.UserManager;
<#else>
import [=PackageName].domain.Authorization.[=authenticationTable].I[=authenticationTable]Manager;
</#if>
<#list entitiesMap as entityKey, entityMap>
<#if !authenticationTable?? || entityKey != authenticationTable>
import [=PackageName].domain.[=entityKey].I[=entityKey]Manager;
</#if>
</#list>
import [=PackageName].CommonModule.logging.LoggingHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
@Profile("bootstrap")
public class AppStartupRunner implements ApplicationRunner {

    @Autowired
    private IPermissionManager permissionManager;

    @Autowired
    private IRoleManager rolesManager;
    
	<#if !authenticationTable??>
    @Autowired
    private IUserManager userManager;
	
	</#if>
	@Autowired
    private IRolepermissionManager rolepermissionManager;
    
    <#list entitiesMap as entityKey, entityMap>
	@Autowired
	private I[=entityKey]Manager [=entityKey?uncap_first]Manager;
	
	</#list>
    @Autowired
    private LoggingHelper loggingHelper;

    @Autowired
    private PasswordEncoder pEncoder;

    @Autowired
    private Environment env;
    
    
    @Override
    public void run(ApplicationArguments args) {

        System.out.println("*****************Creating Default Users/Roles/Permissions *************************");

        // Create permissions for default entities

        loggingHelper.getLogger().info("Creating the data in the database");

        // Create roles

        RoleEntity role = new RoleEntity();
        role.setName("ROLE_Admin");
        role = rolesManager.Create(role);
        
		List<String> entityList = new ArrayList<String>();
        entityList.add("role");
        entityList.add("permission");
        entityList.add("rolepermission");
        
        <#if !authenticationTable??>
		entityList.add("user");
		entityList.add("userpermission");
		<#else>
		entityList.add("[=authenticationTable?lower_case]permission");
        </#if>

        <#list entitiesMap as entityKey, entityMap>
		entityList.add("[=entityKey?lower_case]");
		</#list>
		
		for(String entity: entityList) {
        	addEntityPermissions(entity, role.getId());
        }
        loggingHelper.getLogger().info("Completed creating the data in the database");

    }
    
    private void addEntityPermissions(String entity, long roleId) {
    	PermissionEntity pe1 = new PermissionEntity();
        PermissionEntity pe2 = new PermissionEntity();
        PermissionEntity pe3 = new PermissionEntity();
        PermissionEntity pe4 = new PermissionEntity();

        pe1.setName(entity.toUpperCase() + "ENTITY_CREATE");
        pe2.setName(entity.toUpperCase() + "ENTITY_READ");
        pe3.setName(entity.toUpperCase() + "ENTITY_DELETE");
        pe4.setName(entity.toUpperCase() + "ENTITY_UPDATE");

        pe1 = permissionManager.Create(pe1);
        pe2 = permissionManager.Create(pe2);
        pe3 = permissionManager.Create(pe3);
        pe4 = permissionManager.Create(pe4);
        
        RolepermissionEntity pe1RP = new RolepermissionEntity();
        RolepermissionEntity pe2RP = new RolepermissionEntity();
        RolepermissionEntity pe3RP = new RolepermissionEntity();
        RolepermissionEntity pe4RP = new RolepermissionEntity();
        
        
        pe1RP.setRoleId(roleId);
        pe2RP.setRoleId(roleId);
        pe3RP.setRoleId(roleId);
        pe4RP.setRoleId(roleId);
        
        pe1RP.setPermissionId(pe1.getId());
        pe2RP.setPermissionId(pe2.getId());
        pe3RP.setPermissionId(pe3.getId());
        pe4RP.setPermissionId(pe4.getId());
        
        rolepermissionManager.Create(pe1RP);
        rolepermissionManager.Create(pe2RP);
        rolepermissionManager.Create(pe3RP);
        rolepermissionManager.Create(pe4RP);
    }

}
