package [=PackageName].application.Email;

import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.doNothing;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].application.Email.Dto.*;
import [=PackageName].domain.Email.*;
import [=PackageName].domain.Email.QEmailEntity;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class EmailAppServiceTest {

	@InjectMocks
	EmailAppService emailAppService;
	
	@Mock
	private IEmailManager emailManager;
	
	@Mock
	private EmailMapper emailMapper;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(emailAppService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test 
	public void findEmailById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
		
		Mockito.when(emailManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(emailAppService.FindById(ID)).isEqualTo(null);	 
	}

	@Test
	public void findEmailById_IdIsNotNullAndIdExists_ReturnEmail() {

		EmailEntity email = mock(EmailEntity.class);

		Mockito.when(emailManager.FindById(anyLong())).thenReturn(email);
		Assertions.assertThat(emailAppService.FindById(ID)).isEqualTo(emailMapper.EmailEntityToCreateEmailOutput(email));
	}

	@Test 
	public void findEmailByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {
		
		Mockito.when(emailManager.FindByName(anyString())).thenReturn(null);	
		Assertions.assertThat(emailAppService.FindByName("Email1")).isEqualTo(null);	
	}

	@Test
	public void findEmailByName_NameIsNotNullAndNameExists_ReturnEmail() {

		EmailEntity email = mock(EmailEntity.class);

		Mockito.when(emailManager.FindByName(anyString())).thenReturn(email);
		Assertions.assertThat(emailAppService.FindByName("Email1")).isEqualTo(emailMapper.EmailEntityToCreateEmailOutput(email));
	}

	@Test
	public void createEmail_EmailIsNotNullAndEmailDoesNotExist_StoreEmail() {

		EmailEntity emailEntity = mock(EmailEntity.class);
		CreateEmailInput email= mock(CreateEmailInput.class);

		Mockito.when(emailMapper.CreateEmailInputToEmailEntity(any(CreateEmailInput.class))).thenReturn(emailEntity);
		Mockito.when(emailManager.Create(any(EmailEntity.class))).thenReturn(emailEntity);
		Assertions.assertThat(emailAppService.Create(email)).isEqualTo(emailMapper.EmailEntityToCreateEmailOutput(emailEntity));
	}

	@Test
	public void deleteEmail_EmailIsNotNullAndEmailExists_EmailRemoved() {

		EmailEntity email = mock(EmailEntity.class);

		Mockito.when(emailManager.FindById(anyLong())).thenReturn(email);
		emailAppService.Delete(ID);
		verify(emailManager).Delete(email);
	}

	@Test
	public void updateEmail_EmailIdIsNotNullAndIdExists_ReturnUpdatedEmail() {

		EmailEntity emailEntity = mock(EmailEntity.class);
		UpdateEmailInput email=mock(UpdateEmailInput.class);

		Mockito.when(emailMapper.UpdateEmailInputToEmailEntity(any(UpdateEmailInput.class))).thenReturn(emailEntity);
		Mockito.when(emailManager.Update(any(EmailEntity.class))).thenReturn(emailEntity);
		Assertions.assertThat(emailAppService.Update(ID,email)).isEqualTo(emailMapper.EmailEntityToUpdateEmailOutput(emailEntity));
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception
	{
		List<EmailEntity> list = new ArrayList<>();
		Page<EmailEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);

		List<FindEmailByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(emailManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(emailAppService.Find(search,pageable)).isEqualTo(output);
	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception
	{
		List<EmailEntity> list = new ArrayList<>();
		EmailEntity email=mock(EmailEntity.class);
		list.add(email);
		Page<EmailEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		
		List<FindEmailByIdOutput> output = new ArrayList<>();
		output.add(emailMapper.EmailEntityToFindEmailByIdOutput(email));
		Mockito.when(emailManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(emailAppService.Find(search,pageable)).isEqualTo(output);
	}
	
	@Test
	public void  searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder()
	{
		String search= "xyz";
		String operator= "equals";
		QEmailEntity email = QEmailEntity.emailEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(email.templateName.eq(search));
		builder.or(email.category.eq(search));
		builder.or(email.to.eq(search));
		builder.or(email.cc.eq(search));
		builder.or(email.bcc.eq(search));
		builder.or(email.subject.eq(search));

		Assertions.assertThat(emailAppService.searchAllProperties(email,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder()
	{
		String operator= "equals";
		List<String> list = new ArrayList<>();
		list.add("templateName");
		list.add("category");
	
		QEmailEntity email = QEmailEntity.emailEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(email.templateName.eq("xyz"));
		builder.or(email.category.eq("xyz"));

		Assertions.assertThat(emailAppService.searchSpecificProperty(email,list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder()
	{
		QEmailEntity email = QEmailEntity.emailEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
		Map<String,SearchFields> map = new HashMap();
		map.put("templateName", searchFields);
		
        BooleanBuilder builder = new BooleanBuilder();
        builder.and(email.templateName.eq("xyz"));
        
        Assertions.assertThat(emailAppService.searchKeyValuePair(email, map)).isEqualTo(builder);
	}

	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("xyz");

		emailAppService.checkProperties(list);
	}
	
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("templateName");

		emailAppService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception
	{
		QEmailEntity email = QEmailEntity.emailEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
        BooleanBuilder builder = new BooleanBuilder();
        builder.or(email.templateName.eq("xyz"));
		builder.or(email.category.eq("xyz"));
		builder.or(email.to.eq("xyz"));
		builder.or(email.cc.eq("xyz"));
		builder.or(email.bcc.eq("xyz"));
		builder.or(email.subject.eq("xyz"));

        Assertions.assertThat(emailAppService.Search(search)).isEqualTo(builder);  
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception
	{
		QEmailEntity email = QEmailEntity.emailEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
		fields.setFieldName("templateName");
        fieldsList.add(fields);
        search.setFields(fieldsList);
    	BooleanBuilder builder = new BooleanBuilder();
    	builder.or(email.templateName.eq("xyz"));

        Assertions.assertThat(emailAppService.Search(search)).isEqualTo(builder);  
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception
	{
		Map<String,SearchFields> map = new HashMap<>();
		QEmailEntity email = QEmailEntity.emailEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		search.setValue("xyz");
		search.setOperator("equals");
		fields.setFieldName("templateName");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
    	BooleanBuilder builder = new BooleanBuilder();
    	builder.or(email.templateName.eq("xyz"));
    	
        Assertions.assertThat(emailAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_StringIsNull_ReturnNull() throws Exception
	{
		 Assertions.assertThat(emailAppService.Search(null)).isEqualTo(null);
	}
	
}
