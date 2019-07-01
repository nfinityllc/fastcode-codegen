package [=PackageName].application.Authorization.Users;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Authorization.Users.Dto.*;

import javax.validation.constraints.Positive;

import java.util.List;

@Service
public interface IUserAppService {

    CreateUserOutput Create(CreateUserInput users);

    void Delete(@Positive(message ="Id should be a positive value")Long id);

    UpdateUserOutput Update(@Positive(message ="Id should be a positive value") Long id,UpdateUserInput users);

    FindUserByIdOutput FindById(@Positive(message ="Id should be a positive value")Long id);
    
    List<FindUserByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;
	
   //Roles
    GetRoleOutput GetRoles(@Positive(message ="usersId should be a positive value") Long usersid);
  
    // Operations With Permissions
    Boolean AddPermissions(@Positive(message ="usersId should be a positive value") Long usersid, @Positive(message ="PermissionsId should be a positive value") Long permissionsid);

    void RemovePermissions(@Positive(message ="usersId should be a positive value") Long usersid, @Positive(message ="PermissionsId should be a positive value") Long permissionsid);

    GetPermissionOutput GetPermissions(@Positive(message ="usersId should be a positive value") Long usersid, @Positive(message ="PermissionsId should be a positive value") Long permissionsid);

    List<GetPermissionOutput> GetPermissionsList(@Positive(message ="usersId should be a positive value") Long usersid,SearchCriteria search,String operator,Pageable pageable) throws Exception;
  
}
