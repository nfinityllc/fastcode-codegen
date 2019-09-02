package [=PackageName];

import [=PackageName].domain.Authorization.Permission.IPermissionManager;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.Authorization.Permission.PermissionManager;
import [=PackageName].domain.Authorization.Rolepermission.IRolepermissionManager;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.Authorization.Rolepermission.RolepermissionManager;
import [=PackageName].domain.Authorization.Role.IRoleManager;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.Authorization.Role.RoleManager;
<#if authenticationTable == null>
import [=PackageName].domain.Authorization.User.IUserManager;
import [=PackageName].domain.Authorization.User.UserManager;
import [=PackageName].domain.model.UserEntity;
</#if>
import [=PackageName].CommonModule.logging.LoggingHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashSet;


@Component
@Profile("bootstrap")
public class AppStartupRunner implements ApplicationRunner {

    @Autowired
    private IPermissionManager permissionManager;

    @Autowired
    private IRoleManager rolesManager;
    
	<#if authenticationTable == null>
    @Autowired
    private IUserManager userManager;
	
	</#if>
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

        System.out.println("*****************Creating Default Users/Roles/Permissions *************************");

        // Create permissions for default entities

        loggingHelper.getLogger().info("Creating the data in the database");

        PermissionEntity pe1 = new PermissionEntity();
        PermissionEntity pe2 = new PermissionEntity();
        PermissionEntity pe3 = new PermissionEntity();
        PermissionEntity pe4 = new PermissionEntity();

        pe1.setName("ROLESENTITY_CREATE");
        pe2.setName("ROLESENTITY_READ");
        pe3.setName("ROLESENTITY_DELETE");
        pe4.setName("ROLESENTITY_UPDATE");

        pe1 = permissionManager.Create(pe1);
        pe2 = permissionManager.Create(pe2);
        pe3 = permissionManager.Create(pe3);
        pe4 = permissionManager.Create(pe4);

        PermissionEntity pe5 = new PermissionEntity();
        PermissionEntity pe6 = new PermissionEntity();
        PermissionEntity pe7 = new PermissionEntity();
        PermissionEntity pe8 = new PermissionEntity();

        pe5 = permissionManager.Create(pe5);
        pe6 = permissionManager.Create(pe6);
        pe7 = permissionManager.Create(pe7);
        pe8 = permissionManager.Create(pe8);
        
        permissionManager.Create(pe5);
        permissionManager.Create(pe6);
        permissionManager.Create(pe7);
        permissionManager.Create(pe8);


        // Create roles

        RoleEntity re1 = new RoleEntity();
        re1.setName("ROLE_Admin");
        re1 = rolesManager.Create(re1);
        
        // assign permissions to role
        
        RolepermissionEntity pe1RP = new RolepermissionEntity();
        RolepermissionEntity pe2RP = new RolepermissionEntity();
        RolepermissionEntity pe3RP = new RolepermissionEntity();
        RolepermissionEntity pe4RP = new RolepermissionEntity();
        RolepermissionEntity pe5RP = new RolepermissionEntity();
        RolepermissionEntity pe6RP = new RolepermissionEntity();
        RolepermissionEntity pe7RP = new RolepermissionEntity();
        RolepermissionEntity pe8RP = new RolepermissionEntity();
        
        
        pe1RP.setRoleId(re1.getId());
        pe2RP.setRoleId(re1.getId());
        pe3RP.setRoleId(re1.getId());
        pe4RP.setRoleId(re1.getId());
        pe5RP.setRoleId(re1.getId());
        pe6RP.setRoleId(re1.getId());
        pe7RP.setRoleId(re1.getId());
        pe8RP.setRoleId(re1.getId());
        
        pe1RP.setPermissionId(pe1.getId());
        pe2RP.setPermissionId(pe2.getId());
        pe3RP.setPermissionId(pe3.getId());
        pe4RP.setPermissionId(pe4.getId());
        pe5RP.setPermissionId(pe5.getId());
        pe6RP.setPermissionId(pe6.getId());
        pe7RP.setPermissionId(pe7.getId());
        pe8RP.setPermissionId(pe8.getId());
        
        rolepermissionManager.Create(pe1RP);
        rolepermissionManager.Create(pe2RP);
        rolepermissionManager.Create(pe3RP);
        rolepermissionManager.Create(pe4RP);
        rolepermissionManager.Create(pe5RP);
        rolepermissionManager.Create(pe6RP);
        rolepermissionManager.Create(pe7RP);
        rolepermissionManager.Create(pe8RP);

        

        <#if authenticationTable == null>
		// Create users
        UserEntity ue1 = new UserEntity();

        ue1.setEmailAddress("e1@nfinityllc.com");
        ue1.setUserName("admin");
        ue1.setPassword(pEncoder.encode("secret"));
        ue1.setFirstName("Admin");
        ue1.setLastName("Admin");
        ue1.setIsActive(true);
		ue1.setRoleId(re1.getId());
		
        userManager.Create(ue1);
        
        PermissionEntity pe9 = new PermissionEntity();
        PermissionEntity pe10 = new PermissionEntity();
        PermissionEntity pe11 = new PermissionEntity();
        PermissionEntity pe12 = new PermissionEntity();

        pe9.setName("USERSENTITY_CREATE");
        pe10.setName("USERSENTITY_READ");
        pe11.setName("USERSENTITY_DELETE");
        pe12.setName("USERSENTITY_UPDATE");

        pe9 = permissionManager.Create(pe9);
        pe10 = permissionManager.Create(pe10);
        pe11 = permissionManager.Create(pe11);
        pe12 = permissionManager.Create(pe12);
        
        RolepermissionEntity pe9RP = new RolepermissionEntity();
    	RolepermissionEntity pe10RP = new RolepermissionEntity();
    	RolepermissionEntity pe11RP = new RolepermissionEntity();
    	RolepermissionEntity pe12RP = new RolepermissionEntity();
    	
    	pe9RP.setRoleId(re1.getId());
    	pe10RP.setRoleId(re1.getId());
    	pe11RP.setRoleId(re1.getId());
    	pe12RP.setRoleId(re1.getId());
    
    	pe9RP.setPermissionId(pe9.getId());
        pe10RP.setPermissionId(pe10.getId());
        pe11RP.setPermissionId(pe11.getId());
        pe12RP.setPermissionId(pe12.getId());
        
        rolepermissionManager.Create(pe9RP);
    	rolepermissionManager.Create(pe10RP);
    	rolepermissionManager.Create(pe11RP);
    	rolepermissionManager.Create(pe12RP);
        </#if>

        // Add Permissions to Roles
        
        <#list entitiesMap as entityKey, entityMap>
		PermissionEntity [=entityKey]Create = new PermissionEntity();
		PermissionEntity [=entityKey]Read = new PermissionEntity();
		PermissionEntity [=entityKey]Delete = new PermissionEntity();
		PermissionEntity [=entityKey]Update = new PermissionEntity();
		
		[=entityKey]Create.setName("[=entityKey?upper_case]ENTITY_CREATE");
		[=entityKey]Create.setDisplayName("Create [=entityKey]");

		[=entityKey]Read.setName("[=entityKey?upper_case]ENTITY_READ");
		[=entityKey]Read.setDisplayName("Read [=entityKey]");
		
		[=entityKey]Delete.setName("[=entityKey?upper_case]ENTITY_DELETE");
		[=entityKey]Delete.setDisplayName("Delete [=entityKey]");
		
		[=entityKey]Update.setName("[=entityKey?upper_case]ENTITY_UPDATE");
		[=entityKey]Update.setDisplayName("Update [=entityKey]");
		
		[=entityKey]Create = permissionManager.Create([=entityKey]Create);
        [=entityKey]Read = permissionManager.Create([=entityKey]Read);
        [=entityKey]Delete = permissionManager.Create([=entityKey]Delete);
        [=entityKey]Update = permissionManager.Create([=entityKey]Update);
		
		RolepermissionEntity [=entityKey]CreateRP = new RolepermissionEntity();
		RolepermissionEntity [=entityKey]ReadRP = new RolepermissionEntity();
		RolepermissionEntity [=entityKey]DeleteRP = new RolepermissionEntity();
		RolepermissionEntity [=entityKey]UpdateRP = new RolepermissionEntity();
		
		[=entityKey]CreateRP.setRoleId(re1.getId());
		[=entityKey]CreateRP.setPermissionId([=entityKey]Create.getId());
		
		[=entityKey]ReadRP.setRoleId(re1.getId());
		[=entityKey]ReadRP.setPermissionId([=entityKey]Read.getId());
		
		[=entityKey]DeleteRP.setRoleId(re1.getId());
		[=entityKey]DeleteRP.setPermissionId([=entityKey]Delete.getId());
		
		[=entityKey]UpdateRP.setRoleId(re1.getId());
		[=entityKey]UpdateRP.setPermissionId([=entityKey]Update.getId());
		
		rolepermissionManager.Create([=entityKey]CreateRP);
        rolepermissionManager.Create([=entityKey]ReadRP);
        rolepermissionManager.Create([=entityKey]DeleteRP);
        rolepermissionManager.Create([=entityKey]UpdateRP);
		
		</#list>

        loggingHelper.getLogger().info("Completed creating the data in the database");

    }

}
