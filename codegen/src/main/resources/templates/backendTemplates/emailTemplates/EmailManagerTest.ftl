package [=PackageName].domain.Email;

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

import [=PackageName].domain.IRepository.IEmailRepository;
import [=PackageName].domain.model.EmailEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class EmailManagerTest {

	@InjectMocks
	IEmailManager emailManager;
	
	@Mock
	IEmailRepository  _emailRepository;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(emailManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findEmailById_IdIsNotNullAndIdExists_ReturnEmail() {
		EmailEntity email =mock(EmailEntity.class);

		Mockito.when(_emailRepository.findById(anyLong())).thenReturn(email);
		Assertions.assertThat(emailManager.FindById(ID)).isEqualTo(email);
	}

	@Test 
	public void findEmailById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	Mockito.when(_emailRepository.findById(anyLong())).thenReturn(null);
	Assertions.assertThat(emailManager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void findEmailByName_NameIsNotNullAndNameExists_ReturnEmail() {
		EmailEntity email =mock(EmailEntity.class);

		Mockito.when(_emailRepository.findByEmailName(anyString())).thenReturn(email);
		Assertions.assertThat(emailManager.FindByName("xyz")).isEqualTo(email);
	}

	@Test 
	public void findEmailByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {

		Mockito.when(_emailRepository.findByEmailName(anyString())).thenReturn(null);
		Assertions.assertThat(emailManager.FindByName("xyz")).isEqualTo(null);
	
	}
	
	@Test
	public void createEmail_EmailIsNotNullAndEmailDoesNotExist_StoreEmail() {

		EmailEntity email =mock(EmailEntity.class);
		Mockito.when(_emailRepository.save(any(EmailEntity.class))).thenReturn(email);
		Assertions.assertThat(emailManager.Create(email)).isEqualTo(email);
	}

	@Test
	public void deleteEmail_EmailExists_RemoveEmail() {

		EmailEntity email =mock(EmailEntity.class);
		emailManager.Delete(email);
		verify(_emailRepository).delete(email);
	}

	@Test
	public void updateEmail_EmailIsNotNullAndEmailExists_UpdateEmail() {
		
		EmailEntity email =mock(EmailEntity.class);
		Mockito.when(_emailRepository.save(any(EmailEntity.class))).thenReturn(email);
		Assertions.assertThat(emailManager.Update(email)).isEqualTo(email);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<EmailEntity> email = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_emailRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(email);
		Assertions.assertThat(emailManager.FindAll(predicate,pageable)).isEqualTo(email);
	}
}
