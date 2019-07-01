package [=PackageName].domain.Authorization.Roles;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.IRepository.IRolesRepository;
import [=PackageName].domain.IRepository.IUsersRepository;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import [=CommonModulePackage].Search.SearchFields;

import java.util.Iterator;
import java.util.Set;
import java.util.List;

@Repository

public class RolesManager implements IRolesManager {

	@Autowired
	private IPermissionsRepository _permissionsRepository;

	@Autowired
	private IRolesRepository _rolesRepository;
	
	@Autowired
	IUsersRepository  _usersRepository;

	// CRUD Operations
	@Transactional
	public RolesEntity Create(RolesEntity role) {
		return _rolesRepository.save(role);
	}

	@Transactional
	public void Delete(RolesEntity role) {
		_rolesRepository.delete(role);
	}

	@Transactional
	public RolesEntity Update(RolesEntity role) {
		return _rolesRepository.save(role);
	}

	@Transactional
	public RolesEntity FindById(Long roleId) {
		return _rolesRepository.findById(roleId.longValue());
	}

	@Transactional
	public Page<RolesEntity> FindAll(Predicate predicate, Pageable pageable) {
		return _rolesRepository.findAll(predicate, pageable);
	}

	// Internal Operations

	@Transactional
	public RolesEntity FindByRoleName(String roleName) {

		return _rolesRepository.findByRoleName(roleName);
	}

    //Permissions
    @Transactional
	public Page<PermissionsEntity> FindPermissions(Long rolesId,List<SearchFields> search,String operator,Pageable pageable) {

		return _rolesRepository.getAllPermissions(rolesId,search,operator,pageable);
	}
    @Transactional
	public Boolean AddPermission(RolesEntity roles, PermissionsEntity permissions) {
		
		Set<RolesEntity> entitySet = permissions.getRoles();

		if (!entitySet.contains(roles)) {
			permissions.addRole(roles);
		} else {
			return false;
		//	throw new EntityExistsException("The roles already has the permissions");
		}
		_permissionsRepository.save(permissions);
		return true;
	}

	@Transactional
	public void RemovePermission(RolesEntity roles, PermissionsEntity permissions) {

		permissions.removeRole(roles);
		_permissionsRepository.save(permissions);
	}

	@Transactional
	public PermissionsEntity GetPermissions(Long rolesId, Long permissionsId) {

		RolesEntity foundRecord = _rolesRepository.findById(rolesId.longValue());
		
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
