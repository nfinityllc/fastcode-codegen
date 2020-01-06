package [=PackageName].domain.authorization.role;

import [=PackageName].domain.model.RoleEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import [=CommonModulePackage].search.SearchFields;

import javax.validation.constraints.Positive;

public interface IRoleManager {

    // CRUD Operations
    RoleEntity Create(RoleEntity role);

    void Delete(RoleEntity role);

    RoleEntity Update(RoleEntity role);

    RoleEntity FindById(@Positive(message ="Id should be a positive value") Long roleId);

    //Internal operation
    RoleEntity FindByRoleName(String roleName);
    
    Page<RoleEntity> FindAll(Predicate predicate, Pageable pageable);

}

