package [=PackageName].domain.Authorization.Permissions;

import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.model.PermissionsEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class PermissionsManager implements IPermissionsManager {

    @Autowired
    private IPermissionsRepository _permissionsRepository;


    // CRUD Operations

    @Transactional
    public PermissionsEntity Create(PermissionsEntity permission) {
        return _permissionsRepository.save(permission);
    }

    @Transactional
    public void Delete(PermissionsEntity permission) {
        _permissionsRepository.delete(permission);
    }

    @Transactional
    public PermissionsEntity Update(PermissionsEntity permission) {
        return _permissionsRepository.save(permission);
    }

    @Transactional
    public PermissionsEntity FindById(Long permissionId) {
        return _permissionsRepository.findById(permissionId.longValue());   
    }

    @Transactional
    public Page<PermissionsEntity> FindAll(Predicate predicate, Pageable pageable) {
        return _permissionsRepository.findAll(predicate, pageable);
    }

    @Transactional
    public PermissionsEntity FindByPermissionName(String permissionName) {
        return _permissionsRepository.findByPermissionName(permissionName);
 
    }
}
