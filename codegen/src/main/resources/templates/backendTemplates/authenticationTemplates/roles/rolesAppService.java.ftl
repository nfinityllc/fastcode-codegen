package [=PackageName].application.Authorization.Roles;

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].application.Authorization.Roles.Dto.*;
import [=PackageName].domain.Authorization.Permissions.IPermissionsManager;
import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Roles.IRolesManager;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.model.QRolesEntity;
import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

@Service
@Validated
public class RoleAppService implements IRoleAppService{

	static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	IRolesManager _roleManager;

	@Autowired
	IPermissionsRepository _permissionsRepository;
	
	@Autowired
	private PermissionAppService _permissionsAppService;

	@Autowired
	IPermissionsManager _permissionManager;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private RoleMapper roleMapper;


	// ReST API Call => POST /roles
	public CreateRoleOutput Create(CreateRoleInput role) {

		RolesEntity re = roleMapper.CreateRoleInputToRolesEntity(role);
		RolesEntity createdRole = _roleManager.Create(re);
		return roleMapper.RolesEntityToCreateRoleOutput(createdRole);
	}

	// ReST API Call => DELETE /roles/1
	public void Delete(Long rid) {
		
		RolesEntity existing = _roleManager.FindById(rid);
		_roleManager.Delete(existing);
	}

	// ReST API Call => PUT /roles/1
	public UpdateRoleOutput Update( Long rid,UpdateRoleInput role) {

		RolesEntity re = roleMapper.UpdateRoleInputToRolesEntity(role);
		RolesEntity updatedRole = _roleManager.Update(re);
		return roleMapper.RolesEntityToUpdateRoleOutput(updatedRole);
	}

	// ReST API Call => GET /roles/1

	public FindRoleByIdOutput FindById(Long rid) {

		RolesEntity foundRole = _roleManager.FindById(rid);

		if (foundRole == null) {
			return null;
		}
		return roleMapper.RolesEntityToFindRoleByIdOutput(foundRole);
	}

	public FindRoleByNameOutput FindByRoleName(String roleName) {

		RolesEntity foundRole = _roleManager.FindByRoleName(roleName);

		if (foundRole == null) {
			return null;
		}
		return roleMapper.RolesEntityToFindRoleByNameOutput(foundRole);
	}

	// ReST API Call => GET /roles/?offset=2&limit=20&sort=id,asc

	public List<FindRoleByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception {


		Page<RolesEntity> foundRoles = _roleManager.FindAll(Search(search), pageable);
		List<RolesEntity> roleList = foundRoles.getContent();

		Iterator<RolesEntity> roleIterator = roleList.iterator();
		List<FindRoleByIdOutput> output = new ArrayList<>();

		while (roleIterator.hasNext()) {
			output.add(roleMapper.RolesEntityToFindRoleByIdOutput(roleIterator.next()));
		}

		return output;
	}
	// Operations With Permission

	// ReST API Call => POST /roles/1/permissions/3

	public Boolean AddPermission(Long rid, Long pid) {

		RolesEntity foundRole = _roleManager.FindById(rid);
		PermissionsEntity foundPermission = _permissionManager.FindById(pid);

		return _roleManager.AddPermission(foundRole, foundPermission);
	}

	// ReST API Call => DELETE /roles/1/permissions/3

	public void RemovePermission(Long rid, Long pid) {

		RolesEntity foundRole = _roleManager.FindById(rid);
		PermissionsEntity foundPermission = _permissionManager.FindById(pid);
		_roleManager.RemovePermission(foundRole, foundPermission);
	}

	// ReST API Call => GET /roles/1/permissions/3

	public GetPermissionOutput GetPermissions(Long rolesId, Long permissionsId) {

		RolesEntity foundRoles = _roleManager.FindById(rolesId);
		if (foundRoles == null) {
			logHelper.getLogger().error("There does not exist roles with a id=%s", rolesId);
			return null;
		}
		PermissionsEntity foundPermissions = _permissionManager.FindById(permissionsId);
		if (foundPermissions == null) {
			logHelper.getLogger().error("There does not exist permissions with a name=%s", foundPermissions);
			return null;
		}

		PermissionsEntity pe = _roleManager.GetPermissions(rolesId, permissionsId);
		return roleMapper.PermissionsEntityToGetPermissionOutput(pe, foundRoles);
	}

	// ReST API Call => GET /roles/1/permissions

	public List<GetPermissionOutput> GetPermissionsList(Long rolesId,SearchCriteria search,String operator,Pageable pageable) throws Exception{

		RolesEntity foundRoles = _roleManager.FindById(rolesId);
		if (foundRoles == null) {
			logHelper.getLogger().error("There does not exist a Roles with a id=%s", rolesId);
			return null;
		}
        checkPermissionsProperties(search.getFields());
        
		Page<PermissionsEntity> foundPermissions = _roleManager.FindPermissions(rolesId,search.getFields(),operator,pageable);
		List<PermissionsEntity> permissionsList = foundPermissions.getContent();
		Iterator<PermissionsEntity> permissionsIterator = permissionsList.iterator();
		List<GetPermissionOutput> output = new ArrayList<>();

		while (permissionsIterator.hasNext()) {
			output.add(roleMapper.PermissionsEntityToGetPermissionOutput(permissionsIterator.next(), foundRoles));
		}
		return output;
	}
	
	public void checkPermissionsProperties(List<SearchFields> search) throws Exception
	{
		List<String> keysList = new ArrayList<String>();
		for (SearchFields obj : search) {
            keysList.add(obj.getFieldName());
        }
		_permissionsAppService.checkProperties(keysList);
	}
	
	public BooleanBuilder Search(SearchCriteria search) throws Exception {

		QRolesEntity role=QRolesEntity.rolesEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(role, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(role,keysList,search.getValue(),search.getOperator());
			}
			else if(search.getType()==case3)
			{
				Map<String,SearchFields> map = new HashMap<>();
				for(SearchFields fieldDetails: search.getFields())
				{
					map.put(fieldDetails.getFieldName(),fieldDetails);
				}
				List<String> keysList = new ArrayList<String>(map.keySet());
				checkProperties(keysList);
				return searchKeyValuePair(role, map,search.getJoinColumn(),search.getJoinColumnValue());
			}

		}
		return null;
	}
	
	public BooleanBuilder searchAllProperties(QRolesEntity role,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
			builder.or(role.displayName.likeIgnoreCase("%"+ value + "%"));
			builder.or(role.name.likeIgnoreCase("%"+ value + "%"));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(role.displayName.eq(value));
        	builder.or(role.name.eq(value));
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception
	{
		for (int i = 0; i < list.size(); i++) {
			if(!((list.get(i).replace("%20","").trim().equals("displayName"))
					|| (list.get(i).replace("%20","").trim().equals("name")))) {


				// Throw an exception
				throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
			}
		}

	}
	public BooleanBuilder searchSpecificProperty(QRolesEntity role,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("displayName")) {
				if(operator.equals("contains"))
					builder.or(role.displayName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(role.displayName.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("name")) {
				if(operator.equals("contains"))
					builder.or(role.name.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(role.name.eq(value));
			}
		}
		return builder;
	}
	
	public BooleanBuilder searchKeyValuePair(QRolesEntity role, Map<String,SearchFields> map,String joinColumn,Long joinColumnValue) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("displayName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(role.displayName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(role.displayName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(role.displayName.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("name")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(role.name.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(role.name.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(role.name.ne(details.getValue().getSearchValue()));
			}
           
		}

		return builder;
	}

}
