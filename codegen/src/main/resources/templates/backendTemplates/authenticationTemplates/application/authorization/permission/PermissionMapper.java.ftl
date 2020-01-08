package [=PackageName].application.authorization.permission;

import [=PackageName].application.authorization.permission.dto.*;
import [=PackageName].domain.model.PermissionEntity;

import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
     PermissionEntity CreatePermissionInputToPermissionEntity(CreatePermissionInput permissionDto);
   
     CreatePermissionOutput PermissionEntityToCreatePermissionOutput(PermissionEntity entity);

     PermissionEntity UpdatePermissionInputToPermissionEntity(UpdatePermissionInput permissionDto);

     UpdatePermissionOutput PermissionEntityToUpdatePermissionOutput(PermissionEntity entity);

     FindPermissionByIdOutput PermissionEntityToFindPermissionByIdOutput(PermissionEntity entity);

     FindPermissionByNameOutput PermissionEntityToFindPermissionByNameOutput(PermissionEntity entity);
   
}