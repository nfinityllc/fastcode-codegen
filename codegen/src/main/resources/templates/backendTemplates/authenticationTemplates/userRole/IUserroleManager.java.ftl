package [=PackageName].domain.Authorization.[=AuthenticationTable]role;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.model.RoleEntity;

public interface I[=AuthenticationTable]roleManager {
    // CRUD Operations
    [=AuthenticationTable]roleEntity Create([=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role);

    void Delete([=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role);

    [=AuthenticationTable]roleEntity Update([=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role);

    [=AuthenticationTable]roleEntity FindById([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);
	
    Page<[=AuthenticationTable]roleEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //[=AuthenticationTable]
    public [=AuthenticationTable]Entity Get[=AuthenticationTable]([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);
   
    //Role
    public RoleEntity GetRole([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);
}
