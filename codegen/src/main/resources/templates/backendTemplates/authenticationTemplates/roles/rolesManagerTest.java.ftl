package [=PackageName].domain.Authorization.Roles;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Set;
import java.util.List;

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

import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.IRepository.IRolesRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class RoleManagerTest {
	
	@InjectMocks
	RolesManager roleManager;
	
	@Mock
	IRolesRepository _rolesRepository;
	
	@Mock
	IPermissionsRepository _permissionsRepository;

	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(roleManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void findRoleById_IdIsNotNullAndIdExists_ReturnARole() {
		RolesEntity rolesEntity = mock(RolesEntity.class);
		Mockito.when(_rolesRepository.findById(anyLong())).thenReturn(rolesEntity);
		Assertions.assertThat(roleManager.FindById(ID)).isEqualTo(rolesEntity);
	}

	@Test 
	public void findRoleById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_rolesRepository.findById(anyLong())).thenReturn(null);
		Assertions.assertThat(roleManager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void findRoleByName_NameIsNotNullAndNameExists_ReturnARole() {
		RolesEntity rolesEntity = mock(RolesEntity.class);

		Mockito.when(_rolesRepository.findByRoleName(anyString())).thenReturn(rolesEntity);
		Assertions.assertThat(roleManager.FindByRoleName("Permission1")).isEqualTo(rolesEntity);
	}

	@Test 
	public void findRoleByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {

		Mockito.when(_rolesRepository.findByRoleName(anyString())).thenReturn(null);
		Assertions.assertThat(roleManager.FindByRoleName("Permission")).isEqualTo(null);
	
	}
	@Test
	public void createRole_RoleIsNotNullAndRoleDoesNotExist_StoreARole() {

		RolesEntity rolesEntity = mock(RolesEntity.class);
		Mockito.when(_rolesRepository.save(any(RolesEntity.class))).thenReturn(rolesEntity);
		Assertions.assertThat(roleManager.Create(rolesEntity)).isEqualTo(rolesEntity);
	}

	@Test
	public void deleteRole_RoleExists_RemoveARole() {

		RolesEntity rolesEntity = mock(RolesEntity.class);
		roleManager.Delete(rolesEntity);
		verify(_rolesRepository).delete(rolesEntity);
	}

	@Test
	public void updateRole_RoleIsNotNullAndRoleExists_UpdateARole() {
		
		RolesEntity rolesEntity = mock(RolesEntity.class);
		Mockito.when(_rolesRepository.save(any(RolesEntity.class))).thenReturn(rolesEntity);
		Assertions.assertThat(roleManager.Update(rolesEntity)).isEqualTo(rolesEntity);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<RolesEntity> role = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_rolesRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(role);
		Assertions.assertThat(roleManager.FindAll(predicate,pageable)).isEqualTo(role);

	}

	 //Permissions
    @Test
	public void addPermissions_ifRolesAndPermissionsIsNotNull_PermissionsAssigned() {
		RolesEntity roles = mock(RolesEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		
		Set<RolesEntity> su = permissions.getRoles();
		Mockito.when(permissions.getRoles()).thenReturn(su);
        Assertions.assertThat(roleManager.AddPermission(roles, permissions)).isEqualTo(true);

	}

	@Test
	public void addPermissions_ifRolesAndPermissionsIsNotNullAndPermissionsAlreadyAssigned_ReturnFalse() {
		
		RolesEntity roles = mock(RolesEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		Set<RolesEntity> su = permissions.getRoles();
		su.add(roles);
		
		 Mockito.when(permissions.getRoles()).thenReturn(su);
		 Assertions.assertThat(roleManager.AddPermission(roles, permissions)).isEqualTo(false);

	}

	@Test
	public void RemovePermissions_ifRolesAndPermissionsIsNotNull_PermissionsRemoved() {
		RolesEntity roles = mock(RolesEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);

		roleManager.RemovePermission(roles, permissions);
		verify(_permissionsRepository).save(permissions);
	}


	@Test 
	public void GetPermissions_ifRolesIdAndPermissionsIdIsNotNullAndPermissionsDoesNotExist_ReturnNull() {
		RolesEntity roles = mock(RolesEntity.class);
		
		Mockito.when(_rolesRepository.findById(anyLong())).thenReturn(roles);
        Assertions.assertThat(roleManager.GetPermissions(ID,ID)).isEqualTo(null);
	}

	@Test
	public void GetPermissions_ifRolesIdAndPermissionsIdIsNotNullAndRecordExists_ReturnPermissions() {
		RolesEntity roles = mock(RolesEntity.class);
		PermissionsEntity permissions = new PermissionsEntity();
		permissions.setId(ID);
	
		Set<PermissionsEntity> permissionsList = roles.getPermissions();
		permissionsList.add(permissions);

		Mockito.when(_rolesRepository.findById(ID)).thenReturn(roles);
		Mockito.when(roles.getPermissions()).thenReturn(permissionsList);

		Assertions.assertThat(roleManager.GetPermissions(ID,ID)).isEqualTo(permissions);

	}
	
    @Test
	public void FindPermissions_RolesIdIsNotNull_ReturnPermissions() {
	    Page<PermissionsEntity> permissions = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		List<SearchFields> list = mock(List.class);
		String value="equals";

		Mockito.when(_rolesRepository.getAllPermissions(anyLong(),any(List.class),anyString(),any(Pageable.class))).thenReturn(permissions);
		Assertions.assertThat(_rolesRepository.getAllPermissions(ID,list,value,pageable)).isEqualTo(permissions);
	}
	
}
