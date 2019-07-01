package [=PackageName].application.Authorization.Users;

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].application.Authorization.Users.Dto.CreateUserInput;
import [=PackageName].application.Authorization.Users.Dto.FindUserByIdOutput;
import [=PackageName].application.Authorization.Users.Dto.GetPermissionOutput;
import [=PackageName].application.Authorization.Users.Dto.UpdateUserInput;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Permissions.PermissionsManager;
import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.Authorization.Roles.RolesManager;
import [=PackageName].domain.Authorization.Users.UserManager;
import [=PackageName].domain.model.UsersEntity;
import [=PackageName].domain.model.QUsersEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@RunWith(SpringJUnit4ClassRunner.class)
public class UserAppServiceTest {

	@InjectMocks
	UserAppService userAppService;

	@Mock
	UserManager userManager;

	@Mock
	PermissionsManager permissionManager;
	
	@Mock
	private PermissionAppService  permissionsAppService;

	@Mock
	RolesManager roleManager;

	@Mock
	UserMapper userMapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(userAppService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

	}

	@After
	public void tearDown() throws Exception {
	}


	@Test 
	public void findUserById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(userManager.FindById(anyLong())).thenReturn(null);	
		Assertions.assertThat(userAppService.FindById(ID)).isEqualTo(null);	

	}

	@Test
	public void findUserById_IdIsNotNullAndUserExists_ReturnAUser() {

		UsersEntity user = mock(UsersEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(user);
		Assertions.assertThat(userAppService.FindById(ID)).isEqualTo(userMapper.UsersEntityToCreateUserOutput(user));
	}

	@Test 
	public void findUserByName_NameIsNotNullAndUserDoesNotExist_ReturnNull() {

		Mockito.when(userManager.FindByUserName(anyString())).thenReturn(null);	
		Assertions.assertThat(userAppService.FindByUserName("User1")).isEqualTo(null);	

	}

	@Test
	public void findUserByName_NameIsNotNullAndUserExists_ReturnAUser() {

		UsersEntity user = mock(UsersEntity.class);

		Mockito.when(userManager.FindByUserName(anyString())).thenReturn(user);
		Assertions.assertThat(userAppService.FindByUserName("User1")).isEqualTo(userMapper.UsersEntityToCreateUserOutput(user));
	}

	@Test
	public void createUser_UserIsNotNullAndUserDoesNotExist_StoreAUser() {

		UsersEntity userEntity = mock(UsersEntity.class);
		CreateUserInput user=mock(CreateUserInput.class);

		Mockito.when(userMapper.CreateUserInputToUsersEntity(any(CreateUserInput.class))).thenReturn(userEntity);
		Mockito.when(userManager.Create(any(UsersEntity.class))).thenReturn(userEntity);
		Assertions.assertThat(userAppService.Create(user)).isEqualTo(userMapper.UsersEntityToCreateUserOutput(userEntity));
	}
	
	@Test
	public void createUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		CreateUserInput users = mock(CreateUserInput.class);
		
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.Create(users)).isEqualTo(null);
	}
	
	@Test
	public void createUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {

		CreateUserInput users = mock(CreateUserInput.class);
		
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.Create(users)).isEqualTo(null);
	}

    @Test
	public void createUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNullAndChildIsNotMandatory_StoreUsers() {

		UsersEntity usersEntity = mock(UsersEntity.class);
		CreateUserInput users = mock(CreateUserInput.class);
		
		users.setRoleId(null);
		
		Mockito.when(userMapper.CreateUserInputToUsersEntity(any(CreateUserInput.class))).thenReturn(usersEntity);
		Mockito.when(userManager.Create(any(UsersEntity.class))).thenReturn(usersEntity);
		Assertions.assertThat(userAppService.Create(users)).isEqualTo(userMapper.UsersEntityToCreateUserOutput(usersEntity));
	}
	
	@Test
	public void createUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_StoreUsers() {

		UsersEntity usersEntity = mock(UsersEntity.class);
		CreateUserInput users = mock(CreateUserInput.class);
		RolesEntity rolesEntity= mock(RolesEntity.class);
		usersEntity.setRole(rolesEntity);
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(rolesEntity);
		
		Mockito.when(userMapper.CreateUserInputToUsersEntity(any(CreateUserInput.class))).thenReturn(usersEntity);
		Mockito.when(userManager.Create(any(UsersEntity.class))).thenReturn(usersEntity);
		Assertions.assertThat(userAppService.Create(users)).isEqualTo(userMapper.UsersEntityToCreateUserOutput(usersEntity));
	}

	@Test
	public void deleteUser_UserIsNotNullAndUserExists_UserRemoved() {

		UsersEntity user=mock(UsersEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(user);
		userAppService.Delete(ID);
		verify(userManager).Delete(user);
	}
	
		@Test
	public void updateUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		UpdateUserInput users = mock(UpdateUserInput.class);
		
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.Update(ID,users)).isEqualTo(null);
	}
	
	@Test
	public void updateUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {

		UpdateUserInput users = mock(UpdateUserInput.class);
		
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.Update(ID,users)).isEqualTo(null);
	}

    @Test
	public void updateUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNullAndChildIsNotMandatory_ReturnUpdatedUsers() {

		UsersEntity usersEntity = mock(UsersEntity.class);
		UpdateUserInput users = mock(UpdateUserInput.class);
		
		users.setRoleId(null);
		
		Mockito.when(userMapper.UpdateUserInputToUsersEntity(any(UpdateUserInput.class))).thenReturn(usersEntity);
		Mockito.when(userManager.Update(any(UsersEntity.class))).thenReturn(usersEntity);
		Assertions.assertThat(userAppService.Update(ID,users)).isEqualTo(userMapper.UsersEntityToUpdateUserOutput(usersEntity));
	}
	
	@Test
	public void updateUsers_UsersIsNotNullAndUsersDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_ReturnUpdatedUsers() {

		UsersEntity usersEntity = mock(UsersEntity.class);
		UpdateUserInput users = mock(UpdateUserInput.class);
		RolesEntity rolesEntity= mock(RolesEntity.class);
		usersEntity.setRole(rolesEntity);
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(rolesEntity);
		
		Mockito.when(userMapper.UpdateUserInputToUsersEntity(any(UpdateUserInput.class))).thenReturn(usersEntity);
		Mockito.when(userManager.Update(any(UsersEntity.class))).thenReturn(usersEntity);
		Assertions.assertThat(userAppService.Update(ID,users)).isEqualTo(userMapper.UsersEntityToUpdateUserOutput(usersEntity));
	}
	
	@Test
	public void updateUser_UserIdIsNotNullAndUserExists_ReturnUpdatedUser() {

		UsersEntity userEntity = mock(UsersEntity.class);
		UpdateUserInput user=mock(UpdateUserInput.class);

		Mockito.when(userMapper.UpdateUserInputToUsersEntity(any(UpdateUserInput.class))).thenReturn(userEntity);
		Mockito.when(userManager.Update(any(UsersEntity.class))).thenReturn(userEntity);
		Assertions.assertThat(userAppService.Update(ID,user)).isEqualTo(userMapper.UsersEntityToUpdateUserOutput(userEntity));

	}

	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception
	{
		List<UsersEntity> list = new ArrayList<>();
		Page<UsersEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);

		List<FindUserByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");


		Mockito.when(userManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(userAppService.Find(search,pageable)).isEqualTo(output);

	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception
	{
		List<UsersEntity> list = new ArrayList<>();
		UsersEntity user=mock(UsersEntity.class);
		list.add(user);
		Page<UsersEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		List<FindUserByIdOutput> output = new ArrayList<>();
		output.add(userMapper.UsersEntityToFindUserByIdOutput(user));
		Mockito.when(userManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(userAppService.Find(search,pageable)).isEqualTo(output);

	}

	 //Roles
	@Test
	public void GetRoles_IfUsersIdAndRolesIdIsNotNullAndUsersExists_ReturnRoles() {
		UsersEntity users = mock(UsersEntity.class);
		RolesEntity roles = mock(RolesEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		Mockito.when(userManager.GetRoles(anyLong())).thenReturn(roles);
		Assertions.assertThat(userAppService.GetRoles(ID)).isEqualTo(userMapper.RolesEntityToGetRoleOutput(roles, users));
	}

	@Test 
	public void GetRoles_IfUsersIdAndRolesIdIsNotNullAndUsersDoesNotExist_ReturnNull() {
		UsersEntity users = mock(UsersEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.GetRoles(ID)).isEqualTo(null);
	}
    // Operations With Permissions
    
    @Test 
	public void AddPermissions_IfUsersIdAndPermissionsIdIsNotNullAndUsersAlreadyHasPermissions_ReturnFalse() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		permissions.addUser(users);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permissions);
		Mockito.when(userManager.AddPermissions(users, permissions)).thenReturn(false);
		Assertions.assertThat(userAppService.AddPermissions(ID, ID)).isEqualTo(false);
	}
	@Test
	public void AddPermissions_IfUsersIdAndPermissionsIdIsNotNullAndUsersExists_PermissionsGranted() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permissions);
		Mockito.when(userManager.AddPermissions(users, permissions)).thenReturn(true);
		Assertions.assertThat(userAppService.AddPermissions(ID, ID)).isEqualTo(true);
	}

	@Test
	public void RemovePermissions_IfUsersIdAndPermissionsIdIsNotNullAndUsersExists_PermissionsRemoved() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permissions);
		userAppService.RemovePermissions(ID,ID);
		verify(userManager).RemovePermissions(users, permissions);
	}

	@Test 
	public void GetPermissions_IfUsersIdAndPermissionsIdIsNotNullAndUsersDoesNotExist_ReturnNull() {

		Mockito.when(userManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.GetPermissions(ID, ID)).isEqualTo(null);
	}

	@Test 
	public void GetPermissions_IfUsersIdAndPermissionsIdIsNotNullAndPermissionsDoesNotExist_ReturnNull() {
		UsersEntity users = mock(UsersEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.GetPermissions(ID, ID)).isEqualTo(null);
	}

	@Test
	public void GetPermissions_IfUsersIdAndPermissionsIdIsNotNullAndUsersExists_ReturnPermissions() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);

		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permissions);
		Mockito.when(userManager.GetPermissions(anyLong(),anyLong())).thenReturn(permissions);
		Assertions.assertThat(userAppService.GetPermissions(ID, ID)).isEqualTo(userMapper.PermissionsEntityToGetPermissionOutput(permissions, users));		
	}
	
	@Test 
	public void GetPermissionsList_IfUsersIdIsNotNullAndUsersDoesNotExist_ReturnNull() throws Exception {
		String operator= "equals";
		SearchCriteria search = mock(SearchCriteria.class);
		Pageable pageable = mock(Pageable.class);
		
		Mockito.when(userManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(userAppService.GetPermissionsList(ID,search,operator,pageable)).isEqualTo(null);
	}
	
	@Test
	public void GetPermissionsList_IfUsersIdIsNotNullAndUsersExists_ReturnPermissions() throws Exception {
		UsersEntity users = mock(UsersEntity.class);
		String operator= "equals";
		SearchCriteria search = mock(SearchCriteria.class);
		Pageable pageable = mock(Pageable.class);
		List<PermissionsEntity> list = new ArrayList<>();
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		list.add(permissions);
		
    	Page<PermissionsEntity> foundPage = new PageImpl<>(list);
		List<GetPermissionOutput> output = new ArrayList<>();
		
		output.add(userMapper.PermissionsEntityToGetPermissionOutput(permissions,users));
		Mockito.when(userManager.FindById(anyLong())).thenReturn(users);
		doNothing().when(permissionsAppService).checkProperties(any(List.class));
		Mockito.when(userManager.FindPermissions(anyLong(),any(List.class),anyString(),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(userAppService.GetPermissionsList(ID,search,operator,pageable)).isEqualTo(output);
	}

    @Test 
	public void checkPermissionsProperties_SearchListIsNotNull_ReturnKeyValueMap()throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("displayName");
		list.add("name");
		permissionsAppService.checkProperties(list);
	}

	@Test
	public void  searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder()
	{
		String search= "xyz";
		String operator= "equals";
		QUsersEntity user = QUsersEntity.usersEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(user.firstName.eq(search));
		builder.or(user.lastName.eq(search));
		builder.or(user.emailAddress.eq(search));
		builder.or(user.userName.eq(search));
		builder.or(user.phoneNumber.eq(search));
		builder.or(user.authenticationSource.eq(search));


		Assertions.assertThat(userAppService.searchAllProperties(user,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() throws Exception
	{
		String operator= "equals";
		List<String> list = new ArrayList<>();
		list.add("firstName");
		list.add("userName");
		
		QUsersEntity user = QUsersEntity.usersEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(user.firstName.eq("xyz"));
		builder.or(user.userName.eq("xyz"));

		Assertions.assertThat(userAppService.searchSpecificProperty(user,list,"xyz",operator)).isEqualTo(builder);

	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder()
	{
		QUsersEntity user = QUsersEntity.usersEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
	    Map map = new HashMap();
        map.put("firstName",searchFields);
        BooleanBuilder builder = new BooleanBuilder();
        builder.and(user.firstName.eq("xyz"));
        
        Assertions.assertThat(userAppService.searchKeyValuePair(user, map,"xyz",ID)).isEqualTo(builder);
	}

	@Test(expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("first");

		userAppService.checkProperties(list);
	}
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("firstName");

		userAppService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception
	{
		QUsersEntity user = QUsersEntity.usersEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
        BooleanBuilder builder = new BooleanBuilder();
        builder.or(user.firstName.eq("xyz"));
    	builder.or(user.lastName.eq("xyz"));
		builder.or(user.emailAddress.eq("xyz"));
		builder.or(user.userName.eq("xyz"));
		builder.or(user.phoneNumber.eq("xyz"));
		builder.or(user.authenticationSource.eq("xyz"));
        Assertions.assertThat(userAppService.Search(search)).isEqualTo(builder);
        
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception
	{
		QUsersEntity user = QUsersEntity.usersEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
		fields.setFieldName("firstName");
        fieldsList.add(fields);
        search.setFields(fieldsList);
    	BooleanBuilder builder = new BooleanBuilder();
		builder.or(user.firstName.eq("xyz"));

        Assertions.assertThat(userAppService.Search(search)).isEqualTo(builder);
	}
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception
	{
		Map<String,SearchFields> map = new HashMap<>();
		QUsersEntity user = QUsersEntity.usersEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		fields.setFieldName("firstName");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
    	BooleanBuilder builder = new BooleanBuilder();
    	builder.or(user.firstName.eq("xyz"));
    	
        Assertions.assertThat(userAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_StringIsNull_ReturnNull() throws Exception
	{
		 Assertions.assertThat(userAppService.Search(null)).isEqualTo(null);
	}


}
