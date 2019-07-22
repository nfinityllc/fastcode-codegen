package [=PackageName].domain.Authorization.Roles;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.IRepository.IRolesRepository;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
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

	// CRUD Operations
	public RolesEntity Create(RolesEntity role) {
		return _rolesRepository.save(role);
	}

	public void Delete(RolesEntity role) {
		_rolesRepository.delete(role);
	}

	public RolesEntity Update(RolesEntity role) {
		return _rolesRepository.save(role);
	}

	public RolesEntity FindById(Long roleId) {
		return _rolesRepository.findById(roleId.longValue());
	}

	public Page<RolesEntity> FindAll(Predicate predicate, Pageable pageable) {
		return _rolesRepository.findAll(predicate, pageable);
	}

	// Internal Operations
	public RolesEntity FindByRoleName(String roleName) {

		return _rolesRepository.findByRoleName(roleName);
	}

    //Permissions
	public Page<PermissionsEntity> FindPermissions(Long rolesId,List<SearchFields> search,String operator,Pageable pageable) {

		return _rolesRepository.getAllPermissions(rolesId,search,operator,pageable);
	}
   
	public Boolean AddPermission(RolesEntity roles, PermissionsEntity permissions) {
		
		Set<PermissionsEntity> sp = roles.getPermissions();

		if (!sp.contains(permissions)) {
		    sp.add(permissions);
			roles.setPermissions(sp);
		} else {
			return false;
			//throw new EntityExistsException("The role already has the permission either individually or a part of the role");
		}
		_rolesRepository.save(roles);
		return true;
	}

	public void RemovePermission(RolesEntity roles, PermissionsEntity permissions) {
	
		Set<PermissionsEntity> sp = roles.getPermissions();

        if (sp.contains(permissions)) {
            sp.remove(permissions);
            roles.setPermissions(sp);
        }
        _rolesRepository.save(roles);
	}

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
