package [=PackageName].domain.Authorization.Rolepermission;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.model.RolepermissionId;
import [=PackageName].domain.IRepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.IRepository.IRoleRepository;
import [=PackageName].domain.model.RoleEntity;

import [=PackageName].domain.IRepository.IRolepermissionRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class RolepermissionManager implements IRolepermissionManager {

    @Autowired
    IRolepermissionRepository  _rolepermissionRepository;
    
    @Autowired
	IPermissionRepository  _permissionRepository;
    
    @Autowired
	IRoleRepository  _roleRepository;
    
	public RolepermissionEntity Create(RolepermissionEntity rolepermission) {

		return _rolepermissionRepository.save(rolepermission);
	}

	public void Delete(RolepermissionEntity rolepermission) {

		_rolepermissionRepository.delete(rolepermission);	
	}

	public RolepermissionEntity Update(RolepermissionEntity rolepermission) {

		return _rolepermissionRepository.save(rolepermission);
	}

	public RolepermissionEntity FindById(RolepermissionId rolepermissionId )
    {
    Optional<RolepermissionEntity> dbRolepermission= _rolepermissionRepository.findById(rolepermissionId);
		if(dbRolepermission.isPresent()) {
			RolepermissionEntity existingRolepermission = dbRolepermission.get();
		    return existingRolepermission;
		} else {
		    return null;
		}
     //   return _rolepermissionRepository.findById(
     //   rolepermissionId.getPermissionId(),rolepermissionId.getRoleId());


	}

	public Page<RolepermissionEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _rolepermissionRepository.findAll(predicate,pageable);
	}

   //Permission
	public PermissionEntity GetPermission(RolepermissionId rolepermissionId) {
		
		Optional<RolepermissionEntity> dbRolepermission= _rolepermissionRepository.findById(rolepermissionId);
		if(dbRolepermission.isPresent()) {
			RolepermissionEntity existingRolepermission = dbRolepermission.get();
		    return existingRolepermission.getPermission();
		} else {
		    return null;
		}

	//	RolepermissionEntity entity = _rolepermissionRepository.findById(rolepermissionId.getPermissionId(),rolepermissionId.getRoleId());

    //  return entity.getPermission();
	}
	
   //Role
	public RoleEntity GetRole(RolepermissionId rolepermissionId) {
		
		Optional<RolepermissionEntity> dbRolepermission= _rolepermissionRepository.findById(rolepermissionId);
		if(dbRolepermission.isPresent()) {
			RolepermissionEntity existingRolepermission = dbRolepermission.get();
		    return existingRolepermission.getRole();
		} else {
		    return null;
		}

	//	RolepermissionEntity entity = _rolepermissionRepository.findById(rolepermissionId.getPermissionId(),rolepermissionId.getRoleId());

    //  return entity.getRole();
	}
	
}
