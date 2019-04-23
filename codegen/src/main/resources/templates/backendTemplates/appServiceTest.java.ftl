package [=PackageName].application.[=ClassName];

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

import [=PackageName].domain.[=ClassName].*;
import [=PackageName].application.[=ClassName].Dto.*;
import [=PackageName].domain.model.Q[=EntityClassName];
import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].domain.[=relationValue.eName].[=relationValue.eName]Manager;
</#if>
</#list>
import [=PackageName].Utils.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=ClassName]AppServiceTest {

	@InjectMocks
	[=ClassName]AppService _appService;

	@Mock
	private [=ClassName]Manager _[=ClassName?lower_case]Manager;
	
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    
    @Mock
	private [=relationValue.eName]Manager  _[=relationValue.eName?lower_case]Manager;
    </#if>
    </#list>

	@Mock
	private [=ClassName]Mapper _mapper;

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
	
	@Test
	public void find[=ClassName]ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void find[=ClassName]ById_IdIsNotNullAndIdExists_Return[=ClassName]() {

		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Assertions.assertThat(_appService.FindById(ID)).isEqualTo(_mapper.[=EntityClassName]ToCreate[=ClassName]Output([=ClassName?lower_case]));
	}
	
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExist_Store[=ClassName]() {

		[=EntityClassName] [=ClassName?lower_case]Entity = mock([=EntityClassName].class);
		Create[=ClassName]Input [=ClassName?lower_case] = mock(Create[=ClassName]Input.class);
		Mockito.when(_mapper.Create[=ClassName]InputTo[=EntityClassName](any(Create[=ClassName]Input.class))).thenReturn([=ClassName?lower_case]Entity);
		Mockito.when(_[=ClassName?lower_case]Manager.Create(any([=EntityClassName].class))).thenReturn([=ClassName?lower_case]Entity);
		Assertions.assertThat(_appService.Create([=ClassName?lower_case])).isEqualTo(_mapper.[=EntityClassName]ToCreate[=ClassName]Output([=ClassName?lower_case]Entity));
	}
	
	@Test
	public void delete[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]Exists_[=ClassName]Removed() {

		[=EntityClassName] [=ClassName?lower_case]= mock([=EntityClassName].class);
		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		_appService.Delete(ID); 
		verify(_[=ClassName?lower_case]Manager).Delete([=ClassName?lower_case]);
	}
	
	@Test
	public void update[=ClassName]_[=ClassName]IdIsNotNullAndIdExists_ReturnUpdated[=ClassName]() {

		[=EntityClassName] [=ClassName?lower_case]Entity = mock([=EntityClassName].class);
		Update[=ClassName]Input [=ClassName?lower_case]= mock(Update[=ClassName]Input.class);
		Mockito.when(_mapper.Update[=ClassName]InputTo[=EntityClassName](any(Update[=ClassName]Input.class))).thenReturn([=ClassName?lower_case]Entity);
		Mockito.when(_[=ClassName?lower_case]Manager.Update(any([=EntityClassName].class))).thenReturn([=ClassName?lower_case]Entity);
		Assertions.assertThat(_appService.Update(ID,[=ClassName?lower_case])).isEqualTo(_mapper.[=EntityClassName]ToUpdate[=ClassName]Output([=ClassName?lower_case]Entity));
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<[=EntityClassName]> list = new ArrayList<>();
		Page<[=EntityClassName]> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();

		Mockito.when(_[=ClassName?lower_case]Manager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find("abc", pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<[=EntityClassName]> list = new ArrayList<>();
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		list.add([=ClassName?lower_case]);
		Page<[=EntityClassName]> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();

		output.add(_mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?lower_case]));
		Mockito.when(_[=ClassName?lower_case]Manager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find("abc", pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {

		String search= "xyz";
		Q[=EntityClassName] [=ClassName?lower_case] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		BooleanBuilder builder = new BooleanBuilder();
		<#list SearchFields as fields>
		builder.or([=ClassName?lower_case].[=fields].likeIgnoreCase("%"+ search + "%"));
		</#list>
		Assertions.assertThat(_appService.searchAllProperties([=ClassName?lower_case], search)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {

		List<String> list = new ArrayList<>();
		<#list SearchFields as fields>
		list.add("[=fields]");
		</#list>
		Q[=EntityClassName] [=ClassName?lower_case] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		BooleanBuilder builder = new BooleanBuilder();
		 <#list SearchFields as fields>
		builder.or([=ClassName?lower_case].[=fields].likeIgnoreCase("%xyz%"));
		</#list>
		
		Assertions.assertThat(_appService.searchSpecificProperty([=ClassName?lower_case], list,"xyz")).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {

		Q[=EntityClassName] [=ClassName?lower_case] = Q[=EntityClassName].[=EntityClassName?uncap_first];
	    Map map = new HashMap();
	    <#list SearchFields as fields>
        map.put("[=fields]","xyz");
        <#break>
		</#list>
		
		BooleanBuilder builder = new BooleanBuilder();
		<#list SearchFields as fields>
        builder.and([=ClassName?lower_case].[=fields].likeIgnoreCase("%xyz%"));
        <#break>
		</#list>
		Assertions.assertThat(_appService.searchKeyValuePair([=ClassName?lower_case], map)).isEqualTo(builder);
	}
	
	@Test (expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception {

		List<String> list = new ArrayList<>();
		list.add("xyz");
		_appService.checkProperties(list);
	}
	
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception {

		List<String> list = new ArrayList<>();
		<#list SearchFields as fields>
		list.add("[=fields]");
		</#list>
		_appService.checkProperties(list);
	}
	
	@Test
	public void search_StringIsNotNullAndStringContainsKey_ReturnBooleanBuilder() throws Exception {

		Q[=EntityClassName] [=ClassName?lower_case] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		String search= "xyz";
		BooleanBuilder builder = new BooleanBuilder();
		<#list SearchFields as fields>
        builder.or([=ClassName?lower_case].[=fields].likeIgnoreCase("%" +search + "%"));
		</#list>
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNotNullAndStringContainsMoreThanOneKey_ReturnBooleanBuilder() throws Exception {

		Q[=EntityClassName] [=ClassName?lower_case] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		String search= "xyz";
		<#list SearchFields as fields>
        search.concat(",[=fields]");
		</#list>
		BooleanBuilder builder = new BooleanBuilder();
		<#list SearchFields as fields>
        builder.or([=ClassName?lower_case].[=fields].likeIgnoreCase("%" +search + "%"));
		</#list>
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
	
   <#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">
   //[=relationValue.eName]
   
   @Test
	public void Add[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_[=relationValue.eName]Assigned() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=relationValue.eName?lower_case]Manager.FindById(anyLong())).thenReturn([=relationValue.eName?lower_case]);
		_appService.Add[=relationValue.eName](ID,ID);
		verify(_[=ClassName?lower_case]Manager).Add[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case]);
	}

	@Test
	public void Remove[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_[=relationValue.eName]Removed() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		
		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		_appService.Remove[=relationValue.eName](ID);
		verify(_[=ClassName?lower_case]Manager).Remove[=relationValue.eName]([=ClassName?lower_case]);
	}

	@Test
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_Return[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);


		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=ClassName?lower_case]Manager.Get[=relationValue.eName](anyLong())).thenReturn([=relationValue.eName?lower_case]);

		Assertions.assertThat(_appService.Get[=relationValue.eName](ID)).isEqualTo(_mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName?lower_case], [=ClassName?lower_case]));
	}

	@Test 
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]DoesNotExist_ReturnNull() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Get[=relationValue.eName](ID)).isEqualTo(null);

	}
   
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if parent?keep_before("-") == relationValue.eName>
    // Operations With [=relationValue.eName]
    
    @Test 
	public void Add[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]AlreadyHas[=relationValue.eName]_ReturnFalse() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);
		[=relationValue.eName?lower_case].add[=ClassName]([=ClassName?lower_case]);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=relationValue.eName?lower_case]Manager.FindById(anyLong())).thenReturn([=relationValue.eName?lower_case]);
		Mockito.when(_[=ClassName?lower_case]Manager.Add[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case])).thenReturn(false);
		Assertions.assertThat(_appService.Add[=relationValue.eName](ID, ID)).isEqualTo(false);
	}
	@Test
	public void Add[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_[=relationValue.eName]Granted() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=relationValue.eName?lower_case]Manager.FindById(anyLong())).thenReturn([=relationValue.eName?lower_case]);
		Mockito.when(_[=ClassName?lower_case]Manager.Add[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case])).thenReturn(true);
		Assertions.assertThat(_appService.Add[=relationValue.eName](ID, ID)).isEqualTo(true);

	}

	@Test
	public void Remove[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_[=relationValue.eName]Removed() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=relationValue.eName?lower_case]Manager.FindById(anyLong())).thenReturn([=relationValue.eName?lower_case]);
		_appService.Remove[=relationValue.eName](ID,ID);
		verify(_[=ClassName?lower_case]Manager).Remove[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case]);
	}

	@Test 
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]DoesNotExist_ReturnNull() {

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Get[=relationValue.eName](ID, ID)).isEqualTo(null);

	}

	@Test 
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=relationValue.eName]DoesNotExist_ReturnNull() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=relationValue.eName?lower_case]Manager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Get[=relationValue.eName](ID, ID)).isEqualTo(null);

	}

	@Test
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_Return[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=relationValue.eName?lower_case]Manager.FindById(anyLong())).thenReturn([=relationValue.eName?lower_case]);
		Mockito.when(_[=ClassName?lower_case]Manager.Get[=relationValue.eName](anyLong(),anyLong())).thenReturn([=relationValue.eName?lower_case]);
		Assertions.assertThat(_appService.Get[=relationValue.eName](ID, ID)).isEqualTo(_mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName?lower_case], [=ClassName?lower_case]));		
	}

	@Test 
	public void Get[=relationValue.eName]s_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]DoesNotExist_ReturnNull() {
		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Get[=relationValue.eName]s(ID)).isEqualTo(null);
	}

	@Test
	public void Get[=relationValue.eName]s_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_Return[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);

		Set<[=relationValue.eName]Entity> [=relationValue.eName?lower_case]List = [=ClassName?lower_case].get[=relationValue.eName]();
		List<Get[=relationValue.eName]Output> list = new ArrayList<>();
		Mockito.when(_[=ClassName?lower_case]Manager.FindById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when(_[=ClassName?lower_case]Manager.Get[=relationValue.eName]s(any([=ClassName]Entity.class))).thenReturn([=relationValue.eName?lower_case]List);
		Assertions.assertThat(_appService.Get[=relationValue.eName]s(ID)).isEqualTo(list);
	}
	</#if>
   </#list>
   </#if>
  
  </#list>
	
	
}

