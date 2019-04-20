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
	[=ClassName]Manager _[=ClassName?lower_case]Manager;
	
	@Mock
	I[=ClassName]Repository  _[=ClassName?lower_case]Repository;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName>
    
    @Mock
	I[=relationValue.eName]Repository  _[=relationValue.eName?lower_case]Repository;
    </#if>
    </#list>
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_[=ClassName?lower_case]Manager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void find[=ClassName]ById_IdIsNotNullAndIdExists_Return[=ClassName]() {
		[=ClassName]Entity [=ClassName?lower_case] =mock([=ClassName]Entity.class);

		Mockito.when(_[=ClassName?lower_case]Repository.findById(anyLong())).thenReturn([=ClassName?lower_case]);
		Assertions.assertThat(_[=ClassName?lower_case]Manager.FindById(ID)).isEqualTo([=ClassName?lower_case]);
	}

	@Test 
	public void find[=ClassName]ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	Mockito.when(_[=ClassName?lower_case]Repository.findById(anyLong())).thenReturn(null);
	Assertions.assertThat(_[=ClassName?lower_case]Manager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExist_Store[=ClassName]() {

		[=ClassName]Entity [=ClassName?lower_case] =mock([=ClassName]Entity.class);
		Mockito.when(_[=ClassName?lower_case]Repository.save(any([=ClassName]Entity.class))).thenReturn([=ClassName?lower_case]);
		Assertions.assertThat(_[=ClassName?lower_case]Manager.Create([=ClassName?lower_case])).isEqualTo([=ClassName?lower_case]);
	}

	@Test
	public void delete[=ClassName]_[=ClassName]Exists_Remove[=ClassName]() {

		[=ClassName]Entity [=ClassName?lower_case] =mock([=ClassName]Entity.class);
		_[=ClassName?lower_case]Manager.Delete([=ClassName?lower_case]);
		verify(_[=ClassName?lower_case]Repository).delete([=ClassName?lower_case]);
	}

	@Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]Exists_Update[=ClassName]() {
		
		[=ClassName]Entity [=ClassName?lower_case] =mock([=ClassName]Entity.class);
		Mockito.when(_[=ClassName?lower_case]Repository.save(any([=ClassName]Entity.class))).thenReturn([=ClassName?lower_case]);
		Assertions.assertThat(_[=ClassName?lower_case]Manager.Update([=ClassName?lower_case])).isEqualTo([=ClassName?lower_case]);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<[=ClassName]Entity> [=ClassName?lower_case] = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_[=ClassName?lower_case]Repository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn([=ClassName?lower_case]);
		Assertions.assertThat(_[=ClassName?lower_case]Manager.FindAll(predicate,pageable)).isEqualTo([=ClassName?lower_case]);
	}
	
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   //[=relationValue.eName]
   @Test
	public void add[=relationValue.eName]_If[=ClassName]And[=relationValue.eName]IsNotNull_AssignA[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		_[=ClassName?lower_case]Manager.Add[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case]);
		verify(_[=ClassName?lower_case]Repository).save([=ClassName?lower_case]);
		verify(_[=relationValue.eName?lower_case]Repository).save([=relationValue.eName?lower_case]);

	}

	@Test
	public void remove[=relationValue.eName]_if_[=ClassName]IsNotNullAnd_[=ClassName]Exists_[=relationValue.eName]Removed() {

		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);

		Mockito.when(_[=ClassName?lower_case]Repository.findById(anyLong())).thenReturn([=ClassName?lower_case]);
		_[=ClassName?lower_case]Manager.Remove[=relationValue.eName]([=ClassName?lower_case]);
		verify(_[=ClassName?lower_case]Repository).save([=ClassName?lower_case]);
	}

	@Test
	public void get[=relationValue.eName]_if_[=ClassName]IdIsNotNull_return[=relationValue.eName]() {

		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?lower_case]Repository.findById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when([=ClassName?lower_case].get[=relationValue.eName]()).thenReturn([=relationValue.eName?lower_case]);
		Assertions.assertThat(_[=ClassName?lower_case]Manager.Get[=relationValue.eName](ID)).isEqualTo([=relationValue.eName?lower_case]);

	}
	
  <#elseif relationValue.relation == "ManyToMany">
   <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_after("-") == relationValue.eName>
    //[=relationValue.eName]
    @Test
	public void add[=relationValue.eName]_if[=ClassName]And[=relationValue.eName]IsNotNull_[=relationValue.eName]Assigned() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);
		
		Set<[=EntityClassName]> su = [=relationValue.eName?lower_case].get[=ClassName]s();
		Mockito.when([=relationValue.eName?lower_case].get[=ClassName]s()).thenReturn(su);
        Assertions.assertThat(_[=ClassName?lower_case]Manager.Add[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case])).isEqualTo(true);

	}

	@Test
	public void add[=relationValue.eName]_if[=ClassName]And[=relationValue.eName]IsNotNullAnd[=relationValue.eName]AlreadyGranted_ReturnFalse() {
		
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);
		Set<[=EntityClassName]> su = [=relationValue.eName?lower_case].get[=ClassName]s();
		su.add([=ClassName?lower_case]);
		
		 Mockito.when([=relationValue.eName?lower_case].get[=ClassName]s()).thenReturn(su);
		 Assertions.assertThat(_[=ClassName?lower_case]Manager.Add[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case])).isEqualTo(false);

	}

	@Test
	public void Remove[=relationValue.eName]_if[=ClassName]And[=relationValue.eName]IsNotNull_[=relationValue.eName]Removed() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = mock([=relationValue.eName]Entity.class);

		_[=ClassName?lower_case]Manager.Remove[=relationValue.eName]([=ClassName?lower_case], [=relationValue.eName?lower_case]);
		verify(_[=relationValue.eName?lower_case]Repository).save([=relationValue.eName?lower_case]);
	}


	@Test 
	public void Get[=relationValue.eName]_if[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=relationValue.eName]DoesNotExist_ReturnNull() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		
		Mockito.when(_[=ClassName?lower_case]Repository.findById(anyLong())).thenReturn([=ClassName?lower_case]);
        Assertions.assertThat(_[=ClassName?lower_case]Manager.Get[=relationValue.eName](ID,ID)).isEqualTo(null);
	}

	@Test
	public void Get[=relationValue.eName]_if[=ClassName]IdAnd[=relationValue.eName]IdIsNotNull_Return[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?lower_case] = new [=relationValue.eName]Entity();
		[=relationValue.eName?lower_case].setId(ID);
	
		Set<[=relationValue.eName]Entity> [=relationValue.eName?lower_case]s = [=ClassName?lower_case].get[=relationValue.eName]s();
		[=relationValue.eName?lower_case]s.add([=relationValue.eName?lower_case]);

		Mockito.when(_[=ClassName?lower_case]Repository.findById(ID)).thenReturn([=ClassName?lower_case]);
		Mockito.when([=ClassName?lower_case].get[=relationValue.eName]s()).thenReturn([=relationValue.eName?lower_case]s);

		Assertions.assertThat(_[=ClassName?lower_case]Manager.Get[=relationValue.eName](ID,ID)).isEqualTo([=relationValue.eName?lower_case]);

	}

	@Test
	public void Get[=relationValue.eName]_[=ClassName]IsNotNull_Return[=relationValue.eName]s() {
		[=EntityClassName] [=ClassName?lower_case] = mock([=EntityClassName].class);
		Set<[=relationValue.eName]Entity> [=relationValue.eName?lower_case]s = [=ClassName?lower_case].get[=relationValue.eName]s();
		
		Mockito.when(_[=ClassName?lower_case]Repository.findById(anyLong())).thenReturn([=ClassName?lower_case]);
		Mockito.when([=ClassName?lower_case].get[=relationValue.eName]s()).thenReturn([=relationValue.eName?lower_case]s);
		Assertions.assertThat(_[=ClassName?lower_case]Manager.Get[=relationValue.eName]s([=ClassName?lower_case])).isEqualTo([=relationValue.eName?lower_case]s);
	}
    </#if>
    </#list>
   </#if>
  </#list>
}
