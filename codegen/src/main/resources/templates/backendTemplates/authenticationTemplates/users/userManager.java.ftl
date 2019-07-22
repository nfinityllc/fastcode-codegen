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
	public UsersEntity Create(UsersEntity user) {
		return _usersRepository.save(user);
	}

	public void Delete(UsersEntity user) {
		_usersRepository.delete(user);
	}

	public UsersEntity Update(UsersEntity user) {
		return _usersRepository.save(user);
	}

	public UsersEntity FindById(Long userId) {
		return  _usersRepository.findById(userId.longValue());
	}

	public Page<UsersEntity> FindAll(Predicate predicate, Pageable pageable) {
		return _usersRepository.findAll(predicate, pageable);
	}

	public UsersEntity FindByUserName(String userName) {
		return  _usersRepository.findByUserName(userName);
	}

 //Roles
	public RolesEntity GetRoles(Long usersId) {
		
		UsersEntity entity = _usersRepository.findById(usersId.longValue());
		return entity.getRole();
	}
	
    //Permissions
	public Page<PermissionsEntity> FindPermissions(Long usersId,List<SearchFields> search,String operator,Pageable pageable) {

		return _usersRepository.getAllPermissions(usersId,search,operator,pageable);
	}

	public Boolean AddPermissions(UsersEntity users, PermissionsEntity permissions) {
	// We should not grant the permission if the user is in a role that already has the permission or if the permission is already directly assigned to the user.

		Set<PermissionsEntity> sp = users.getRole().getPermissions();
		Set<PermissionsEntity> up = users.getPermissions();

		if (!sp.contains(permissions)) {
			if(!up.contains(permissions)) {
				up.add(permissions);
				users.setPermissions(up);
			}
		} else {
			return false;
		}
		_usersRepository.save(users);
		return true;
	}

	public void RemovePermissions(UsersEntity users, PermissionsEntity permissions) {
		// We should remove the permission if it exists individually (not a part of the role permission set).

		Set<PermissionsEntity> up = users.getPermissions();

		if (up.contains(permissions)) {
			up.remove(permissions);
			users.setPermissions(up);
		}
		_usersRepository.save(users);
	}

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

