package [=PackageName].domain.Authorization.User;

import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.UserEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import [=CommonModulePackage].Search.SearchFields;

import java.util.List;

public interface IUserManager {
    // CRUD Operations
    UserEntity Create(UserEntity user);

    void Delete(UserEntity user);

    UserEntity Update(UserEntity user);

    UserEntity FindById(Long id);
    
    UserEntity FindByUserName(String userName);

    Page<UserEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //Role
    public RoleEntity GetRole(Long userId);
  
}


