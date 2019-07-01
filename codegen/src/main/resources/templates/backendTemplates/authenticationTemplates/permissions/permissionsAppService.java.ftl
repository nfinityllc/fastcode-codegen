package [=PackageName].application.Authorization.Permissions;

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].application.Authorization.Permissions.Dto.*;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Permissions.PermissionsManager;
import [=PackageName].domain.model.QPermissionsEntity;
import com.querydsl.core.BooleanBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import java.util.*;

@Service
@Validated
public class PermissionAppService implements IPermissionAppService {


	static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	@Autowired
	private PermissionsManager _permissionsManager;

	@Autowired
	private PermissionMapper permissionMapper;

	// CRUD Operations
	// ReST API Call => POST /permissions
	public CreatePermissionOutput Create(CreatePermissionInput permission) {

		PermissionsEntity re = permissionMapper.CreatePermissionInputToPermissionsEntity(permission);
		PermissionsEntity createdPermission = _permissionsManager.Create(re);
		return permissionMapper.PermissionsEntityToCreatePermissionOutput(createdPermission);
	}

	// ReST API Call => DELETE /permissions/1
	public void Delete(Long pid) {

		PermissionsEntity existing = _permissionsManager.FindById(pid);

		_permissionsManager.Delete(existing);
	}

	// ReST API Call => PUT /permissions/1
	public UpdatePermissionOutput Update(Long pid, UpdatePermissionInput permission) {

		PermissionsEntity re = permissionMapper.UpdatePermissionInputToPermissionsEntity(permission);
		PermissionsEntity updatedPermission = _permissionsManager.Update(re);
		return permissionMapper.PermissionsEntityToUpdatePermissionOutput(updatedPermission);
	}

	// ReST API Call => GET /permissions/1

	public FindPermissionByIdOutput FindById(Long pid) {

		PermissionsEntity foundPermission = _permissionsManager.FindById(pid);

		if (foundPermission == null) {
			return null;
		}
		return permissionMapper.PermissionsEntityToFindPermissionByIdOutput(foundPermission);
	}

	public FindPermissionByNameOutput FindByPermissionName(String permissionName) {

		PermissionsEntity foundPermission = _permissionsManager.FindByPermissionName(permissionName);
		if (foundPermission == null) {
			return null;
		}
		return permissionMapper.PermissionsEntityToFindPermissionByNameOutput(foundPermission);

	}

	// ReST API Call => GET /permissions/?offset=2&limit=20&sort=id,asc

	public List<FindPermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception{

		Page<PermissionsEntity> foundPermissions = _permissionsManager.FindAll(Search(search), pageable);
		List<PermissionsEntity> permissionList = foundPermissions.getContent();

		Iterator<PermissionsEntity> permissionIterator = permissionList.iterator();
		List<FindPermissionByIdOutput> output = new ArrayList<>();

		while (permissionIterator.hasNext()) {
			output.add(permissionMapper.PermissionsEntityToFindPermissionByIdOutput(permissionIterator.next()));
		}

		return output;
	}

	public BooleanBuilder Search(SearchCriteria search) throws Exception {

		QPermissionsEntity permission=QPermissionsEntity.permissionsEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(permission, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(permission,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(permission, map,search.getJoinColumn(),search.getJoinColumnValue());
			}

		}
		return null;
	}
	
	public BooleanBuilder searchAllProperties(QPermissionsEntity permission,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
			builder.or(permission.displayName.likeIgnoreCase("%"+ value + "%"));
			builder.or(permission.name.likeIgnoreCase("%"+ value + "%"));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(permission.displayName.eq(value));
        	builder.or(permission.name.eq(value));
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
	public BooleanBuilder searchSpecificProperty(QPermissionsEntity permission,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("displayName")) {
				if(operator.equals("contains"))
					builder.or(permission.displayName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(permission.displayName.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("name")) {
				if(operator.equals("contains"))
					builder.or(permission.name.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(permission.name.eq(value));
			}
		}
		return builder;
	}
	
	public BooleanBuilder searchKeyValuePair(QPermissionsEntity permission, Map<String,SearchFields> map,String joinColumn,Long joinColumnValue) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("displayName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(permission.displayName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(permission.displayName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(permission.displayName.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("name")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(permission.name.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(permission.name.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(permission.name.ne(details.getValue().getSearchValue()));
			}
           
		}

		return builder;
	}

}
