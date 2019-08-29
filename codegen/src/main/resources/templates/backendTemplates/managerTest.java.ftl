package [=PackageName].domain<#if ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName];

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

import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation == "ManyToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>   
</#list>
import [=PackageName].domain.IRepository.I[=ClassName]Repository;
import [=CommonModulePackage].logging.LoggingHelper;
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
	
//	@Test
//	public void find[=ClassName]ById_IdIsNotNullAndIdExists_Return[=ClassName]() {
//		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
//
//		Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn([=ClassName?uncap_first]);
//		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindById(ID)).isEqualTo([=ClassName?uncap_first]);
//	}
//
//	@Test 
//	public void find[=ClassName]ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
//
//	Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn(null);
//	Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindById(ID)).isEqualTo(null);
//	}
	
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
//	@Test
//	public void get[=relationValue.eName]_if_[=ClassName]IdIsNotNull_return[=relationValue.eName]() {
//
//		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
//		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);
//
//		Mockito.when(_[=ClassName?uncap_first]Repository.findById(anyLong())).thenReturn([=ClassName?uncap_first]);
//		Mockito.when([=ClassName?uncap_first].get[=relationValue.eName]()).thenReturn([=relationValue.eName?uncap_first]);
//		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Get[=relationValue.eName](ID)).isEqualTo([=relationValue.eName?uncap_first]);
//
//	}
	
   </#if>
  </#list>
}
