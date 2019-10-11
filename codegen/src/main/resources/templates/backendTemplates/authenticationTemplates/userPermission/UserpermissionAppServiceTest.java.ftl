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

import [=PackageName].domain.Authorization.[=AuthenticationTable]permission.*;
import [=CommonModulePackage].Search.*;
import [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto.*;
import [=PackageName].domain.model.Q[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.Authorization.[=AuthenticationTable].[=AuthenticationTable]Manager;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.Authorization.Permission.PermissionManager;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=AuthenticationTable]permissionAppServiceTest {

	@InjectMocks
	[=AuthenticationTable]permissionAppService _appService;

	@Mock
	private [=AuthenticationTable]permissionManager _[=AuthenticationTable?uncap_first]permissionManager;
	
    @Mock
	private [=AuthenticationTable]Manager  _[=AuthenticationTable?uncap_first]Manager;
	
    @Mock
	private PermissionManager  _permissionManager;
	
	@Mock
	private [=AuthenticationTable]permissionMapper _mapper;

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
//	public void find[=AuthenticationTable]permissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
//
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.FindById(ID)).isEqualTo(null);
//	}
//	
//	@Test
//	public void find[=AuthenticationTable]permissionById_IdIsNotNullAndIdExists_Return[=AuthenticationTable]permission() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn([=AuthenticationTable?uncap_first]permission);
//		Assertions.assertThat(_appService.FindById(ID)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable?uncap_first]permission));
//	}
	
//	 @Test 
//    public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_Store[=AuthenticationTable]permission() { 
// 
//       [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = mock([=AuthenticationTable]permissionEntity.class); 
//        Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class); 
//        Mockito.when(_mapper.Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Create[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity); 
//        Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Create(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity); 
//        Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity)); 
//    } 

//	@Test
//	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {
//
//		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class);
//		
//		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
//	}
	
//	@Test
//	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
//
//		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class);
//		
//		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
//	}
//
//   @Test
//	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNullAndChildIsNotMandatory_Store[=AuthenticationTable]permission() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = mock([=AuthenticationTable]permissionEntity.class);
//		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class);
//		
//		Mockito.when(_mapper.Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Create[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Create(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity));
//	}
	
//	@Test
//	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_Store[=AuthenticationTable]permission() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = mock([=AuthenticationTable]permissionEntity.class);
//		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class);
//		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity= mock([=AuthenticationTable]Entity.class);
//		[=AuthenticationTable?uncap_first]permissionEntity.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]Entity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(anyLong())).thenReturn([=AuthenticationTable?uncap_first]Entity);
//		
//		Mockito.when(_mapper.Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Create[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Create(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity));
//	}

//	@Test
//	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {
//
//		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Update[=AuthenticationTable]permissionInput.class);
//		
//		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Update(ID,[=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
//	}
	
//	@Test
//	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
//
//		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Update[=AuthenticationTable]permissionInput.class);
//		
//		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Update(ID,[=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
//	}

//   @Test
//	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNullAndChildIsNotMandatory_ReturnUpdated[=AuthenticationTable]permission() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = mock([=AuthenticationTable]permissionEntity.class);
//		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Update[=AuthenticationTable]permissionInput.class);
//		
//		Mockito.when(_mapper.Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Update[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Update(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Assertions.assertThat(_appService.Update(ID,[=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity));
//	}
//	
//	@Test
//	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_ReturnUpdated[=AuthenticationTable]permission() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = mock([=AuthenticationTable]permissionEntity.class);
//		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Update[=AuthenticationTable]permissionInput.class);
//		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity= mock([=AuthenticationTable]Entity.class);
//		[=AuthenticationTable?uncap_first]permissionEntity.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]Entity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(anyLong())).thenReturn([=AuthenticationTable?uncap_first]Entity);
//		
//		Mockito.when(_mapper.Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Update[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Update(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Assertions.assertThat(_appService.Update(ID,[=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity));
//	}
		
//	@Test
//	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIdIsNotNullAndIdExists_ReturnUpdated[=AuthenticationTable]permission() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = mock([=AuthenticationTable]permissionEntity.class);
//		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission= mock(Update[=AuthenticationTable]permissionInput.class);
//		Mockito.when(_mapper.Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Update[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Update(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
//		Assertions.assertThat(_appService.Update(ID,[=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity));
//	}
    
//	@Test
//	public void delete[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionExists_[=AuthenticationTable]permissionRemoved() {
//
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission= mock([=AuthenticationTable]permissionEntity.class);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn([=AuthenticationTable?uncap_first]permission);
//		_appService.Delete(ID); 
//		verify(_[=AuthenticationTable?uncap_first]permissionManager).Delete([=AuthenticationTable?uncap_first]permission);
//	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<[=AuthenticationTable]permissionEntity> list = new ArrayList<>();
		Page<[=AuthenticationTable]permissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=AuthenticationTable]permissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<[=AuthenticationTable]permissionEntity> list = new ArrayList<>();
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		list.add([=AuthenticationTable?uncap_first]permission);
    	Page<[=AuthenticationTable]permissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=AuthenticationTable]permissionByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.[=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable?uncap_first]permission));
    	Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchAllProperties([=AuthenticationTable?uncap_first]permission,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchSpecificProperty([=AuthenticationTable?uncap_first]permission, list,"xyz",operator)).isEqualTo(builder);
	}
	
//	@Test
//	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
//		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
//	    SearchFields searchFields = new SearchFields();
//		searchFields.setOperator("equals");
//		searchFields.setSearchValue("xyz");
//	    Map map = new HashMap();
//	    		
//		BooleanBuilder builder = new BooleanBuilder();
//		
//		Assertions.assertThat(_appService.searchKeyValuePair([=AuthenticationTable?uncap_first]permission,map,"xyz",ID)).isEqualTo(builder);
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

		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
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
//		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
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
	
//   //[=AuthenticationTable]
//	@Test
//	public void Get[=AuthenticationTable]_If[=AuthenticationTable]permissionIdAnd[=AuthenticationTable]IdIsNotNullAnd[=AuthenticationTable]permissionExists_Return[=AuthenticationTable]() {
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
//		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = mock([=AuthenticationTable]Entity.class);
//
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn([=AuthenticationTable?uncap_first]permission);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Get[=AuthenticationTable](anyLong())).thenReturn([=AuthenticationTable?uncap_first]);
//		Assertions.assertThat(_appService.Get[=AuthenticationTable](ID)).isEqualTo(_mapper.[=AuthenticationTable]EntityToGet[=AuthenticationTable]Output([=AuthenticationTable?uncap_first], [=AuthenticationTable?uncap_first]permission));
//	}
//
//	@Test 
//	public void Get[=AuthenticationTable]_If[=AuthenticationTable]permissionIdAnd[=AuthenticationTable]IdIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_ReturnNull() {
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
//
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.Get[=AuthenticationTable](ID)).isEqualTo(null);
//	}
 
//   //Permission
//	@Test
//	public void GetPermission_If[=AuthenticationTable]permissionIdAndPermissionIdIsNotNullAnd[=AuthenticationTable]permissionExists_ReturnPermission() {
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
//		PermissionEntity permission = mock(PermissionEntity.class);
//
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn([=AuthenticationTable?uncap_first]permission);
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.GetPermission(anyLong())).thenReturn(permission);
//		Assertions.assertThat(_appService.GetPermission(ID)).isEqualTo(_mapper.PermissionEntityToGetPermissionOutput(permission, [=AuthenticationTable?uncap_first]permission));
//	}
//
//	@Test 
//	public void GetPermission_If[=AuthenticationTable]permissionIdAndPermissionIdIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_ReturnNull() {
//		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
//
//		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(anyLong())).thenReturn(null);
//		Assertions.assertThat(_appService.GetPermission(ID)).isEqualTo(null);
//	}
 

}

