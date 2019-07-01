package [=PackageName].domain.Authorization.Users;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.model.UsersEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import [=CommonModulePackage].Search.SearchFields;

import java.util.List;

import javax.validation.constraints.Positive;


public interface IUserManager {

    // CRUD Operations
    public UsersEntity Create(UsersEntity user);

    public void Delete(UsersEntity user);

    public UsersEntity Update(UsersEntity user);

    public UsersEntity FindById(@Positive(message ="Id should be a positive value") Long userId);

    public Page<UsersEntity> FindAll(Predicate predicate, Pageable pageable);

    // Extra methods for internal use only - not exposed as ReST API methods
    public UsersEntity FindByUserName(String userName);
 //Roles
   public RolesEntity GetRoles(@Positive(message ="usersId should be a positive value") Long usersId);
  
  
    //Permissions
    public Boolean AddPermissions(UsersEntity users, PermissionsEntity permissions);

    public void RemovePermissions(UsersEntity users, PermissionsEntity permissions);

    public PermissionsEntity GetPermissions(@Positive(message ="usersId should be a positive value") Long usersId,@Positive(message ="PermissionsId should be a positive value") Long permissionsId);

    public Page<PermissionsEntity> FindPermissions(@Positive(message ="usersId should be a positive value") Long usersId,List<SearchFields> fields,String operator,Pageable pageable);
 
  }


