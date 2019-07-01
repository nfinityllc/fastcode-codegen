package [=PackageName].domain.Authorization.Permissions;

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
import org.springframework.stereotype.Component;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.model.PermissionsEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@Component
@RunWith(SpringJUnit4ClassRunner.class)
public class PermissionsManagerTest {

	@InjectMocks
	PermissionsManager permissionsManager;

	@Mock
	private IPermissionsRepository _permissionsRepository;

	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(permissionsManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findPermissionById_IdIsNotNullAndIdExists_ReturnAPermission() {
		PermissionsEntity permission =mock(PermissionsEntity.class);

		Mockito.when(_permissionsRepository.findById(anyLong())).thenReturn(permission);
		Assertions.assertThat(permissionsManager.FindById(ID)).isEqualTo(permission);
	}

	@Test 
	public void findPermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	Mockito.when(_permissionsRepository.findById(anyLong())).thenReturn(null);
	Assertions.assertThat(permissionsManager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void findPermissionByName_NameIsNotNullAndNameExists_ReturnAPermission() {
		PermissionsEntity permission =mock(PermissionsEntity.class);

		Mockito.when(_permissionsRepository.findByPermissionName(anyString())).thenReturn(permission);
		Assertions.assertThat(permissionsManager.FindByPermissionName("permission1")).isEqualTo(permission);
	}

	@Test 
	public void findPermissionByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {

		Mockito.when(_permissionsRepository.findByPermissionName(anyString())).thenReturn(null);
		Assertions.assertThat(permissionsManager.FindByPermissionName("permission1")).isEqualTo(null);
	
	}
	
	@Test
	public void createPermission_PermissionIsNotNullAndPermissionDoesNotExist_StoreAPermission() {

		PermissionsEntity permission =mock(PermissionsEntity.class);
		Mockito.when(_permissionsRepository.save(any(PermissionsEntity.class))).thenReturn(permission);
		Assertions.assertThat(permissionsManager.Create(permission)).isEqualTo(permission);
	}

	@Test
	public void deletePermission_PermissionExists_RemoveAPermission() {

		PermissionsEntity permission =mock(PermissionsEntity.class);
		permissionsManager.Delete(permission);
		verify(_permissionsRepository).delete(permission);
	}

	@Test
	public void updatePermission_PermissionIsNotNullAndPermissionExists_UpdateAPermission() {
		
		PermissionsEntity permission =mock(PermissionsEntity.class);
		Mockito.when(_permissionsRepository.save(any(PermissionsEntity.class))).thenReturn(permission);
		Assertions.assertThat(permissionsManager.Update(permission)).isEqualTo(permission);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<PermissionsEntity> permission = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_permissionsRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(permission);
		Assertions.assertThat(permissionsManager.FindAll(predicate,pageable)).isEqualTo(permission);
	}
	
}
