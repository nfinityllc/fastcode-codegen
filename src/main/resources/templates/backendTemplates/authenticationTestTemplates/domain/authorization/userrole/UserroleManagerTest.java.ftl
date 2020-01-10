package [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]role;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

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

import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.irepository.I[=AuthenticationTable]Repository;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.irepository.IRoleRepository;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import [=PackageName].domain.irepository.I[=AuthenticationTable]roleRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=AuthenticationTable]roleManagerTest {

	@InjectMocks
	[=AuthenticationTable]roleManager _[=AuthenticationTable?uncap_first]roleManager;
	
	@Mock
	I[=AuthenticationTable]roleRepository  _[=AuthenticationTable?uncap_first]roleRepository;
    
    @Mock
	I[=AuthenticationTable]Repository  _[=AuthenticationTable?uncap_first]Repository;
    
    @Mock
	IRoleRepository  _roleRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	@Mock
	private [=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_[=AuthenticationTable?uncap_first]roleManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void find[=AuthenticationTable]roleById_IdIsNotNullAndIdExists_Return[=AuthenticationTable]role() {
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role =mock([=AuthenticationTable]roleEntity.class);

        Optional<[=AuthenticationTable]roleEntity> db[=AuthenticationTable]role = Optional.of(([=AuthenticationTable]roleEntity) [=AuthenticationTable?uncap_first]role);
		Mockito.<Optional<[=AuthenticationTable]roleEntity>>when(_[=AuthenticationTable?uncap_first]roleRepository.findById(any([=AuthenticationTable]roleId.class))).thenReturn(db[=AuthenticationTable]role);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId)).isEqualTo([=AuthenticationTable?uncap_first]role);
	}

	@Test 
	public void find[=AuthenticationTable]roleById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	    Mockito.<Optional<[=AuthenticationTable]roleEntity>>when(_[=AuthenticationTable?uncap_first]roleRepository.findById(any([=AuthenticationTable]roleId.class))).thenReturn(Optional.empty());
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId)).isEqualTo(null);
	}
	
	@Test
	public void create[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleDoesNotExist_Store[=AuthenticationTable]role() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role =mock([=AuthenticationTable]roleEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleRepository.save(any([=AuthenticationTable]roleEntity.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.Create([=AuthenticationTable?uncap_first]role)).isEqualTo([=AuthenticationTable?uncap_first]role);
	}

	@Test
	public void delete[=AuthenticationTable]role_[=AuthenticationTable]roleExists_Remove[=AuthenticationTable]role() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role =mock([=AuthenticationTable]roleEntity.class);
		_[=AuthenticationTable?uncap_first]roleManager.Delete([=AuthenticationTable?uncap_first]role);
		verify(_[=AuthenticationTable?uncap_first]roleRepository).delete([=AuthenticationTable?uncap_first]role);
	}

	@Test
	public void update[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleExists_Update[=AuthenticationTable]role() {
		
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role =mock([=AuthenticationTable]roleEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleRepository.save(any([=AuthenticationTable]roleEntity.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.Update([=AuthenticationTable?uncap_first]role)).isEqualTo([=AuthenticationTable?uncap_first]role);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<[=AuthenticationTable]roleEntity> [=AuthenticationTable?uncap_first]role = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]roleRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.FindAll(predicate,pageable)).isEqualTo([=AuthenticationTable?uncap_first]role);
	}
	
    //[=AuthenticationTable]
	@Test
	public void get[=AuthenticationTable]_if_[=AuthenticationTable]roleIdIsNotNull_return[=AuthenticationTable]() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = mock([=AuthenticationTable]Entity.class);
		
        Optional<[=AuthenticationTable]roleEntity> db[=AuthenticationTable]role = Optional.of(([=AuthenticationTable]roleEntity) [=AuthenticationTable?uncap_first]role);
		Mockito.<Optional<[=AuthenticationTable]roleEntity>>when(_[=AuthenticationTable?uncap_first]roleRepository.findById(any([=AuthenticationTable]roleId.class))).thenReturn(db[=AuthenticationTable]role);
		Mockito.when([=AuthenticationTable?uncap_first]role.get[=AuthenticationTable]()).thenReturn([=AuthenticationTable?uncap_first]);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]roleId)).isEqualTo([=AuthenticationTable?uncap_first]);

	}
	
    //Role
	@Test
	public void getRole_if_[=AuthenticationTable]roleIdIsNotNull_returnRole() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);
		RoleEntity role = mock(RoleEntity.class);
		
        Optional<[=AuthenticationTable]roleEntity> db[=AuthenticationTable]role = Optional.of(([=AuthenticationTable]roleEntity) [=AuthenticationTable?uncap_first]role);
		Mockito.<Optional<[=AuthenticationTable]roleEntity>>when(_[=AuthenticationTable?uncap_first]roleRepository.findById(any([=AuthenticationTable]roleId.class))).thenReturn(db[=AuthenticationTable]role);
		Mockito.when([=AuthenticationTable?uncap_first]role.getRole()).thenReturn(role);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]roleManager.GetRole([=AuthenticationTable?uncap_first]roleId)).isEqualTo(role);

	}
	
}
