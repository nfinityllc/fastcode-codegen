package [=PackageName].domain.authorization.permission;

import [=PackageName].domain.irepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public class PermissionManager implements IPermissionManager {

    @Autowired
    IPermissionRepository  _permissionRepository;
   
    
	public PermissionEntity Create(PermissionEntity permission) {

		return _permissionRepository.save(permission);
	}

	public void Delete(PermissionEntity permission) {

		_permissionRepository.delete(permission);	
	}

	public PermissionEntity Update(PermissionEntity permission) {

		return _permissionRepository.save(permission);
	}

	public PermissionEntity FindById(Long  permissionId)
    {
    Optional<PermissionEntity> dbPermission= _permissionRepository.findById(permissionId);
		if(dbPermission.isPresent()) {
			PermissionEntity existingPermission = dbPermission.get();
		    return existingPermission;
		} else {
		    return null;
		}
     //  return _permissionRepository.findById(permissionId.longValue());

	}

	public Page<PermissionEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _permissionRepository.findAll(predicate,pageable);
	}

    public PermissionEntity FindByPermissionName(String permissionName) {
        return _permissionRepository.findByPermissionName(permissionName);
 
    }
}
