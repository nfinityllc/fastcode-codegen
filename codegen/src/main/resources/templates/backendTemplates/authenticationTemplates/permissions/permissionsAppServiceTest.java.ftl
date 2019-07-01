package [=PackageName].application.Authorization.Permissions;

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
import [=PackageName].application.Authorization.Permissions.Dto.CreatePermissionInput;
import [=PackageName].application.Authorization.Permissions.Dto.FindPermissionByIdOutput;
import [=PackageName].application.Authorization.Permissions.Dto.UpdatePermissionInput;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Permissions.PermissionsManager;
import [=PackageName].domain.model.QPermissionsEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class PermissionAppServiceTest {

	@InjectMocks
	PermissionAppService permissionAppService;
	
	@Mock
	private PermissionsManager permissionsManager;
	
	@Mock
	private PermissionMapper permissionMapper;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(permissionAppService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test 
	public void findPermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
		
		Mockito.when(permissionsManager.FindById(anyLong())).thenReturn(null);	
		Assertions.assertThat(permissionAppService.FindById(ID)).isEqualTo(null);	
	}

	@Test
	public void findPermissionById_IdIsNotNullAndPermissionExists_ReturnAPermission() {

		PermissionsEntity permission = mock(PermissionsEntity.class);

		Mockito.when(permissionsManager.FindById(anyLong())).thenReturn(permission);
		Assertions.assertThat(permissionAppService.FindById(ID)).isEqualTo(permissionMapper.PermissionsEntityToCreatePermissionOutput(permission));
	}

	@Test 
	public void findPermissionByName_NameIsNotNullAndPermissionDoesNotExist_ReturnNull() {
		
		Mockito.when(permissionsManager.FindByPermissionName(anyString())).thenReturn(null);	
		Assertions.assertThat(permissionAppService.FindByPermissionName("Permission1")).isEqualTo(null);	
	}

	@Test
	public void findPermissionByName_NameIsNotNullAndPermissionExists_ReturnAPermission() {

		PermissionsEntity permission = mock(PermissionsEntity.class);

		Mockito.when(permissionsManager.FindByPermissionName(anyString())).thenReturn(permission);
		Assertions.assertThat(permissionAppService.FindByPermissionName("Permission1")).isEqualTo(permissionMapper.PermissionsEntityToCreatePermissionOutput(permission));
	}


	@Test
	public void createPermission_PermissionIsNotNullAndPermissionDoesNotExist_StoreAPermission() {

		PermissionsEntity permissionsEntity = mock(PermissionsEntity.class);
		CreatePermissionInput permission=mock(CreatePermissionInput.class);

		Mockito.when(permissionMapper.CreatePermissionInputToPermissionsEntity(any(CreatePermissionInput.class))).thenReturn(permissionsEntity);
		Mockito.when(permissionsManager.Create(any(PermissionsEntity.class))).thenReturn(permissionsEntity);
		Assertions.assertThat(permissionAppService.Create(permission)).isEqualTo(permissionMapper.PermissionsEntityToCreatePermissionOutput(permissionsEntity));
	}

	@Test
	public void deletePermission_PermissionIsNotNullAndPermissionExists_PermissionRemoved() {

		PermissionsEntity permission = mock(PermissionsEntity.class);

		Mockito.when(permissionsManager.FindById(anyLong())).thenReturn(permission);
		permissionAppService.Delete(ID);
		verify(permissionsManager).Delete(permission);
	}


	@Test
	public void updatePermission_PermissionIdIsNotNullAndPermissionExists_ReturnUpdatedPermission() {

		PermissionsEntity permissionsEntity = mock(PermissionsEntity.class);
		UpdatePermissionInput permission=mock(UpdatePermissionInput.class);

		Mockito.when(permissionMapper.UpdatePermissionInputToPermissionsEntity(any(UpdatePermissionInput.class))).thenReturn(permissionsEntity);
		Mockito.when(permissionsManager.Update(any(PermissionsEntity.class))).thenReturn(permissionsEntity);
		Assertions.assertThat(permissionAppService.Update(ID,permission)).isEqualTo(permissionMapper.PermissionsEntityToUpdatePermissionOutput(permissionsEntity));
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception
	{
		List<PermissionsEntity> list = new ArrayList<>();
		Page<PermissionsEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);

		List<FindPermissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(permissionsManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(permissionAppService.Find(search,pageable)).isEqualTo(output);
	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception
	{
		List<PermissionsEntity> list = new ArrayList<>();
		PermissionsEntity permission=mock(PermissionsEntity.class);
		list.add(permission);
		Page<PermissionsEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		List<FindPermissionByIdOutput> output = new ArrayList<>();
		output.add(permissionMapper.PermissionsEntityToFindPermissionByIdOutput(permission));
		Mockito.when(permissionsManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(permissionAppService.Find(search,pageable)).isEqualTo(output);
	}
	
	@Test
	public void  searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder()
	{
		String search= "xyz";
		String operator= "equals";
		QPermissionsEntity permission = QPermissionsEntity.permissionsEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(permission.displayName.eq(search));
		builder.or(permission.name.eq(search));

		Assertions.assertThat(permissionAppService.searchAllProperties(permission,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() throws Exception
	{
		String operator= "equals";
		List<String> list = new ArrayList<>();
		list.add("name");
		list.add("displayName");
		QPermissionsEntity permission = QPermissionsEntity.permissionsEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(permission.name.eq("xyz"));
		builder.or(permission.displayName.eq("xyz"));

		Assertions.assertThat(permissionAppService.searchSpecificProperty(permission,list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder()
	{
		QPermissionsEntity permission = QPermissionsEntity.permissionsEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
		Map map = new HashMap();
		map.put("name", searchFields);
		
        BooleanBuilder builder = new BooleanBuilder();
        builder.and(permission.name.eq("xyz"));
        
        Assertions.assertThat(permissionAppService.searchKeyValuePair(permission, map,"xyz",ID)).isEqualTo(builder);
	}

	@Test(expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("xyz");

		permissionAppService.checkProperties(list);
	}
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("displayName");

		permissionAppService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception
	{
		QPermissionsEntity permission = QPermissionsEntity.permissionsEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
        BooleanBuilder builder = new BooleanBuilder();
        builder.or(permission.displayName.eq("xyz"));
		builder.or(permission.name.eq("xyz"));

        Assertions.assertThat(permissionAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception
	{
		QPermissionsEntity permission = QPermissionsEntity.permissionsEntity;
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
    	builder.or(permission.displayName.eq("xyz"));
    	
        Assertions.assertThat(permissionAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception
	{
		Map<String,SearchFields> map = new HashMap<>();List<SearchFields> fieldsList= new ArrayList<>();
		QPermissionsEntity permission = QPermissionsEntity.permissionsEntity;
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		fields.setFieldName("displayName");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
	
    	BooleanBuilder builder = new BooleanBuilder();
    	builder.or(permission.displayName.eq("xyz"));
    	
        Assertions.assertThat(permissionAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_StringIsNull_ReturnNull() throws Exception
	{
		 Assertions.assertThat(permissionAppService.Search(null)).isEqualTo(null);
	}
	
}
