package com.nfin.TEREL.RestControllers;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import javax.persistence.EntityExistsException;

import java.util.List;
import java.util.Date;
import java.util.Map;
import java.util.HashMap;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
import org.springframework.cache.CacheManager;
import org.springframework.data.web.SortHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.nfin.TEREL.CommonModule.logging.LoggingHelper;
import com.nfin.TEREL.application.Authorization.User.UserAppService;
import com.nfin.TEREL.application.Authorization.User.Dto.*;
import com.nfin.TEREL.domain.IRepository.IUserRepository;
import com.nfin.TEREL.domain.model.UserEntity;
import com.nfin.TEREL.application.Blog.BlogAppService;    
import com.nfin.TEREL.application.Subscription.SubscriptionAppService;    
import org.springframework.security.crypto.password.PasswordEncoder;
import com.nfin.TEREL.application.Authorization.Userrole.UserroleAppService;
import com.nfin.TEREL.application.Authorization.Userrole.Dto.FindUserroleByIdOutput;
import com.nfin.TEREL.application.Authorization.Userpermission.UserpermissionAppService;
import com.nfin.TEREL.application.Authorization.Userpermission.Dto.FindUserpermissionByIdOutput;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private IUserRepository user_repository;
	
	@SpyBean
	private UserAppService userAppService;
    
    @SpyBean
	private BlogAppService blogAppService;
    
    @SpyBean
	private SubscriptionAppService subscriptionAppService;
    
	@SpyBean
    private PasswordEncoder pEncoder;

	@SpyBean
    private UserpermissionAppService userpermissionAppService;
    
    @SpyBean
    private UserroleAppService userroleAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private UserEntity user;

	private MockMvc mvc;
	
	@Autowired
	EntityManagerFactory emf;
	
    static EntityManagerFactory emfs;
	
	@PostConstruct
	public void init() {
	this.emfs = emf;
	}

	@AfterClass
	public static void cleanup() {
	EntityManager em = emfs.createEntityManager();
	em.getTransaction().begin();
	em.createNativeQuery("drop table blog.userpermission CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.Blog CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.Subscription CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.User CASCADE").executeUpdate();
	em.getTransaction().commit();
	}

	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}

	public static UserEntity createEntity() {
		UserEntity user = new UserEntity();
  		user.setEmailAddress("1");
  		user.setFirstName("1");
  		user.setLastName("1");
  		user.setPassword("1");
		user.setUserId(1L);
  		user.setUserName("1");
		return user;
		 
	}

	public static CreateUserInput createUserInput() {
		CreateUserInput user = new CreateUserInput();
		
  		user.setEmailAddress("2");
  		user.setFirstName("2");
  		user.setLastName("2");
  		user.setPassword("2");
  		user.setUserName("2");
		
		return user;
	}

	public static UserEntity createNewEntity() {
		UserEntity user = new UserEntity();
  		user.setEmailAddress("3");
  		user.setFirstName("3");
  		user.setLastName("3");
  		user.setPassword("3");
		user.setUserId(3L);
  		user.setUserName("3");
		return user;
	}

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);

		evictAllCaches();
		final UserController userController = new UserController(userAppService,blogAppService,subscriptionAppService,
	pEncoder, userpermissionAppService,userroleAppService,logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup(userController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		user= createEntity();
		List<UserEntity> list= user_repository.findAll();
		if(list.isEmpty())
			user_repository.save(user);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/user/1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/user/111")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
	public void CreateUser_UserDoesNotExist_ReturnStatusOk() throws Exception {
        Mockito.doReturn(null).when(userAppService).FindByUserName(anyString());
	  
		CreateUserInput user = createUserInput();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
		
		mvc.perform(post("/user").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk());
		 
		 user_repository.delete(createNewEntity());
	}  

	@Test
	public void CreateUser_UserAlreadyExists_ThrowEntityExistsException() throws Exception {
	    FindUserByUserNameOutput output= new FindUserByUserNameOutput();
  		output.setEmailAddress("1");
  		output.setFirstName("1");
  		output.setLastName("1");
		output.setUserId(1L);
  		output.setUserName("1");

        Mockito.doReturn(output).when(userAppService).FindByUserName(anyString());
	    CreateUserInput user = createUserInput();
	    ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
       
        org.assertj.core.api.Assertions.assertThatThrownBy(() -> mvc.perform(post("/user")
        		.contentType(MediaType.APPLICATION_JSON).content(json))
         .andExpect(status().isOk())).hasCause(new EntityExistsException("There already exists a user with UserName=" + user.getUserName()));
	} 

	@Test
	public void DeleteUser_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        doReturn(null).when(userAppService).FindById(111L);
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/user/111")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a user with a id=111"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		UserEntity entity = user_repository.save(createNewEntity());

		FindUserByIdOutput output= new FindUserByIdOutput();
  		output.setEmailAddress(entity.getEmailAddress());
  		output.setFirstName(entity.getFirstName());
  		output.setLastName(entity.getLastName());
  		output.setUserId(entity.getUserId());
  		output.setUserName(entity.getUserName());

        Mockito.when(userAppService.FindById(entity.getUserId())).thenReturn(output);
        
		mvc.perform(delete("/user/" + entity.getUserId())
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void UpdateUser_UserDoesNotExist_ReturnStatusNotFound() throws Exception {

        doReturn(null).when(userAppService).FindById(111L);

		UpdateUserInput user = new UpdateUserInput();
  		user.setEmailAddress("111");
  		user.setFirstName("111");
  		user.setLastName("111");
		user.setUserId(111L);
  		user.setUserName("111");

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
		mvc.perform(put("/user/111").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void UpdateUser_UserExists_ReturnStatusOk() throws Exception {
		UserEntity entity = user_repository.save(createNewEntity());
		FindUserWithAllFieldsByIdOutput output= new FindUserWithAllFieldsByIdOutput();
        
  		output.setEmailAddress(entity.getEmailAddress());
  		output.setFirstName(entity.getFirstName());
  		output.setLastName(entity.getLastName());
  		output.setPassword(entity.getPassword());
  		output.setUserId(entity.getUserId());
  		output.setUserName(entity.getUserName());

		Mockito.when(userAppService.FindWithAllFieldsById(entity.getUserId())).thenReturn(output);
		UpdateUserInput user = new UpdateUserInput();
  		user.setEmailAddress(entity.getEmailAddress());
  		user.setFirstName(entity.getFirstName());
  		user.setLastName(entity.getLastName());
  		user.setPassword(entity.getPassword());
  		user.setUserId(entity.getUserId());
  		user.setUserName(entity.getUserName());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(userrole);
	
		mvc.perform(put("/user/" + entity.getUserId()).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		UserEntity de = createEntity();
		de.setUserId(entity.getUserId());
		user_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/user?search=userId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user?search=useruserId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property useruserId not found!"));

	} 
	
	@Test
	public void GetBlog_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("creatorId", "1");

		Mockito.when(userAppService.parseBlogJoinColumn("creatorId")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user/1/blog?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetBlog_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("creatorId", "1");
		
        Mockito.when(userAppService.parseBlogJoinColumn("creatorId")).thenReturn(joinCol);
		mvc.perform(get("/user/1/blog?search=creatorId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetBlog_searchIsNotEmpty() throws Exception {
	
		Mockito.when(userAppService.parseBlogJoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/user/1/blog?search=creatorid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	@Test
	public void GetSubscription_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("userId", "1");

		Mockito.when(userAppService.parseSubscriptionJoinColumn("userId")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user/1/subscription?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetSubscription_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("userId", "1");
		
        Mockito.when(userAppService.parseSubscriptionJoinColumn("userId")).thenReturn(joinCol);
		mvc.perform(get("/user/1/subscription?search=userId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetSubscription_searchIsNotEmpty() throws Exception {
	
		Mockito.when(userAppService.parseSubscriptionJoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/user/1/subscription?search=userid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
    
	@Test
	public void GetUserrole_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		
		Mockito.when(userAppService.parseUserroleJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user/2/userrole?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetUserrole_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleId", "1");

		Mockito.when(userAppService.parseUserroleJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/user/1/userrole?search=roleId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetUserrole_searchIsNotEmpty() throws Exception {
	
		Mockito.when(userAppService.parseUserroleJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/user/1/userrole?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}      
	 
	@Test
	public void GetUserpermission_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("permissionid", "1");
		
		Mockito.when(userAppService.parseUserpermissionJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user/2/userpermission?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetUserpermission_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("permissionId", "1");

		Mockito.when(userAppService.parseUserpermissionJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/user/1/userpermission?search=permissionId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetUserpermission_searchIsNotEmpty() throws Exception {
	
		Mockito.when(userAppService.parseUserpermissionJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/user/1/userpermission?search=permissionid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}      

}
