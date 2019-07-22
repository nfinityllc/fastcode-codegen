package [=PackageName].domain.Authorization.Users;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.model.UsersEntity;
import [=PackageName].domain.IRepository.IPermissionsRepository;
import [=PackageName].domain.IRepository.IRolesRepository;
import [=PackageName].domain.IRepository.IUsersRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import [=CommonModulePackage].Search.SearchFields;
import com.querydsl.core.types.Predicate;
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

import java.util.Set;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@Component
@RunWith(SpringJUnit4ClassRunner.class)
public class UserManagerTest {

	@InjectMocks
	UserManager userManager;

	@Mock
	IUsersRepository _usersRepository;

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
		MockitoAnnotations.initMocks(userManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void findUserById_IdIsNotNullAndIdExists_ReturnAUser() {
		UsersEntity userEntity = mock(UsersEntity.class);
		Mockito.when(_usersRepository.findById(anyLong())).thenReturn(userEntity);
		Assertions.assertThat(userManager.FindById(ID)).isEqualTo(userEntity);
	}

	@Test 
	public void findUserById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_usersRepository.findById(anyLong())).thenReturn(null);
		Assertions.assertThat(userManager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void findUserByName_NameIsNotNullAndNameExists_ReturnAUser() {
		UsersEntity userEntity = mock(UsersEntity.class);

		Mockito.when(_usersRepository.findByUserName(anyString())).thenReturn(userEntity);
		Assertions.assertThat(userManager.FindByUserName("User1")).isEqualTo(userEntity);
	}

	@Test 
	public void findUserByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {

		Mockito.when(_usersRepository.findByUserName(anyString())).thenReturn(null);
		Assertions.assertThat(userManager.FindByUserName("User1")).isEqualTo(null);
	
	}
	@Test
	public void createUser_UserIsNotNullAndUserDoesNotExist_StoreAUser() {

		UsersEntity userEntity = mock(UsersEntity.class);
		Mockito.when(_usersRepository.save(any(UsersEntity.class))).thenReturn(userEntity);
		Assertions.assertThat(userManager.Create(userEntity)).isEqualTo(userEntity);
	}

	@Test
	public void deleteUser_UserExists_RemoveAUser() {

		UsersEntity userEntity = mock(UsersEntity.class);
		userManager.Delete(userEntity);
		verify(_usersRepository).delete(userEntity);
	}

	@Test
	public void updateUser_UserIsNotNullAndUserExists_UpdateAUser() {
		
		UsersEntity userEntity = mock(UsersEntity.class);
		Mockito.when(_usersRepository.save(any(UsersEntity.class))).thenReturn(userEntity);
		Assertions.assertThat(userManager.Update(userEntity)).isEqualTo(userEntity);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<UsersEntity> user = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_usersRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(user);
		Assertions.assertThat(userManager.FindAll(predicate,pageable)).isEqualTo(user);

	}

	 //Roles
	@Test
	public void getRoles_if_UsersIdIsNotNull_returnRoles() {

		UsersEntity users = mock(UsersEntity.class);
		RolesEntity roles = mock(RolesEntity.class);

		Mockito.when(_usersRepository.findById(anyLong())).thenReturn(users);
		Mockito.when(users.getRole()).thenReturn(roles);
		Assertions.assertThat(userManager.GetRoles(ID)).isEqualTo(roles);

	}
	
    //Permissions
    @Test
	public void addPermissions_ifUsersAndPermissionsIsNotNull_PermissionsAssigned() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		
		Set<PermissionsEntity> su = users.getPermissions();
		Mockito.when(users.getPermissions()).thenReturn(su);
        Assertions.assertThat(userManager.AddPermissions(users, permissions)).isEqualTo(true);

	}

	@Test
	public void addPermissions_ifUsersAndPermissionsIsNotNullAndPermissionsAlreadyAssigned_ReturnFalse() {
		
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);
		Set<PermissionsEntity> su = users.getPermissions();
		su.add(permissions);
		
		Mockito.when(users.getPermissions()).thenReturn(su);
		Assertions.assertThat(userManager.AddPermissions(users, permissions)).isEqualTo(false);

	}

	@Test
	public void RemovePermissions_ifUsersAndPermissionsIsNotNull_PermissionsRemoved() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = mock(PermissionsEntity.class);

		userManager.RemovePermissions(users, permissions);
		verify(_usersRepository).save(users);
	}


	@Test 
	public void GetPermissions_ifUsersIdAndPermissionsIdIsNotNullAndPermissionsDoesNotExist_ReturnNull() {
		UsersEntity users = mock(UsersEntity.class);
		
		Mockito.when(_usersRepository.findById(anyLong())).thenReturn(users);
        Assertions.assertThat(userManager.GetPermissions(ID,ID)).isEqualTo(null);
	}

	@Test
	public void GetPermissions_ifUsersIdAndPermissionsIdIsNotNullAndRecordExists_ReturnPermissions() {
		UsersEntity users = mock(UsersEntity.class);
		PermissionsEntity permissions = new PermissionsEntity();
		permissions.setId(ID);
	
		Set<PermissionsEntity> permissionsList = users.getPermissions();
		permissionsList.add(permissions);

		Mockito.when(_usersRepository.findById(ID)).thenReturn(users);
		Mockito.when(users.getPermissions()).thenReturn(permissionsList);

		Assertions.assertThat(userManager.GetPermissions(ID,ID)).isEqualTo(permissions);

	}
	
    @Test
	public void FindPermissions_UsersIdIsNotNull_ReturnPermissions() {
	    Page<PermissionsEntity> permissions = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		List<SearchFields> list = mock(List.class);
		String value="equals";

		Mockito.when(_usersRepository.getAllPermissions(anyLong(),any(List.class),anyString(),any(Pageable.class))).thenReturn(permissions);
		Assertions.assertThat(_usersRepository.getAllPermissions(ID,list,value,pageable)).isEqualTo(permissions);
	}

}