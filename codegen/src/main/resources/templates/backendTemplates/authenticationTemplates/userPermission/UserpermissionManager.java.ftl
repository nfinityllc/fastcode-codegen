package [=PackageName].domain.Authorization.[=AuthenticationTable]permission;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=PackageName].domain.IRepository.I[=AuthenticationTable]Repository;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.IRepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;

import [=PackageName].domain.IRepository.I[=AuthenticationTable]permissionRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class [=AuthenticationTable]permissionManager implements I[=AuthenticationTable]permissionManager {

    @Autowired
    I[=AuthenticationTable]permissionRepository  _[=AuthenticationTable?uncap_first]permissionRepository;
    
    @Autowired
	I[=AuthenticationTable]Repository  _[=AuthenticationTable?uncap_first]Repository;
    
    @Autowired
	IPermissionRepository  _permissionRepository;
    
	public [=AuthenticationTable]permissionEntity Create([=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission) {

		return _[=AuthenticationTable?uncap_first]permissionRepository.save([=AuthenticationTable?uncap_first]permission);
	}

	public void Delete([=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission) {

		_[=AuthenticationTable?uncap_first]permissionRepository.delete([=AuthenticationTable?uncap_first]permission);	
	}

	public [=AuthenticationTable]permissionEntity Update([=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission) {

		return _[=AuthenticationTable?uncap_first]permissionRepository.save([=AuthenticationTable?uncap_first]permission);
	}

	public [=AuthenticationTable]permissionEntity FindById([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId ) {
    
    Optional<[=AuthenticationTable]permissionEntity> db[=AuthenticationTable]permission= _[=AuthenticationTable?uncap_first]permissionRepository.findById([=AuthenticationTable?uncap_first]permissionId);
		if(db[=AuthenticationTable]permission.isPresent()) {
			[=AuthenticationTable]permissionEntity existing[=AuthenticationTable]permission = db[=AuthenticationTable]permission.get();
		    return existing[=AuthenticationTable]permission;
		} else {
		    return null;
		}
    
	}

	public Page<[=AuthenticationTable]permissionEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _[=AuthenticationTable?uncap_first]permissionRepository.findAll(predicate,pageable);
	}

    //[=AuthenticationTable]
	public [=AuthenticationTable]Entity Get[=AuthenticationTable]([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId) {
		
		Optional<[=AuthenticationTable]permissionEntity> db[=AuthenticationTable]permission= _[=AuthenticationTable?uncap_first]permissionRepository.findById([=AuthenticationTable?uncap_first]permissionId);
		if(db[=AuthenticationTable]permission.isPresent()) {
			[=AuthenticationTable]permissionEntity existing[=AuthenticationTable]permission = db[=AuthenticationTable]permission.get();
		    return existing[=AuthenticationTable]permission.get[=AuthenticationTable]();
		} else {
		    return null;
		}

	}
	
   //Permission
	public PermissionEntity GetPermission([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId) {
		
		Optional<[=AuthenticationTable]permissionEntity> db[=AuthenticationTable]permission= _[=AuthenticationTable?uncap_first]permissionRepository.findById([=AuthenticationTable?uncap_first]permissionId);
		if(db[=AuthenticationTable]permission.isPresent()) {
			[=AuthenticationTable]permissionEntity existing[=AuthenticationTable]permission = db[=AuthenticationTable]permission.get();
		    return existing[=AuthenticationTable]permission.getPermission();
		} else {
		    return null;
		}
	}
	
}
