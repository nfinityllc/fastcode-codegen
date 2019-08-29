package [=PackageName].domain.Authorization.[=AuthenticationTable]permission;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.model.PermissionEntity;

public interface I[=AuthenticationTable]permissionManager {
    // CRUD Operations
    [=AuthenticationTable]permissionEntity Create([=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);

    void Delete([=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);

    [=AuthenticationTable]permissionEntity Update([=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);

    [=AuthenticationTable]permissionEntity FindById([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );

    Page<[=AuthenticationTable]permissionEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //[=AuthenticationTable]
    public [=AuthenticationTable]Entity Get[=AuthenticationTable]([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );
  
    //Permission
    public PermissionEntity GetPermission([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );
  
}
