package [=PackageName].application.Authorization.Users;

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].application.Authorization.Users.Dto.*;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Permissions.PermissionsManager;
import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].domain.Authorization.Users.IUserManager;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.Authorization.Roles.RolesManager;
import [=PackageName].domain.Authorization.Users.UserManager;
import [=PackageName].domain.model.UsersEntity;
import [=PackageName].domain.model.QUsersEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import java.util.*;

@Service
@Validated
public class UserAppService implements IUserAppService {

static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private IUserManager userManager;
  
    @Autowired
	private RolesManager  roleManager;
	
    @Autowired
	private PermissionsManager  permissionManager;
	
    @Autowired 
	private PermissionAppService permissionsAppService;
	
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private UserMapper userMapper;

	public CreateUserOutput Create(CreateUserInput input) {

		UsersEntity users = userMapper.CreateUserInputToUsersEntity(input);
	  	if(input.getRoleId()!=null)
		{
		RolesEntity foundRoles = roleManager.FindById(input.getRoleId());
		if(foundRoles!=null)
		users.setRole(foundRoles);
		}
		
		UsersEntity createdUsers = userManager.Create(users);
		return userMapper.UsersEntityToCreateUserOutput(createdUsers);
	}
	public UpdateUserOutput Update(Long id , UpdateUserInput input) {

		UsersEntity users = userMapper.UpdateUserInputToUsersEntity(input);
	  	if(input.getRoleId()!=null)
		{
		RolesEntity foundRoles = roleManager.FindById(input.getRoleId());
		if(foundRoles!=null)
		users.setRole(foundRoles);
		}

		UsersEntity updatedUsers = userManager.Update(users);
		return userMapper.UsersEntityToUpdateUserOutput(updatedUsers);
	}
	public void Delete(Long id) {

		UsersEntity existing = userManager.FindById(id) ; 

		userManager.Delete(existing);
	}
	public FindUserByIdOutput FindById(Long id) {

		UsersEntity foundUsers = userManager.FindById(id);

		if (foundUsers == null)  
			return null ; 
 	   
 	   FindUserByIdOutput output=userMapper.UsersEntityToFindUserByIdOutput(foundUsers); 
		return output;
	}
	
	public FindUserByNameOutput FindByUserName(String userName) {

		UsersEntity foundUser = userManager.FindByUserName(userName);
		if (foundUser == null) {
			return null;
		}
		return  userMapper.UsersEntityToFindUserByNameOutput(foundUser);

	}

	 //Roles
	// ReST API Call - GET /users/1/roles

	public GetRoleOutput GetRoles(Long usersId) {
		UsersEntity foundUsers = userManager.FindById(usersId);
		if (foundUsers == null) {
			logHelper.getLogger().error("There does not exist a users wth a id=%s", usersId);
			return null;
		}
		RolesEntity re = userManager.GetRoles(usersId);
		return userMapper.RolesEntityToGetRoleOutput(re, foundUsers);
	}
    //Permissions
    public Boolean AddPermissions(Long usersId, Long permissionsId) {
		UsersEntity foundUsers = userManager.FindById(usersId);
		PermissionsEntity foundPermissions = permissionManager.FindById(permissionsId);

		return userManager.AddPermissions(foundUsers, foundPermissions);
	}

	public void RemovePermissions(Long usersId, Long permissionsId) {

		UsersEntity foundUsers = userManager.FindById(usersId);
		PermissionsEntity foundPermissions = permissionManager.FindById(permissionsId);

		userManager.RemovePermissions(foundUsers, foundPermissions);
	}

	// ReST API Call => GET /users/1/permissions/3

	public GetPermissionOutput GetPermissions(Long usersId, Long permissionsId) {

		UsersEntity foundUsers = userManager.FindById(usersId);
		if (foundUsers == null) {
			logHelper.getLogger().error("There does not exist users with a id=%s", usersId);
			return null;
		}
		PermissionsEntity foundPermissions = permissionManager.FindById(permissionsId);
		if (foundPermissions == null) {
			logHelper.getLogger().error("There does not exist permissions with a name=%s", foundPermissions);
			return null;
		}

		PermissionsEntity pe = userManager.GetPermissions(usersId, permissionsId);
		return userMapper.PermissionsEntityToGetPermissionOutput(pe, foundUsers);
	}

	// ReST API Call => GET /users/1/permissions

	public List<GetPermissionOutput> GetPermissionsList(Long usersId,SearchCriteria search,String operator,Pageable pageable) throws Exception{

		UsersEntity foundUsers = userManager.FindById(usersId);
		if (foundUsers == null) {
			logHelper.getLogger().error("There does not exist a Users with a id=%s", usersId);
			return null;
		}
        checkPermissionsProperties(search.getFields());
        
		Page<PermissionsEntity> foundPermissions = userManager.FindPermissions(usersId,search.getFields(),operator,pageable);
		List<PermissionsEntity> permissionsList = foundPermissions.getContent();
		Iterator<PermissionsEntity> permissionsIterator = permissionsList.iterator();
		List<GetPermissionOutput> output = new ArrayList<>();

		while (permissionsIterator.hasNext()) {
			output.add(userMapper.PermissionsEntityToGetPermissionOutput(permissionsIterator.next(), foundUsers));
		}
		return output;
	}
	
	public void checkPermissionsProperties(List<SearchFields> search) throws Exception
	{
		List<String> keysList = new ArrayList<String>();
		for (SearchFields obj : search) {
            keysList.add(obj.getFieldName());
        }
		permissionsAppService.checkProperties(keysList);
	}

	public List<FindUserByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<UsersEntity> foundUsers = userManager.FindAll(Search(search), pageable);
		List<UsersEntity> usersList = foundUsers.getContent();
		Iterator<UsersEntity> usersIterator = usersList.iterator(); 
		List<FindUserByIdOutput> output = new ArrayList<>();

		while (usersIterator.hasNext()) {
			output.add(userMapper.UsersEntityToFindUserByIdOutput(usersIterator.next()));
		}
		return output;
	}
	
	public BooleanBuilder Search(SearchCriteria search) throws Exception {

		QUsersEntity users=QUsersEntity.usersEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(users, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(users,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(users, map,search.getJoinColumn(),search.getJoinColumnValue());
			}

		}
		return null;
	}
	
	public BooleanBuilder searchAllProperties(QUsersEntity users,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
			builder.or(users.firstName.likeIgnoreCase("%"+ value + "%"));
			builder.or(users.lastName.likeIgnoreCase("%"+ value + "%"));
			builder.or(users.emailAddress.likeIgnoreCase("%"+ value + "%"));
			builder.or(users.userName.likeIgnoreCase("%"+ value + "%"));
			builder.or(users.phoneNumber.likeIgnoreCase("%"+ value + "%"));
			builder.or(users.authenticationSource.likeIgnoreCase("%"+ value + "%"));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(users.firstName.eq(value));
        	builder.or(users.lastName.eq(value));
        	builder.or(users.emailAddress.eq(value));
        	builder.or(users.userName.eq(value));
        	builder.or(users.phoneNumber.eq(value));
        	builder.or(users.authenticationSource.eq(value));
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception
	{
		for (int i = 0; i < list.size(); i++) {
			if(!((list.get(i).replace("%20","").trim().equals("firstName"))
					|| (list.get(i).replace("%20","").trim().equals("lastName"))
					|| (list.get(i).replace("%20","").trim().equals("emailAddress"))
					|| (list.get(i).replace("%20","").trim().equals("userName"))
					|| (list.get(i).replace("%20","").trim().equals("phoneNumber"))
					|| (list.get(i).replace("%20","").trim().equals("authenticationSource")))) {

				// Throw an exception
				throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
			}
		}
	}
	public BooleanBuilder searchSpecificProperty(QUsersEntity users,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("firstName")) {
				if(operator.equals("contains"))
					builder.or(users.firstName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(users.firstName.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("lastName")) {
				if(operator.equals("contains"))
					builder.or(users.lastName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(users.lastName.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("emailAddress")) {
				if(operator.equals("contains"))
					builder.or(users.emailAddress.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(users.emailAddress.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("userName")) {
				if(operator.equals("contains"))
					builder.or(users.userName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(users.userName.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("phoneNumber")) {
				if(operator.equals("contains"))
					builder.or(users.phoneNumber.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(users.phoneNumber.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("authenticationSource")) {
				if(operator.equals("contains"))
					builder.or(users.authenticationSource.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(users.authenticationSource.eq(value));
			}
			if(list.get(i).replace("%20","").trim().equals("roleId")) {
			builder.or(users.role.id.eq(Long.parseLong(value)));
			}
		}
		return builder;
	}
	
	public BooleanBuilder searchKeyValuePair(QUsersEntity users, Map<String,SearchFields> map,String joinColumn,Long joinColumnValue) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("firstName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(users.firstName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(users.firstName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(users.firstName.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("lastName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(users.lastName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(users.lastName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(users.lastName.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("emailAddress")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(users.emailAddress.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(users.emailAddress.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(users.emailAddress.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("userName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(users.userName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(users.userName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(users.userName.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("phoneNumber")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(users.phoneNumber.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(users.phoneNumber.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(users.phoneNumber.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("authenticationSource")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(users.authenticationSource.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(users.authenticationSource.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(users.authenticationSource.ne(details.getValue().getSearchValue()));
			}
			
		}
		if(joinColumn != null && joinColumn.equals("roleId")) {
			builder.and(users.role.id.eq(joinColumnValue));
		}

		return builder;
	}

}

