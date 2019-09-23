package [=PackageName].domain.Authorization.User;

import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.IRepository.IUserpermissionRepository;
import [=PackageName].domain.IRepository.IRoleRepository;
import [=PackageName].domain.IRepository.IUserRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=CommonModulePackage].Search.SearchFields;

import java.util.Optional;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

@Repository

public class UserManager implements IUserManager {

	@Autowired
    IUserRepository  _userRepository;
    
    @Autowired
	IUserpermissionRepository  _userpermissionRepository;
    
    @Autowired
	IRoleRepository  _roleRepository;
    
	public UserEntity Create(UserEntity user) {

		return _userRepository.save(user);
	}

	public void Delete(UserEntity user) {

		_userRepository.delete(user);	
	}

	public UserEntity Update(UserEntity user) {

		return _userRepository.save(user);
	}

	public UserEntity FindById(Long  userId) {
    Optional<UserEntity> dbUser= _userRepository.findById(userId);
		if(dbUser.isPresent()) {
			UserEntity existingUser = dbUser.get();
		    return existingUser;
		} else {
		    return null;
		}
	}

	public Page<UserEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _userRepository.findAll(predicate,pageable);
	}

	public UserEntity FindByUserName(String userName) {
		return  _userRepository.findByUserName(userName);
	}

  //Role
	public RoleEntity GetRole(Long userId) {
		
		Optional<UserEntity> dbUser= _userRepository.findById(userId);
		if(dbUser.isPresent()) {
			UserEntity existingUser = dbUser.get();
		    return existingUser.getRole();
		} else {
		    return null;
		}

	}
<#if AuthenticationType == "oidc">

	public Set<PermissionEntity> GetPermissions(UserEntity user) {
 
 		UserEntity foundUser = _userRepository.findById(user.getId().longValue());
 		return foundUser.getPermissions();
 	}
</#if>
 
}

