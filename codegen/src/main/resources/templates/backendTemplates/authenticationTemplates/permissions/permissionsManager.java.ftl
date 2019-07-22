package [=PackageName].domain.Authorization.Permissions;

import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.model.PermissionsEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public class PermissionsManager implements IPermissionsManager {

    @Autowired
    private IPermissionsRepository _permissionsRepository;


    // CRUD Operations

    public PermissionsEntity Create(PermissionsEntity permission) {
        return _permissionsRepository.save(permission);
    }

    public void Delete(PermissionsEntity permission) {
        _permissionsRepository.delete(permission);
    }

    public PermissionsEntity Update(PermissionsEntity permission) {
        return _permissionsRepository.save(permission);
    }

    public PermissionsEntity FindById(Long permissionId) {
        return _permissionsRepository.findById(permissionId.longValue());   
    }

    public Page<PermissionsEntity> FindAll(Predicate predicate, Pageable pageable) {
        return _permissionsRepository.findAll(predicate, pageable);
    }

    public PermissionsEntity FindByPermissionName(String permissionName) {
        return _permissionsRepository.findByPermissionName(permissionName);
 
    }
}
