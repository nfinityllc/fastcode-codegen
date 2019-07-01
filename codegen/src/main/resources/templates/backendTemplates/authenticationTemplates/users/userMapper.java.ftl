package [=PackageName].application.Authorization.Users;

import [=PackageName].application.Authorization.Users.Dto.*;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.model.UsersEntity;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

@Mapper(componentModel = "spring")
public interface UserMapper {

    /*
    CreateUserInput => User
    User => CreateUserOutput
    UpdateUserInput => User
    User => UpdateUserOutput
    User => FindUserByIdOutput
    Permission => GetPermissionOutput
    Role => GetRoleOutput
     */

    UsersEntity CreateUserInputToUsersEntity(CreateUserInput userDto);
    
    @Mappings({ 
    @Mapping(source = "role.name", target = "roleName"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    CreateUserOutput UsersEntityToCreateUserOutput(UsersEntity entity);

    UsersEntity UpdateUserInputToUsersEntity(UpdateUserInput userDto);

    @Mappings({ 
    @Mapping(source = "role.name", target = "roleName"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    UpdateUserOutput UsersEntityToUpdateUserOutput(UsersEntity entity);

    @Mappings({ 
    @Mapping(source = "role.name", target = "roleName"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    FindUserByIdOutput UsersEntityToFindUserByIdOutput(UsersEntity entity);
    
    @Mappings({ 
    @Mapping(source = "role.name", target = "roleName"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    FindUserByNameOutput UsersEntityToFindUserByNameOutput(UsersEntity entity);

    @Mappings({
            @Mapping(source = "permission.id", target = "id"),
              <#if Audit!false>
            @Mapping(source = "permission.creationTime", target = "creationTime"),
            @Mapping(source = "permission.creatorUserId", target = "creatorUserId"),
            @Mapping(source = "permission.lastModifierUserId", target = "lastModifierUserId"),
            @Mapping(source = "permission.lastModificationTime", target = "lastModificationTime"),
            </#if>
            @Mapping(source = "user.id", target = "userId"),
            @Mapping(source = "user.userName", target = "userName")
    })
    GetPermissionOutput PermissionsEntityToGetPermissionOutput(PermissionsEntity permission, UsersEntity user);

    @Mappings({
            @Mapping(source = "role.id", target = "id"),
              <#if Audit!false>
            @Mapping(source = "role.creationTime", target = "creationTime"),
            @Mapping(source = "role.creatorUserId", target = "creatorUserId"),
            @Mapping(source = "role.lastModifierUserId", target = "lastModifierUserId"),
            @Mapping(source = "role.lastModificationTime", target = "lastModificationTime"),
              </#if>
            @Mapping(source = "user.id", target = "userId"),
            @Mapping(source = "user.userName", target = "userName")
    })
    GetRoleOutput RolesEntityToGetRoleOutput(RolesEntity role, UsersEntity user);
}