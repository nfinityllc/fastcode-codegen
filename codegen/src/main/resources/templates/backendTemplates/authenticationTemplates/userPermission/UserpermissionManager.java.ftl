package [=PackageName].domain.Authorization.Userpermission;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.UserpermissionEntity;
import [=PackageName].domain.model.UserpermissionId;
import [=PackageName].domain.IRepository.IUserRepository;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.IRepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;

import [=PackageName].domain.IRepository.IUserpermissionRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class UserpermissionManager implements IUserpermissionManager {

    @Autowired
    IUserpermissionRepository  _userpermissionRepository;
    
    @Autowired
	IUserRepository  _userRepository;
    
    @Autowired
	IPermissionRepository  _permissionRepository;
    
	public UserpermissionEntity Create(UserpermissionEntity userpermission) {

		return _userpermissionRepository.save(userpermission);
	}

	public void Delete(UserpermissionEntity userpermission) {

		_userpermissionRepository.delete(userpermission);	
	}

	public UserpermissionEntity Update(UserpermissionEntity userpermission) {

		return _userpermissionRepository.save(userpermission);
	}

	public UserpermissionEntity FindById(UserpermissionId userpermissionId )
    {
    Optional<UserpermissionEntity> dbUserpermission= _userpermissionRepository.findById(userpermissionId);
		if(dbUserpermission.isPresent()) {
			UserpermissionEntity existingUserpermission = dbUserpermission.get();
		    return existingUserpermission;
		} else {
		    return null;
		}
     //   return _userpermissionRepository.findById(
     //   userpermissionId.getPermissionId(),userpermissionId.getUserId());


	}

	public Page<UserpermissionEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _userpermissionRepository.findAll(predicate,pageable);
	}

   //User
	public UserEntity GetUser(UserpermissionId userpermissionId) {
		
		Optional<UserpermissionEntity> dbUserpermission= _userpermissionRepository.findById(userpermissionId);
		if(dbUserpermission.isPresent()) {
			UserpermissionEntity existingUserpermission = dbUserpermission.get();
		    return existingUserpermission.getUser();
		} else {
		    return null;
		}

	//	UserpermissionEntity entity = _userpermissionRepository.findById(userpermissionId.getPermissionId(),userpermissionId.getUserId());

    //  return entity.getUser();
	}
	
   //Permission
	public PermissionEntity GetPermission(UserpermissionId userpermissionId) {
		
		Optional<UserpermissionEntity> dbUserpermission= _userpermissionRepository.findById(userpermissionId);
		if(dbUserpermission.isPresent()) {
			UserpermissionEntity existingUserpermission = dbUserpermission.get();
		    return existingUserpermission.getPermission();
		} else {
		    return null;
		}

	//	UserpermissionEntity entity = _userpermissionRepository.findById(userpermissionId.getPermissionId(),userpermissionId.getUserId());

    //  return entity.getPermission();
	}
	
}
