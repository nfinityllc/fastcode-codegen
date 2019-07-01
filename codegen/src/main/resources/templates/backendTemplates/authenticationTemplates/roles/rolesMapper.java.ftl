package [=PackageName].application.Authorization.Roles;

import [=PackageName].application.Authorization.Roles.Dto.*;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

@Mapper(componentModel = "spring")
public interface RoleMapper {

    RolesEntity CreateRoleInputToRolesEntity(CreateRoleInput roleDto);

    CreateRoleOutput RolesEntityToCreateRoleOutput(RolesEntity entity);

    RolesEntity UpdateRoleInputToRolesEntity(UpdateRoleInput roleDto);

    UpdateRoleOutput RolesEntityToUpdateRoleOutput(RolesEntity entity);

    FindRoleByIdOutput RolesEntityToFindRoleByIdOutput(RolesEntity entity);
    
    FindRoleByNameOutput RolesEntityToFindRoleByNameOutput(RolesEntity entity);

    @Mappings({
            @Mapping(source = "permission.id", target = "id"),
            @Mapping(source = "permission.displayName", target = "displayName"),
            @Mapping(source = "permission.name", target = "name"),
              <#if Audit!false>
            @Mapping(source = "permission.creationTime", target = "creationTime"),
            @Mapping(source = "permission.creatorUserId", target = "creatorUserId"),
            @Mapping(source = "permission.lastModifierUserId", target = "lastModifierUserId"),
            @Mapping(source = "permission.lastModificationTime", target = "lastModificationTime"),
           </#if>
            @Mapping(source = "role.id", target = "roleId"),
            @Mapping(source = "role.name", target = "roleName")
    })
    GetPermissionOutput PermissionsEntityToGetPermissionOutput(PermissionsEntity permission, RolesEntity role);
}
