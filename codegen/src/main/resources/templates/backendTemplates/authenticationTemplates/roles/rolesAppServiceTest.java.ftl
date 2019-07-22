package [=PackageName].application.Authorization.Roles;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].application.Authorization.Roles.Dto.*;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Permissions.PermissionsManager;
import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.Authorization.Roles.RolesManager;
import [=PackageName].domain.model.QRolesEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class RoleAppServiceTest {

	@InjectMocks
	RoleAppService roleAppService;

	@Mock
	private RolesManager roleManager;

	@Mock
	PermissionsManager permissionManager;

	@Mock
	private RoleMapper roleMapper;
	
	@Mock
	private PermissionAppService  permissionsAppService;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(roleAppService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

	}

	@After
	public void tearDown() throws Exception {
	}

	@Test 
	public void findRoleById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);	
		Assertions.assertThat(roleAppService.FindById(ID)).isEqualTo(null);	

	}

	@Test
	public void findRoleById_IdIsNotNullAndRoleExists_ReturnARole() {

		RolesEntity role = mock(RolesEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		Assertions.assertThat(roleAppService.FindById(ID)).isEqualTo(roleMapper.RolesEntityToCreateRoleOutput(role));
	}

	@Test 
	public void findRoleByName_NameIsNotNullAndRoleDoesNotExist_ReturnNull() {

		Mockito.when(roleManager.FindByRoleName(anyString())).thenReturn(null);	
		Assertions.assertThat(roleAppService.FindByRoleName("Role1")).isEqualTo(null);	

	}

	@Test
	public void findRoleByName_NameIsNotNullAndRoleExists_ReturnARole() {

		RolesEntity role = mock(RolesEntity.class);

		Mockito.when(roleManager.FindByRoleName(anyString())).thenReturn(role);
		Assertions.assertThat(roleAppService.FindByRoleName("Role1")).isEqualTo(roleMapper.RolesEntityToCreateRoleOutput(role));
	}


	@Test
	public void createRole_RoleIsNotNullAndRoleDoesNotExist_StoreARole() {

		RolesEntity roleEntity = mock(RolesEntity.class);
		CreateRoleInput role=mock(CreateRoleInput.class);

		Mockito.when(roleMapper.CreateRoleInputToRolesEntity(any(CreateRoleInput.class))).thenReturn(roleEntity);
		Mockito.when(roleManager.Create(any(RolesEntity.class))).thenReturn(roleEntity);
		Assertions.assertThat(roleAppService.Create(role)).isEqualTo(roleMapper.RolesEntityToCreateRoleOutput(roleEntity));
	}

	@Test
	public void deleteRole_RoleIsNotNullAndRoleExists_RoleRemoved() {

		RolesEntity role=mock(RolesEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		roleAppService.Delete(ID);
		verify(roleManager).Delete(role);
	}

	@Test
	public void updateRole_RoleIdIsNotNullAndRoleExists_ReturnUpdatedRole() {

		RolesEntity roleEntity = mock(RolesEntity.class);
		UpdateRoleInput role=mock(UpdateRoleInput.class);

		Mockito.when(roleMapper.UpdateRoleInputToRolesEntity(any(UpdateRoleInput.class))).thenReturn(roleEntity);
		Mockito.when(roleManager.Update(any(RolesEntity.class))).thenReturn(roleEntity);
		Assertions.assertThat(roleAppService.Update(ID,role)).isEqualTo(roleMapper.RolesEntityToUpdateRoleOutput(roleEntity));

	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception
	{
		List<RolesEntity> list = new ArrayList<>();
		Page<RolesEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);

		List<FindRoleByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(roleManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(roleAppService.Find(search,pageable)).isEqualTo(output);

	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception
	{
		List<RolesEntity> list = new ArrayList<>();
		RolesEntity role=mock(RolesEntity.class);
		list.add(role);
		Page<RolesEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		List<FindRoleByIdOutput> output = new ArrayList<>();
		output.add(roleMapper.RolesEntityToFindRoleByIdOutput(role));
		Mockito.when(roleManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(roleAppService.Find(search,pageable)).isEqualTo(output);

	}

	@Test 
	public void AddPermission_IfRoleIdAndPermissionIdIsNotNullAndRoleAlreadyHasPermission_ReturnFalse() {
		RolesEntity role = mock(RolesEntity.class);
		PermissionsEntity permission = mock(PermissionsEntity.class);
//		permission.addRole(role);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permission);
		Mockito.when(roleManager.AddPermission(role, permission)).thenReturn(false);
		Assertions.assertThat(roleAppService.AddPermission(ID, ID)).isEqualTo(false);
	}

	@Test
	public void AddPermission_IfRoleIdAndPermissionIdIsNotNullAndRoleExists_PermissionGranted() {
		RolesEntity role = mock(RolesEntity.class);
		PermissionsEntity permission = mock(PermissionsEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permission);
		Mockito.when(roleManager.AddPermission(role, permission)).thenReturn(true);
		Assertions.assertThat(roleAppService.AddPermission(ID, ID)).isEqualTo(true);

	}

	@Test
	public void RemovePermission_IfRoleIdAndPermissionIdIsNotNullAndRoleExists_PermissionRemoved() {
		RolesEntity role = mock(RolesEntity.class);
		PermissionsEntity permission = mock(PermissionsEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permission);
		roleAppService.RemovePermission(ID,ID);
		verify(roleManager).RemovePermission(role, permission);
	}

	@Test 
	public void GetPermissions_IfRolesIdAndPermissionsIdIsNotNullAndRolesDoesNotExist_ReturnNull() {

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(roleAppService.GetPermissions(ID, ID)).isEqualTo(null);
	}

	@Test 
	public void GetPermissions_IfRolesIdAndPermissionsIdIsNotNullAndPermissionsDoesNotExist_ReturnNull() {
		RolesEntity roles = mock(RolesEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(roles);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(roleAppService.GetPermissions(ID, ID)).isEqualTo(null);
	}

	@Test
	public void GetPermissions_IfRolesIdAndPermissionsIdIsNotNullAndRolesExists_ReturnPermissions() {
		RolesEntity roles = mock(RolesEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(roles);
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permissions);
		Mockito.when(roleManager.GetPermissions(anyLong(),anyLong())).thenReturn(permissions);
		Assertions.assertThat(roleAppService.GetPermissions(ID, ID)).isEqualTo(roleMapper.PermissionsEntityToGetPermissionOutput(permissions, roles));		
	}
	
	@Test 
	public void GetPermissionsList_IfRolesIdIsNotNullAndRolesDoesNotExist_ReturnNull() throws Exception {
		String operator= "equals";
		SearchCriteria search = mock(SearchCriteria.class);
		Pageable pageable = mock(Pageable.class);
		
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(roleAppService.GetPermissionsList(ID,search,operator,pageable)).isEqualTo(null);
	}
	
	@Test
	public void GetPermissionsList_IfRolesIdIsNotNullAndRolesExists_ReturnPermissions() throws Exception {
		RolesEntity roles = mock(RolesEntity.class);
		String operator= "equals";
		SearchCriteria search = mock(SearchCriteria.class);
		Pageable pageable = mock(Pageable.class);
		List<PermissionsEntity> list = new ArrayList<>();
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		list.add(permissions);
		
    	Page<PermissionsEntity> foundPage = new PageImpl<>(list);
		List<GetPermissionOutput> output = new ArrayList<>();
		
		output.add(roleMapper.PermissionsEntityToGetPermissionOutput(permissions,roles));
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(roles);
		doNothing().when(permissionsAppService).checkProperties(any(List.class));
		Mockito.when(roleManager.FindPermissions(anyLong(),any(List.class),anyString(),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(roleAppService.GetPermissionsList(ID,search,operator,pageable)).isEqualTo(output);
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
		QRolesEntity role = QRolesEntity.rolesEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq(search));
		builder.or(role.name.eq(search));


		Assertions.assertThat(roleAppService.searchAllProperties(role,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() throws Exception
	{
		String operator= "equals";
		List<String> list = new ArrayList<>();
		list.add("name");
		list.add("displayName");
		QRolesEntity role = QRolesEntity.rolesEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.name.eq("xyz"));
		builder.or(role.displayName.eq("xyz"));

		Assertions.assertThat(roleAppService.searchSpecificProperty(role,list,"xyz",operator)).isEqualTo(builder);

	}

	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder()
	{
		QRolesEntity role = QRolesEntity.rolesEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
		Map map = new HashMap();
		map.put("name", searchFields);

		BooleanBuilder builder = new BooleanBuilder();
		builder.and(role.name.eq("xyz"));


		Assertions.assertThat(roleAppService.searchKeyValuePair(role, map,"xyz",ID)).isEqualTo(builder);
	}

	@Test(expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("xyz");

		roleAppService.checkProperties(list);
	}
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("displayName");

		roleAppService.checkProperties(list);
	}

	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception
	{
		QRolesEntity role = QRolesEntity.rolesEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq("xyz"));
		builder.or(role.name.eq("xyz"));

		Assertions.assertThat(roleAppService.Search(search)).isEqualTo(builder);

	}

	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception
	{
		QRolesEntity role = QRolesEntity.rolesEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
		fields.setFieldName("displayName");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq("xyz"));

		Assertions.assertThat(roleAppService.Search(search)).isEqualTo(builder);

	}
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception
	{
		Map<String,SearchFields> map = new HashMap<>();
		QRolesEntity role = QRolesEntity.rolesEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		fields.setFieldName("displayName");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq("xyz"));

		Assertions.assertThat(roleAppService.Search(search)).isEqualTo(builder);

	}

	@Test
	public void search_StringIsNull_ReturnNull() throws Exception
	{
		Assertions.assertThat(roleAppService.Search(null)).isEqualTo(null);
	}


}
