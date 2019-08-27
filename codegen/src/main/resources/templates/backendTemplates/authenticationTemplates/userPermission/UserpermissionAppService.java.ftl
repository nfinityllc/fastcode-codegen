package [=PackageName].application.Authorization.Userpermission;

import [=PackageName].application.Authorization.Userpermission.Dto.*;
import [=PackageName].domain.Authorization.Userpermission.IUserpermissionManager;
import [=PackageName].domain.model.QUserpermissionEntity;
import [=PackageName].domain.model.UserpermissionEntity;
import [=PackageName].domain.model.UserpermissionId;
import [=PackageName].domain.Authorization.User.UserManager;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.Authorization.Permission.PermissionManager;
import [=PackageName].domain.model.PermissionEntity;
import [=CommonModulePackage].Search.*;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import org.springframework.cache.annotation.*;

import java.util.Date;
import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Validated
public class UserpermissionAppService implements IUserpermissionAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private IUserpermissionManager _userpermissionManager;
  
    @Autowired
	private UserManager _userManager;
    
    @Autowired
	private PermissionManager _permissionManager;
    
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private UserpermissionMapper mapper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreateUserpermissionOutput Create(CreateUserpermissionInput input) {

		UserpermissionEntity userpermission = mapper.CreateUserpermissionInputToUserpermissionEntity(input);
	  	if(input.getUserId()!=null)
		{
		UserEntity foundUser = _userManager.FindById(input.getUserId());
		if(foundUser!=null)
		userpermission.setUser(foundUser);
		}
	  	if(input.getPermissionId()!=null)
		{
		PermissionEntity foundPermission = _permissionManager.FindById(input.getPermissionId());
		if(foundPermission!=null)
		userpermission.setPermission(foundPermission);
		}
		UserpermissionEntity createdUserpermission = _userpermissionManager.Create(userpermission);
		return mapper.UserpermissionEntityToCreateUserpermissionOutput(createdUserpermission);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Userpermission", key = "#userpermissionId")
	public UpdateUserpermissionOutput Update(UserpermissionId userpermissionId , UpdateUserpermissionInput input) {

		UserpermissionEntity userpermission = mapper.UpdateUserpermissionInputToUserpermissionEntity(input);
	  	if(input.getUserId()!=null)
		{
		UserEntity foundUser = _userManager.FindById(input.getUserId());
		if(foundUser!=null)
		userpermission.setUser(foundUser);
		}
	  	if(input.getPermissionId()!=null)
		{
		PermissionEntity foundPermission = _permissionManager.FindById(input.getPermissionId());
		if(foundPermission!=null)
		userpermission.setPermission(foundPermission);
		}
		UserpermissionEntity updatedUserpermission = _userpermissionManager.Update(userpermission);
		return mapper.UserpermissionEntityToUpdateUserpermissionOutput(updatedUserpermission);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Userpermission", key = "#id")

	public void Delete(UserpermissionId userpermissionId ) {

		UserpermissionEntity existing = _userpermissionManager.FindById(userpermissionId) ; 
		_userpermissionManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Userpermission", key = "#id")
	public FindUserpermissionByIdOutput FindById(UserpermissionId userpermissionId ) {

		UserpermissionEntity foundUserpermission = _userpermissionManager.FindById(userpermissionId);
		if (foundUserpermission == null)  
			return null ; 
 	   
 	   FindUserpermissionByIdOutput output=mapper.UserpermissionEntityToFindUserpermissionByIdOutput(foundUserpermission); 
		return output;
	}
    //User
	// ReST API Call - GET /userpermission/1/user
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    @Cacheable (value = "Userpermission", key="#userpermissionId")
	public GetUserOutput GetUser(UserpermissionId userpermissionId ) {

		UserpermissionEntity foundUserpermission = _userpermissionManager.FindById(userpermissionId);
		if (foundUserpermission == null) {
			logHelper.getLogger().error("There does not exist a userpermission wth a id=%s", userpermissionId);
			return null;
		}
		UserEntity re = _userpermissionManager.GetUser(userpermissionId);
		return mapper.UserEntityToGetUserOutput(re, foundUserpermission);
	}
    
    //Permission
	// ReST API Call - GET /userpermission/1/permission
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    @Cacheable (value = "Userpermission", key="#userpermissionId")
	public GetPermissionOutput GetPermission(UserpermissionId userpermissionId ) {

		UserpermissionEntity foundUserpermission = _userpermissionManager.FindById(userpermissionId);
		if (foundUserpermission == null) {
			logHelper.getLogger().error("There does not exist a userpermission wth a id=%s", userpermissionId);
			return null;
		}
		PermissionEntity re = _userpermissionManager.GetPermission(userpermissionId);
		return mapper.PermissionEntityToGetPermissionOutput(re, foundUserpermission);
	}
    

    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Userpermission")
	public List<FindUserpermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<UserpermissionEntity> foundUserpermission = _userpermissionManager.FindAll(Search(search), pageable);
		List<UserpermissionEntity> userpermissionList = foundUserpermission.getContent();
		Iterator<UserpermissionEntity> userpermissionIterator = userpermissionList.iterator(); 
		List<FindUserpermissionByIdOutput> output = new ArrayList<>();

		while (userpermissionIterator.hasNext()) {
			output.add(mapper.UserpermissionEntityToFindUserpermissionByIdOutput(userpermissionIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QUserpermissionEntity userpermission= QUserpermissionEntity.userpermissionEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(userpermission, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(userpermission,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(userpermission, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QUserpermissionEntity userpermission,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
		}
		else if(operator.equals("equals"))
		{
        	if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
       	 	}
			else if(StringUtils.isNumeric(value)){
        	}
        	else if(SearchUtils.stringToDate(value)!=null) {
			}
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(
		
		 list.get(i).replace("%20","").trim().equals("permission") ||
		 list.get(i).replace("%20","").trim().equals("permissionId") ||
		 list.get(i).replace("%20","").trim().equals("user") ||
		 list.get(i).replace("%20","").trim().equals("userId")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QUserpermissionEntity userpermission,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
		  if(list.get(i).replace("%20","").trim().equals("userId")) {
			builder.or(userpermission.user.id.eq(Long.parseLong(value)));
			}
		  if(list.get(i).replace("%20","").trim().equals("permissionId")) {
			builder.or(userpermission.permission.id.eq(Long.parseLong(value)));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QUserpermissionEntity userpermission, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
		}
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("userId")) {
		    builder.and(userpermission.user.id.eq(Long.parseLong(joinCol.getValue())));
		}
        }
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("permissionId")) {
		    builder.and(userpermission.permission.id.eq(Long.parseLong(joinCol.getValue())));
		}
        }
		return builder;
	}
	
	public UserpermissionId parseUserpermissionKey(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		UserpermissionId userpermissionId = new UserpermissionId();
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					//error
				}
			}
		}
		else {
			//error
		}
		
		userpermissionId.setPermissionId(Long.valueOf(keyMap.get("permissionId")));
		userpermissionId.setUserId(Long.valueOf(keyMap.get("userId")));
		return userpermissionId;
		
	}	
	
	
}


