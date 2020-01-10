package [=PackageName].application.authorization.role;

import [=PackageName].application.authorization.role.dto.*;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.model.RoleEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface RoleMapper {

    RoleEntity CreateRoleInputToRoleEntity(CreateRoleInput roleDto);

    CreateRoleOutput RoleEntityToCreateRoleOutput(RoleEntity entity);

    RoleEntity UpdateRoleInputToRoleEntity(UpdateRoleInput roleDto);

    UpdateRoleOutput RoleEntityToUpdateRoleOutput(RoleEntity entity);

    FindRoleByIdOutput RoleEntityToFindRoleByIdOutput(RoleEntity entity);
    
    FindRoleByNameOutput RoleEntityToFindRoleByNameOutput(RoleEntity entity);

}
