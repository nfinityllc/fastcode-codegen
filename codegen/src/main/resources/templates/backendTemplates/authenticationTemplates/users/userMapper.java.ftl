package [=PackageName].application.Authorization.User;

import [=PackageName].application.Authorization.User.Dto.*;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.UserEntity;

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

    UserEntity CreateUserInputToUserEntity(CreateUserInput userDto);
    
    @Mappings({ 
    @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
     CreateUserOutput UserEntityToCreateUserOutput(UserEntity entity);

    UserEntity UpdateUserInputToUserEntity(UpdateUserInput userDto);

    @Mappings({ 
    @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    UpdateUserOutput UserEntityToUpdateUserOutput(UserEntity entity);

    @Mappings({ 
    @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    FindUserByIdOutput UserEntityToFindUserByIdOutput(UserEntity entity);
    
    @Mappings({ 
    @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
    @Mapping(source = "role.id", target = "roleId"),                   
    }) 
    FindUserByNameOutput UserEntityToFindUserByNameOutput(UserEntity entity);

    @Mappings({
            @Mapping(source = "role.id", target = "id"),
              <#if Audit!false>
            @Mapping(source = "role.creationTime", target = "creationTime"),
            @Mapping(source = "role.creatorUserId", target = "creatorUserId"),
            @Mapping(source = "role.lastModifierUserId", target = "lastModifierUserId"),
            @Mapping(source = "role.lastModificationTime", target = "lastModificationTime"),
              </#if>
            @Mapping(source = "user.id", target = "userId"),
            @Mapping(source = "user.userName", target = "userDescriptiveField")
    })
    GetRoleOutput RoleEntityToGetRoleOutput(RoleEntity role, UserEntity user);
}