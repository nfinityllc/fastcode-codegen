package [=PackageName].application.Authorization.Rolepermission;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import [=PackageName].domain.model.PermissionEntity;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].application.Authorization.Rolepermission.Dto.*;
import [=PackageName].domain.model.RolepermissionEntity;


@Mapper(componentModel = "spring")
public interface RolepermissionMapper {

    RolepermissionEntity CreateRolepermissionInputToRolepermissionEntity(CreateRolepermissionInput rolepermissionDto);
   
   @Mappings({ 
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId"),                   
   @Mapping(source = "role.displayName", target = "roleDisplayName"),                   
   @Mapping(source = "role.id", target = "roleId"),                   
   }) 
   CreateRolepermissionOutput RolepermissionEntityToCreateRolepermissionOutput(RolepermissionEntity entity);

    RolepermissionEntity UpdateRolepermissionInputToRolepermissionEntity(UpdateRolepermissionInput rolepermissionDto);

   @Mappings({ 
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId"),                   
   @Mapping(source = "role.displayName", target = "roleDisplayName"),                   
   @Mapping(source = "role.id", target = "roleId"),                   
   }) 
   UpdateRolepermissionOutput RolepermissionEntityToUpdateRolepermissionOutput(RolepermissionEntity entity);

   @Mappings({ 
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId"),                   
   @Mapping(source = "role.displayName", target = "roleDisplayName"),                   
   @Mapping(source = "role.id", target = "roleId"),                   
   }) 
   FindRolepermissionByIdOutput RolepermissionEntityToFindRolepermissionByIdOutput(RolepermissionEntity entity);


   @Mappings({
   @Mapping(source = "rolepermission.permissionId", target = "rolepermissionPermissionId"),
   @Mapping(source = "rolepermission.roleId", target = "rolepermissionRoleId"),
   })
   GetPermissionOutput PermissionEntityToGetPermissionOutput(PermissionEntity permission, RolepermissionEntity rolepermission);
 

   @Mappings({
   @Mapping(source = "rolepermission.permissionId", target = "rolepermissionPermissionId"),
   @Mapping(source = "rolepermission.roleId", target = "rolepermissionRoleId"),
   })
   GetRoleOutput RoleEntityToGetRoleOutput(RoleEntity role, RolepermissionEntity rolepermission);
 

}
