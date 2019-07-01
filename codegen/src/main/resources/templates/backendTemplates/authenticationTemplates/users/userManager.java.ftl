package [=PackageName].domain.Authorization.Users;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.model.UsersEntity;
import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.IRepository.IRolesRepository;
import [=PackageName].domain.IRepository.IUsersRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import [=CommonModulePackage].Search.SearchFields;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

@Repository

public class UserManager implements IUserManager {


	@Autowired
	private IUsersRepository _usersRepository;

	@Autowired
	private IPermissionsRepository _permissionsRepository;

	@Autowired
	private IRolesRepository _rolesRepository;


	// CRUD Operations
	@Transactional
	public UsersEntity Create(UsersEntity user) {
		return _usersRepository.save(user);
	}

	@Transactional
	public void Delete(UsersEntity user) {
		_usersRepository.delete(user);
	}

	@Transactional
	public UsersEntity Update(UsersEntity user) {
		return _usersRepository.save(user);
	}

	@Transactional
	public UsersEntity FindById(Long userId) {
		return  _usersRepository.findById(userId.longValue());
	}

	@Transactional
	public Page<UsersEntity> FindAll(Predicate predicate, Pageable pageable) {
		return _usersRepository.findAll(predicate, pageable);
	}

	@Transactional
	public UsersEntity FindByUserName(String userName) {
		return  _usersRepository.findByUserName(userName);
	}

 //Roles
	@Transactional
	public RolesEntity GetRoles(Long usersId) {
		
		UsersEntity entity = _usersRepository.findById(usersId.longValue());
		return entity.getRole();
	}
    //Permissions
    @Transactional
	public Page<PermissionsEntity> FindPermissions(Long usersId,List<SearchFields> search,String operator,Pageable pageable) {

		return _usersRepository.getAllPermissions(usersId,search,operator,pageable);
	}
    @Transactional
	public Boolean AddPermissions(UsersEntity users, PermissionsEntity permissions) {
		
		Set<UsersEntity> entitySet = permissions.getUsers();

		if (!entitySet.contains(users)) {
			permissions.addUser(users);
		} else {
			return false;
		//	throw new EntityExistsException("The users already has the permissions");
		}
		_permissionsRepository.save(permissions);
		return true;
	}

	@Transactional
	public void RemovePermissions(UsersEntity users, PermissionsEntity permissions) {

		permissions.removeUser(users);
		_permissionsRepository.save(permissions);
	}

	@Transactional
	public PermissionsEntity GetPermissions(Long usersId, Long permissionsId) {

		UsersEntity foundRecord = _usersRepository.findById(usersId.longValue());
		
		Set<PermissionsEntity> permissions = foundRecord.getPermissions();
		Iterator iterator = permissions.iterator();
		while (iterator.hasNext()) { 
			PermissionsEntity pe = (PermissionsEntity) iterator.next();
			if (pe.getId() == permissionsId) {
				return pe;
			}
		}
		return null;
	}

}

