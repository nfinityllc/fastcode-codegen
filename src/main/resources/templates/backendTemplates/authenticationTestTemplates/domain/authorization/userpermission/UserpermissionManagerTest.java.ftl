package [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]permission;

import static org.mockito.ArgumentMatchers.any;
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

import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=PackageName].domain.irepository.I[=AuthenticationTable]Repository;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.irepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.irepository.I[=AuthenticationTable]permissionRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=AuthenticationTable]permissionManagerTest {

	@InjectMocks
	[=AuthenticationTable]permissionManager _[=AuthenticationTable?uncap_first]permissionManager;

	@Mock
	I[=AuthenticationTable]permissionRepository  _[=AuthenticationTable?uncap_first]permissionRepository;

	@Mock
	I[=AuthenticationTable]Repository  _[=AuthenticationTable?uncap_first]Repository;

	@Mock
	[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId;

	@Mock
	IPermissionRepository  _permissionRepository;
	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_[=AuthenticationTable?uncap_first]permissionManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void find[=AuthenticationTable]permissionById_IdIsNotNullAndIdExists_Return[=AuthenticationTable]permission() {
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission =mock([=AuthenticationTable]permissionEntity.class);

		Optional<[=AuthenticationTable]permissionEntity> db[=AuthenticationTable]permission = Optional.of(([=AuthenticationTable]permissionEntity) [=AuthenticationTable?uncap_first]permission);
		Mockito.<Optional<[=AuthenticationTable]permissionEntity>>when(_[=AuthenticationTable?uncap_first]permissionRepository.findById(any([=AuthenticationTable]permissionId.class))).thenReturn(db[=AuthenticationTable]permission);

		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.FindById([=AuthenticationTable?uncap_first]permissionId)).isEqualTo([=AuthenticationTable?uncap_first]permission);
	}

	@Test 
	public void find[=AuthenticationTable]permissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.<Optional<[=AuthenticationTable]permissionEntity>>when(_[=AuthenticationTable?uncap_first]permissionRepository.findById(any([=AuthenticationTable]permissionId.class))).thenReturn(Optional.empty());
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.FindById([=AuthenticationTable?uncap_first]permissionId)).isEqualTo(null);
	}

	@Test
	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_Store[=AuthenticationTable]permission() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission =mock([=AuthenticationTable]permissionEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionRepository.save(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permission);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo([=AuthenticationTable?uncap_first]permission);
	}

	@Test
	public void delete[=AuthenticationTable]permission_[=AuthenticationTable]permissionExists_Remove[=AuthenticationTable]permission() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission =mock([=AuthenticationTable]permissionEntity.class);
		_[=AuthenticationTable?uncap_first]permissionManager.Delete([=AuthenticationTable?uncap_first]permission);
		verify(_[=AuthenticationTable?uncap_first]permissionRepository).delete([=AuthenticationTable?uncap_first]permission);
	}

	@Test
	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionExists_Update[=AuthenticationTable]permission() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission =mock([=AuthenticationTable]permissionEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionRepository.save(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permission);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.Update([=AuthenticationTable?uncap_first]permission)).isEqualTo([=AuthenticationTable?uncap_first]permission);

	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<[=AuthenticationTable]permissionEntity> [=AuthenticationTable?uncap_first]permission = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]permissionRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn([=AuthenticationTable?uncap_first]permission);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.FindAll(predicate,pageable)).isEqualTo([=AuthenticationTable?uncap_first]permission);
	}

	//[=AuthenticationTable]
	@Test
	public void get[=AuthenticationTable]_if_[=AuthenticationTable]permissionIdIsNotNull_return[=AuthenticationTable]() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = mock([=AuthenticationTable]Entity.class);

		Optional<[=AuthenticationTable]permissionEntity> db[=AuthenticationTable]permission = Optional.of(([=AuthenticationTable]permissionEntity) [=AuthenticationTable?uncap_first]permission);
		Mockito.<Optional<[=AuthenticationTable]permissionEntity>>when(_[=AuthenticationTable?uncap_first]permissionRepository.findById(any([=AuthenticationTable]permissionId.class))).thenReturn(db[=AuthenticationTable]permission);
		
		Mockito.when([=AuthenticationTable?uncap_first]permission.get[=AuthenticationTable]()).thenReturn([=AuthenticationTable?uncap_first]);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]permissionId)).isEqualTo([=AuthenticationTable?uncap_first]);

	}

	//Permission
	@Test
	public void getPermission_if_[=AuthenticationTable]permissionIdIsNotNull_returnPermission() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		PermissionEntity permission = mock(PermissionEntity.class);

		Optional<[=AuthenticationTable]permissionEntity> db[=AuthenticationTable]permission = Optional.of(([=AuthenticationTable]permissionEntity) [=AuthenticationTable?uncap_first]permission);
		Mockito.<Optional<[=AuthenticationTable]permissionEntity>>when(_[=AuthenticationTable?uncap_first]permissionRepository.findById(any([=AuthenticationTable]permissionId.class))).thenReturn(db[=AuthenticationTable]permission);
		
		Mockito.when([=AuthenticationTable?uncap_first]permission.getPermission()).thenReturn(permission);
		Assertions.assertThat(_[=AuthenticationTable?uncap_first]permissionManager.GetPermission([=AuthenticationTable?uncap_first]permissionId)).isEqualTo(permission);

	}
	
}
