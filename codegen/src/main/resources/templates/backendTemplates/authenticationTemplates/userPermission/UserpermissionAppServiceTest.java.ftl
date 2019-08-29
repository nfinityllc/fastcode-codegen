package [=PackageName].application.Authorization.[=AuthenticationTable]permission;

import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.doNothing;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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

import [=PackageName].domain.Authorization.Userpermission.*;
import [=CommonModulePackage].Search.*;
import [=PackageName].application.Authorization.Userpermission.Dto.*;
import [=PackageName].domain.model.QUserpermissionEntity;
import [=PackageName].domain.model.UserpermissionEntity;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.Authorization.User.UserManager;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.Authorization.Permission.PermissionManager;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=AuthenticationTable]permissionAppServiceTest {

	@InjectMocks
	UserpermissionAppService _appService;

	@Mock
	private UserpermissionManager _userpermissionManager;
	
    @Mock
	private UserManager  _userManager;
	
    @Mock
	private PermissionManager  _permissionManager;
	
	@Mock
	private UserpermissionMapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;
	@Before
	public void setUp() throws Exception {

		MockitoAnnotations.initMocks(_appService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}
	
	@After
	public void tearDown() throws Exception {
	}
	
//	@Test
//	public void findUserpermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
//
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.FindById(ID)).isEqualTo(null);
//	}
//	
//	@Test
//	public void findUserpermissionById_IdIsNotNullAndIdExists_ReturnUserpermission() {
//
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(userpermission);
//		Assertions.assertThat(_appService.FindById(ID)).isEqualTo(_mapper.UserpermissionEntityToFindUserpermissionByIdOutput(userpermission));
//	}
	
//	 @Test 
//    public void createUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExist_StoreUserpermission() { 
// 
//       UserpermissionEntity userpermissionEntity = mock(UserpermissionEntity.class); 
//        CreateUserpermissionInput userpermission = mock(CreateUserpermissionInput.class); 
//        Mockito.when(_mapper.CreateUserpermissionInputToUserpermissionEntity(any(CreateUserpermissionInput.class))).thenReturn(userpermissionEntity); 
//        Mockito.when(_userpermissionManager.Create(any(UserpermissionEntity.class))).thenReturn(userpermissionEntity); 
//        Assertions.assertThat(_appService.Create(userpermission)).isEqualTo(_mapper.UserpermissionEntityToCreateUserpermissionOutput(userpermissionEntity)); 
//    } 

//	@Test
//	public void createUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {
//
//		CreateUserpermissionInput userpermission = mock(CreateUserpermissionInput.class);
//		
//		Mockito.when(_userManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Create(userpermission)).isEqualTo(null);
//	}
	
//	@Test
//	public void createUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
//
//		CreateUserpermissionInput userpermission = mock(CreateUserpermissionInput.class);
//		
//		Mockito.when(_userManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Create(userpermission)).isEqualTo(null);
//	}
//
//   @Test
//	public void createUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNullAndChildIsNotMandatory_StoreUserpermission() {
//
//		UserpermissionEntity userpermissionEntity = mock(UserpermissionEntity.class);
//		CreateUserpermissionInput userpermission = mock(CreateUserpermissionInput.class);
//		
//		Mockito.when(_mapper.CreateUserpermissionInputToUserpermissionEntity(any(CreateUserpermissionInput.class))).thenReturn(userpermissionEntity);
//		Mockito.when(_userpermissionManager.Create(any(UserpermissionEntity.class))).thenReturn(userpermissionEntity);
//		Assertions.assertThat(_appService.Create(userpermission)).isEqualTo(_mapper.UserpermissionEntityToCreateUserpermissionOutput(userpermissionEntity));
//	}
	
//	@Test
//	public void createUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_StoreUserpermission() {
//
//		UserpermissionEntity userpermissionEntity = mock(UserpermissionEntity.class);
//		CreateUserpermissionInput userpermission = mock(CreateUserpermissionInput.class);
//		UserEntity userEntity= mock(UserEntity.class);
//		userpermissionEntity.setUser(userEntity);
//		Mockito.when(_userManager.FindById(anyLong())).thenReturn(userEntity);
//		
//		Mockito.when(_mapper.CreateUserpermissionInputToUserpermissionEntity(any(CreateUserpermissionInput.class))).thenReturn(userpermissionEntity);
//		Mockito.when(_userpermissionManager.Create(any(UserpermissionEntity.class))).thenReturn(userpermissionEntity);
//		Assertions.assertThat(_appService.Create(userpermission)).isEqualTo(_mapper.UserpermissionEntityToCreateUserpermissionOutput(userpermissionEntity));
//	}

//	@Test
//	public void updateUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {
//
//		UpdateUserpermissionInput userpermission = mock(UpdateUserpermissionInput.class);
//		
//		Mockito.when(_userManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Update(ID,userpermission)).isEqualTo(null);
//	}
	
//	@Test
//	public void updateUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
//
//		UpdateUserpermissionInput userpermission = mock(UpdateUserpermissionInput.class);
//		
//		Mockito.when(_userManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Update(ID,userpermission)).isEqualTo(null);
//	}

//   @Test
//	public void updateUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNullAndChildIsNotMandatory_ReturnUpdatedUserpermission() {
//
//		UserpermissionEntity userpermissionEntity = mock(UserpermissionEntity.class);
//		UpdateUserpermissionInput userpermission = mock(UpdateUserpermissionInput.class);
//		
//		Mockito.when(_mapper.UpdateUserpermissionInputToUserpermissionEntity(any(UpdateUserpermissionInput.class))).thenReturn(userpermissionEntity);
//		Mockito.when(_userpermissionManager.Update(any(UserpermissionEntity.class))).thenReturn(userpermissionEntity);
//		Assertions.assertThat(_appService.Update(ID,userpermission)).isEqualTo(_mapper.UserpermissionEntityToUpdateUserpermissionOutput(userpermissionEntity));
//	}
//	
//	@Test
//	public void updateUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_ReturnUpdatedUserpermission() {
//
//		UserpermissionEntity userpermissionEntity = mock(UserpermissionEntity.class);
//		UpdateUserpermissionInput userpermission = mock(UpdateUserpermissionInput.class);
//		UserEntity userEntity= mock(UserEntity.class);
//		userpermissionEntity.setUser(userEntity);
//		Mockito.when(_userManager.FindById(anyLong())).thenReturn(userEntity);
//		
//		Mockito.when(_mapper.UpdateUserpermissionInputToUserpermissionEntity(any(UpdateUserpermissionInput.class))).thenReturn(userpermissionEntity);
//		Mockito.when(_userpermissionManager.Update(any(UserpermissionEntity.class))).thenReturn(userpermissionEntity);
//		Assertions.assertThat(_appService.Update(ID,userpermission)).isEqualTo(_mapper.UserpermissionEntityToUpdateUserpermissionOutput(userpermissionEntity));
//	}
		
//	@Test
//	public void updateUserpermission_UserpermissionIdIsNotNullAndIdExists_ReturnUpdatedUserpermission() {
//
//		UserpermissionEntity userpermissionEntity = mock(UserpermissionEntity.class);
//		UpdateUserpermissionInput userpermission= mock(UpdateUserpermissionInput.class);
//		Mockito.when(_mapper.UpdateUserpermissionInputToUserpermissionEntity(any(UpdateUserpermissionInput.class))).thenReturn(userpermissionEntity);
//		Mockito.when(_userpermissionManager.Update(any(UserpermissionEntity.class))).thenReturn(userpermissionEntity);
//		Assertions.assertThat(_appService.Update(ID,userpermission)).isEqualTo(_mapper.UserpermissionEntityToUpdateUserpermissionOutput(userpermissionEntity));
//	}
    
//	@Test
//	public void deleteUserpermission_UserpermissionIsNotNullAndUserpermissionExists_UserpermissionRemoved() {
//
//		UserpermissionEntity userpermission= mock(UserpermissionEntity.class);
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(userpermission);
//		_appService.Delete(ID); 
//		verify(_userpermissionManager).Delete(userpermission);
//	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<UserpermissionEntity> list = new ArrayList<>();
		Page<UserpermissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindUserpermissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_userpermissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<UserpermissionEntity> list = new ArrayList<>();
		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
		list.add(userpermission);
    	Page<UserpermissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindUserpermissionByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.UserpermissionEntityToFindUserpermissionByIdOutput(userpermission));
    	Mockito.when(_userpermissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		QUserpermissionEntity userpermission = QUserpermissionEntity.userpermissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchAllProperties(userpermission,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
		QUserpermissionEntity userpermission = QUserpermissionEntity.userpermissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchSpecificProperty(userpermission, list,"xyz",operator)).isEqualTo(builder);
	}
	
//	@Test
//	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
//		QUserpermissionEntity userpermission = QUserpermissionEntity.userpermissionEntity;
//	    SearchFields searchFields = new SearchFields();
//		searchFields.setOperator("equals");
//		searchFields.setSearchValue("xyz");
//	    Map map = new HashMap();
//	    		
//		BooleanBuilder builder = new BooleanBuilder();
//		
//		Assertions.assertThat(_appService.searchKeyValuePair(userpermission,map,"xyz",ID)).isEqualTo(builder);
//	}
	
	@Test (expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception {
		List<String> list = new ArrayList<>();
		list.add("xyz");
		_appService.checkProperties(list);
	}
	
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception {
		List<String> list = new ArrayList<>();
		_appService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception {

		QUserpermissionEntity userpermission = QUserpermissionEntity.userpermissionEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		QUserpermissionEntity userpermission = QUserpermissionEntity.userpermissionEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
//	@Test
//	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
//
//		Map<String,SearchFields> map = new HashMap<>();
//		QUserpermissionEntity userpermission = QUserpermissionEntity.userpermissionEntity;
//		List<SearchFields> fieldsList= new ArrayList<>();
//		SearchFields fields=new SearchFields();
//		SearchCriteria search= new SearchCriteria();
//		search.setType(3);
//		search.setValue("xyz");
//		search.setOperator("equals");
//		
//        fields.setOperator("equals");
//		fields.setSearchValue("xyz");
//        fieldsList.add(fields);
//        search.setFields(fieldsList);
//		BooleanBuilder builder = new BooleanBuilder();
//		
//		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
//	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
//   //User
//	@Test
//	public void GetUser_IfUserpermissionIdAndUserIdIsNotNullAndUserpermissionExists_ReturnUser() {
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//		UserEntity user = mock(UserEntity.class);
//
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(userpermission);
//		Mockito.when(_userpermissionManager.GetUser(anyLong())).thenReturn(user);
//		Assertions.assertThat(_appService.GetUser(ID)).isEqualTo(_mapper.UserEntityToGetUserOutput(user, userpermission));
//	}
//
//	@Test 
//	public void GetUser_IfUserpermissionIdAndUserIdIsNotNullAndUserpermissionDoesNotExist_ReturnNull() {
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.GetUser(ID)).isEqualTo(null);
//	}
 
//   //Permission
//	@Test
//	public void GetPermission_IfUserpermissionIdAndPermissionIdIsNotNullAndUserpermissionExists_ReturnPermission() {
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//		PermissionEntity permission = mock(PermissionEntity.class);
//
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(userpermission);
//		Mockito.when(_userpermissionManager.GetPermission(anyLong())).thenReturn(permission);
//		Assertions.assertThat(_appService.GetPermission(ID)).isEqualTo(_mapper.PermissionEntityToGetPermissionOutput(permission, userpermission));
//	}
//
//	@Test 
//	public void GetPermission_IfUserpermissionIdAndPermissionIdIsNotNullAndUserpermissionDoesNotExist_ReturnNull() {
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//
//		Mockito.when(_userpermissionManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.GetPermission(ID)).isEqualTo(null);
//	}
 

}

