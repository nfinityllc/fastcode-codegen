package [=PackageName].application.Authorization.Permissions;

import [=PackageName].application.Authorization.Permissions.Dto.*;
import [=PackageName].domain.model.PermissionsEntity;

import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
    PermissionsEntity CreatePermissionInputToPermissionsEntity(CreatePermissionInput permissionDto);

    CreatePermissionOutput PermissionsEntityToCreatePermissionOutput(PermissionsEntity entity);

    PermissionsEntity UpdatePermissionInputToPermissionsEntity(UpdatePermissionInput permissionDto);

    UpdatePermissionOutput PermissionsEntityToUpdatePermissionOutput(PermissionsEntity entity);

    FindPermissionByIdOutput PermissionsEntityToFindPermissionByIdOutput(PermissionsEntity entity);

    FindPermissionByNameOutput PermissionsEntityToFindPermissionByNameOutput(PermissionsEntity entity);
   
}