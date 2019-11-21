package [=PackageName].domain.Authorization.[=AuthenticationTable]role;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import [=PackageName].domain.IRepository.I[=AuthenticationTable]Repository;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.IRepository.IRoleRepository;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.IRepository.I[=AuthenticationTable]roleRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class [=AuthenticationTable]roleManager implements I[=AuthenticationTable]roleManager {

    @Autowired
    I[=AuthenticationTable]roleRepository  _[=AuthenticationTable?uncap_first]roleRepository;
    
    @Autowired
	I[=AuthenticationTable]Repository  _[=AuthenticationTable?uncap_first]Repository;
    
    @Autowired
	IRoleRepository  _roleRepository;
    
	public [=AuthenticationTable]roleEntity Create([=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role) {

		return _[=AuthenticationTable?uncap_first]roleRepository.save([=AuthenticationTable?uncap_first]role);
	}

	public void Delete([=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role) {

		_[=AuthenticationTable?uncap_first]roleRepository.delete([=AuthenticationTable?uncap_first]role);	
	}

	public [=AuthenticationTable]roleEntity Update([=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role) {

		return _[=AuthenticationTable?uncap_first]roleRepository.save([=AuthenticationTable?uncap_first]role);
	}

	public [=AuthenticationTable]roleEntity FindById([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {
    	Optional<[=AuthenticationTable]roleEntity> db[=AuthenticationTable]role= _[=AuthenticationTable?uncap_first]roleRepository.findById([=AuthenticationTable?uncap_first]roleId);
		if(db[=AuthenticationTable]role.isPresent()) {
			[=AuthenticationTable]roleEntity existing[=AuthenticationTable]role = db[=AuthenticationTable]role.get();
		    return existing[=AuthenticationTable]role;
		} else {
		    return null;
		}

	}

	public Page<[=AuthenticationTable]roleEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _[=AuthenticationTable?uncap_first]roleRepository.findAll(predicate,pageable);
	}
  
   //[=AuthenticationTable]
	public [=AuthenticationTable]Entity Get[=AuthenticationTable]([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {
		
		Optional<[=AuthenticationTable]roleEntity> db[=AuthenticationTable]role= _[=AuthenticationTable?uncap_first]roleRepository.findById([=AuthenticationTable?uncap_first]roleId);
		if(db[=AuthenticationTable]role.isPresent()) {
			[=AuthenticationTable]roleEntity existing[=AuthenticationTable]role = db[=AuthenticationTable]role.get();
		    return existing[=AuthenticationTable]role.get[=AuthenticationTable]();
		} else {
		    return null;
		}
	}
  
   //Role
	public RoleEntity GetRole([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {
		
		Optional<[=AuthenticationTable]roleEntity> db[=AuthenticationTable]role= _[=AuthenticationTable?uncap_first]roleRepository.findById([=AuthenticationTable?uncap_first]roleId);
		if(db[=AuthenticationTable]role.isPresent()) {
			[=AuthenticationTable]roleEntity existing[=AuthenticationTable]role = db[=AuthenticationTable]role.get();
		    return existing[=AuthenticationTable]role.getRole();
		} else {
		    return null;
		}
	}
}
