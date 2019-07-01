package [=PackageName].domain.Authorization.Permissions;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import [=PackageName].domain.model.PermissionsEntity;



public interface IPermissionsManager {
    // CRUD Operations
    PermissionsEntity Create(PermissionsEntity user);

    void Delete(PermissionsEntity user);

    PermissionsEntity Update(PermissionsEntity user);

    PermissionsEntity FindById(Long permissionId);

    Page<PermissionsEntity> FindAll(Predicate predicate, Pageable pageable);

    //Internal operation
    PermissionsEntity FindByPermissionName(String permissionName);
}
