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
   
    CreateUserOutput UserEntityToCreateUserOutput(UserEntity entity);

    UserEntity UpdateUserInputToUserEntity(UpdateUserInput userDto);

    UpdateUserOutput UserEntityToUpdateUserOutput(UserEntity entity);

    FindUserByIdOutput UserEntityToFindUserByIdOutput(UserEntity entity);
     
    FindUserByNameOutput UserEntityToFindUserByNameOutput(UserEntity entity);

    FindUserWithAllFieldsByIdOutput UserEntityToFindUserWithAllFieldsByIdOutput(UserEntity entity);
  
}