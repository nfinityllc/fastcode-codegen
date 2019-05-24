package [=PackageName].domain.[=ClassName];

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

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
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import java.util.Set;

import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
</#list>
import [=PackageName].domain.IRepository.I[=ClassName]Repository;
import [=PackageName].Utils.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=ClassName]ManagerTest {

	@InjectMocks
	[=ClassName]Manager _[=ClassName?uncap_first]Manager;
	
	@Mock
	I[=ClassName]Repository  _[=ClassName?uncap_first]Repository;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName>
    
    @Mock
	I[=relationValue.eName]Repository  _[=relationValue.eName?uncap_first]Repository;
    </#if>
    </#list>
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_[=ClassName?uncap_first]Manager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void find[=ClassName]ById_IdIsNotNullAndIdExists_Return[=ClassName]() {
		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);

		Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindById(ID)).isEqualTo([=ClassName?uncap_first]);
	}

	@Test 
	public void find[=ClassName]ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn(null);
	Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExist_Store[=ClassName]() {

		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
		Mockito.when(_[=ClassName?uncap_first]Repository.save(any([=ClassName]Entity.class))).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Create([=ClassName?uncap_first])).isEqualTo([=ClassName?uncap_first]);
	}

	@Test
	public void delete[=ClassName]_[=ClassName]Exists_Remove[=ClassName]() {

		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
		_[=ClassName?uncap_first]Manager.Delete([=ClassName?uncap_first]);
		verify(_[=ClassName?uncap_first]Repository).delete([=ClassName?uncap_first]);
	}

	@Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]Exists_Update[=ClassName]() {
		
		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
		Mockito.when(_[=ClassName?uncap_first]Repository.save(any([=ClassName]Entity.class))).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Update([=ClassName?uncap_first])).isEqualTo([=ClassName?uncap_first]);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<[=ClassName]Entity> [=ClassName?uncap_first] = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_[=ClassName?uncap_first]Repository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindAll(predicate,pageable)).isEqualTo([=ClassName?uncap_first]);
	}
	
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   //[=relationValue.eName]
	@Test
	public void get[=relationValue.eName]_if_[=ClassName]IdIsNotNull_return[=relationValue.eName]() {

		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn([=ClassName?uncap_first]);
		Mockito.when([=ClassName?uncap_first].get[=relationValue.eName]()).thenReturn([=relationValue.eName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Get[=relationValue.eName](ID)).isEqualTo([=relationValue.eName?uncap_first]);

	}
	
  <#elseif relationValue.relation == "ManyToMany">
   <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_after("-") == relationValue.eName>
    //[=relationValue.eName]
    @Test
	public void add[=relationValue.eName]_if[=ClassName]And[=relationValue.eName]IsNotNull_[=relationValue.eName]Assigned() {
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);
		
		Set<[=EntityClassName]> su = [=relationValue.eName?uncap_first].get[=ClassName]();
		Mockito.when([=relationValue.eName?uncap_first].get[=ClassName]()).thenReturn(su);
        Assertions.assertThat(_[=ClassName?uncap_first]Manager.Add[=relationValue.eName]([=ClassName?uncap_first], [=relationValue.eName?uncap_first])).isEqualTo(true);

	}

	@Test
	public void add[=relationValue.eName]_if[=ClassName]And[=relationValue.eName]IsNotNullAnd[=relationValue.eName]AlreadyAssigned_ReturnFalse() {
		
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);
		Set<[=EntityClassName]> su = [=relationValue.eName?uncap_first].get[=ClassName]();
		su.add([=ClassName?uncap_first]);
		
		 Mockito.when([=relationValue.eName?uncap_first].get[=ClassName]()).thenReturn(su);
		 Assertions.assertThat(_[=ClassName?uncap_first]Manager.Add[=relationValue.eName]([=ClassName?uncap_first], [=relationValue.eName?uncap_first])).isEqualTo(false);

	}

	@Test
	public void Remove[=relationValue.eName]_if[=ClassName]And[=relationValue.eName]IsNotNull_[=relationValue.eName]Removed() {
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);

		_[=ClassName?uncap_first]Manager.Remove[=relationValue.eName]([=ClassName?uncap_first], [=relationValue.eName?uncap_first]);
		verify(_[=relationValue.eName?uncap_first]Repository).save([=relationValue.eName?uncap_first]);
	}


	@Test 
	public void Get[=relationValue.eName]_if[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=relationValue.eName]DoesNotExist_ReturnNull() {
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		
		Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn([=ClassName?uncap_first]);
        Assertions.assertThat(_[=ClassName?uncap_first]Manager.Get[=relationValue.eName](ID,ID)).isEqualTo(null);
	}

	@Test
	public void Get[=relationValue.eName]_if[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAndRecordExists_Return[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = new [=relationValue.eName]Entity();
		[=relationValue.eName?uncap_first].setId(ID);
	
		Set<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]List = [=ClassName?uncap_first].get[=relationValue.eName]();
		[=relationValue.eName?uncap_first]List.add([=relationValue.eName?uncap_first]);

		Mockito.when(_[=ClassName?uncap_first]Repository.findById(ID)).thenReturn([=ClassName?uncap_first]);
		Mockito.when([=ClassName?uncap_first].get[=relationValue.eName]()).thenReturn([=relationValue.eName?uncap_first]List);

		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Get[=relationValue.eName](ID,ID)).isEqualTo([=relationValue.eName?uncap_first]);

	}
	
    @Test
	public void Find[=relationValue.eName]_[=ClassName]IdIsNotNull_Return[=relationValue.eName]() {
	    Page<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first] = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		String value="abc";

		Mockito.when(_[=ClassName?uncap_first]Repository.getAll[=relationValue.eName](anyLong(),<#list relationValue.fDetails as fValue><#if fValue.fieldType?lower_case == "string">anyString(),</#if></#list> any(Pageable.class))).thenReturn([=relationValue.eName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Repository.getAll[=relationValue.eName](ID,<#list relationValue.fDetails as fValue><#if fValue.fieldType?lower_case == "string">value,</#if></#list> pageable)).isEqualTo([=relationValue.eName?uncap_first]);
	}

    </#if>
    </#list>
   </#if>
  </#list>
}
