package [=PackageName].domain.Authorization.Rolepermission;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.model.RolepermissionId;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.model.RoleEntity;

public interface IRolepermissionManager {
    // CRUD Operations
    RolepermissionEntity Create(RolepermissionEntity rolepermission);

    void Delete(RolepermissionEntity rolepermission);

    RolepermissionEntity Update(RolepermissionEntity rolepermission);

    RolepermissionEntity FindById(RolepermissionId rolepermissionId );

    Page<RolepermissionEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //Permission
    public PermissionEntity GetPermission(RolepermissionId rolepermissionId );
  
    //Role
    public RoleEntity GetRole(RolepermissionId rolepermissionId );
  
}
