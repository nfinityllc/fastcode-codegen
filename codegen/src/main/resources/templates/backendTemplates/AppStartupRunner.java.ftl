package [=PackageName];

import [=PackageName].domain.model.*;
import [=PackageName].domain.Authorization.Permission.IPermissionManager;
import [=PackageName].domain.Authorization.Rolepermission.IRolepermissionManager;
import [=PackageName].domain.Authorization.Role.IRoleManager;
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
<#if Flowable!false>
import com.nfinity.fastcode.application.Flowable.ActIdUserMapper;
import com.nfinity.fastcode.application.Flowable.FlowableIdentityService;
import com.nfinity.fastcode.domain.Flowable.Users.ActIdUserEntity;
</#if>

@Component
@Profile("bootstrap")
public class AppStartupRunner implements ApplicationRunner {
<#if Flowable!false>
    @Autowired
    private FlowableIdentityService idmIdentityService;

    @Autowired
    private ActIdUserMapper actIdUserMapper;
</#if>
    @Autowired
    private IPermissionManager permissionManager;

    @Autowired
    private IRoleManager rolesManager;
    
	@Autowired
    private IRolepermissionManager rolepermissionManager;
    
    @Autowired
    private LoggingHelper loggingHelper;

    @Autowired
    private PasswordEncoder pEncoder;

    @Autowired
    private Environment env;
    
    
    @Override
    public void run(ApplicationArguments args) {

<#if Flowable!false>
        idmIdentityService.deleteAllUsersGroupsPrivileges();
</#if>
        System.out.println("*****************Creating Default Users/Roles/Permissions *************************");

        // Create permissions for default entities

        loggingHelper.getLogger().info("Creating the data in the database");

        // Create roles

        RoleEntity role = new RoleEntity();
        role.setName("ROLE_Admin");
        role = rolesManager.Create(role);
        <#if Flowable!false>
        idmIdentityService.createGroup("ROLE_Admin");
        </#if>
        
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
    <#if Flowable!false>
        PermissionEntity pe5 = new PermissionEntity();
        pe5.setName("access-idm");
        pe5 = permissionManager.Create(pe5);
        PermissionEntity pe6 = new PermissionEntity();
        pe6.setName("access-admin");
        pe6 = permissionManager.Create(pe6);
        PermissionEntity pe7 = new PermissionEntity();
        pe7.setName("access-modeler");
        pe7 = permissionManager.Create(pe7);
        PermissionEntity pe8 = new PermissionEntity();
        pe8.setName("access-task");
        pe8 = permissionManager.Create(pe8);
        PermissionEntity pe9 = new PermissionEntity();
        pe9.setName("access-rest-api");
        pe9 = permissionManager.Create(pe9);

        idmIdentityService.createPrivilege("access-idm");
        idmIdentityService.createPrivilege("access-admin");
        idmIdentityService.createPrivilege("access-modeler");
        idmIdentityService.createPrivilege("access-task");
        idmIdentityService.createPrivilege("access-rest-api");
    </#if>
        
        RolepermissionEntity pe1RP = new RolepermissionEntity();
        RolepermissionEntity pe2RP = new RolepermissionEntity();
        RolepermissionEntity pe3RP = new RolepermissionEntity();
        RolepermissionEntity pe4RP = new RolepermissionEntity();
        <#if Flowable!false>
        RolepermissionEntity pe5RP = new RolepermissionEntity();
        RolepermissionEntity pe6RP = new RolepermissionEntity();
        RolepermissionEntity pe7RP = new RolepermissionEntity();
        RolepermissionEntity pe8RP = new RolepermissionEntity();
        RolepermissionEntity pe9RP = new RolepermissionEntity();
        </#if>
        
        pe1RP.setRoleId(roleId);
        pe2RP.setRoleId(roleId);
        pe3RP.setRoleId(roleId);
        pe4RP.setRoleId(roleId);
        <#if Flowable!false>
        pe5RP.setRoleId(roleId);
        pe6RP.setRoleId(roleId);
        pe7RP.setRoleId(roleId);
        pe8RP.setRoleId(roleId);
        pe9RP.setRoleId(roleId);
        </#if>
        
        pe1RP.setPermissionId(pe1.getId());
        pe2RP.setPermissionId(pe2.getId());
        pe3RP.setPermissionId(pe3.getId());
        pe4RP.setPermissionId(pe4.getId());
        <#if Flowable!false>
        pe5RP.setPermissionId(pe5.getId());
        pe6RP.setPermissionId(pe6.getId());
        pe7RP.setPermissionId(pe7.getId());
        pe8RP.setPermissionId(pe8.getId());
        pe9RP.setPermissionId(pe9.getId());
        </#if>
        
        rolepermissionManager.Create(pe1RP);
        rolepermissionManager.Create(pe2RP);
        rolepermissionManager.Create(pe3RP);
        rolepermissionManager.Create(pe4RP);
        <#if Flowable!false>
        rolepermissionManager.Create(pe5RP);
        rolepermissionManager.Create(pe6RP);
        rolepermissionManager.Create(pe7RP);
        rolepermissionManager.Create(pe8RP);
        rolepermissionManager.Create(pe9RP);

        idmIdentityService.addGroupPrivilegeMapping("ROLE_Admin", pe5.getName());
        idmIdentityService.addGroupPrivilegeMapping("ROLE_Admin", pe6.getName());
        idmIdentityService.addGroupPrivilegeMapping("ROLE_Admin", pe7.getName());
        idmIdentityService.addGroupPrivilegeMapping("ROLE_Admin", pe8.getName());
        idmIdentityService.addGroupPrivilegeMapping("ROLE_Admin", pe9.getName());
        </#if>
    }
}
