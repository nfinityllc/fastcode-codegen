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
import com.nfin.TEREL.application.Subscription.SubscriptionAppService;
import com.nfin.TEREL.application.Subscription.Dto.*;
import com.nfin.TEREL.domain.IRepository.ISubscriptionRepository;
import com.nfin.TEREL.domain.model.SubscriptionEntity;
import com.nfin.TEREL.domain.IRepository.IBlogRepository;
import com.nfin.TEREL.domain.model.BlogEntity;
import com.nfin.TEREL.domain.IRepository.IUserRepository;
import com.nfin.TEREL.domain.model.UserEntity;
import com.nfin.TEREL.application.Blog.BlogAppService;    
import com.nfin.TEREL.application.Authorization.User.UserAppService;    
import com.nfin.TEREL.domain.model.SubscriptionId;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class SubscriptionControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private ISubscriptionRepository subscription_repository;
	
	@Autowired 
	private IBlogRepository blogRepository;
	
	@Autowired 
	private IUserRepository userRepository;
	
	@SpyBean
	private SubscriptionAppService subscriptionAppService;
    
    @SpyBean
	private BlogAppService blogAppService;
    
    @SpyBean
	private UserAppService userAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private SubscriptionEntity subscription;

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
	em.createNativeQuery("drop table blog.Blog CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.Blog CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.User CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.User CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.Subscription CASCADE").executeUpdate();
	em.getTransaction().commit();
	}

	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}

	public static SubscriptionEntity createEntity() {
		SubscriptionEntity subscription = new SubscriptionEntity();
		subscription.setBlogId(1L);
		subscription.setUserId(1L);
		return subscription;
		 
	}

	public static CreateSubscriptionInput createSubscriptionInput() {
		CreateSubscriptionInput subscription = new CreateSubscriptionInput();
		
		subscription.setBlogId(2L);
		subscription.setUserId(2L);
		
		return subscription;
	}

	public static SubscriptionEntity createNewEntity() {
		SubscriptionEntity subscription = new SubscriptionEntity();
		subscription.setBlogId(3L);
		subscription.setUserId(3L);
		return subscription;
	}

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);

		evictAllCaches();
		final SubscriptionController subscriptionController = new SubscriptionController(subscriptionAppService,blogAppService,userAppService,
	logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup(subscriptionController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		subscription= createEntity();
		List<SubscriptionEntity> list= subscription_repository.findAll();
		if(list.isEmpty())
			subscription_repository.save(subscription);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/subscription/blogId:1,userId:1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/subscription/blogId:111,userId:111")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
		@Test
	public void CreateSubscription_SubscriptionDoesNotExist_ReturnStatusOk() throws Exception {
		CreateSubscriptionInput subscription = createSubscriptionInput();
		 ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(subscription);

		mvc.perform(post("/subscription").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}     

	@Test
	public void DeleteSubscription_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        doReturn(null).when(subscriptionAppService).FindById(new SubscriptionId(111L, 111L));
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/subscription/blogId:111,userId:111")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a subscription with a id=blogId:111,userId:111"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		SubscriptionEntity entity = subscription_repository.save(createNewEntity());

		FindSubscriptionByIdOutput output= new FindSubscriptionByIdOutput();
  		output.setBlogId(entity.getBlogId());
  		output.setUserId(entity.getUserId());

	    Mockito.when(subscriptionAppService.FindById(new SubscriptionId(entity.getBlogId(), entity.getUserId()))).thenReturn(output);
       
		mvc.perform(delete("/subscription/blogId:"+ entity.getBlogId()+ ",userId:"+ entity.getUserId())
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void UpdateSubscription_SubscriptionDoesNotExist_ReturnStatusNotFound() throws Exception {

        doReturn(null).when(subscriptionAppService).FindById(new SubscriptionId(111L, 111L));

		UpdateSubscriptionInput subscription = new UpdateSubscriptionInput();
		subscription.setBlogId(111L);
		subscription.setUserId(111L);

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(subscription);
		mvc.perform(put("/subscription/blogId:111,userId:111").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void UpdateSubscription_SubscriptionExists_ReturnStatusOk() throws Exception {
		SubscriptionEntity entity = subscription_repository.save(createNewEntity());
		FindSubscriptionByIdOutput output= new FindSubscriptionByIdOutput();
        
  		output.setBlogId(entity.getBlogId());
  		output.setUserId(entity.getUserId());

	    Mockito.when(subscriptionAppService.FindById(new SubscriptionId(entity.getBlogId(), entity.getUserId()))).thenReturn(output);
        
		UpdateSubscriptionInput subscription = new UpdateSubscriptionInput();
  		subscription.setBlogId(entity.getBlogId());
  		subscription.setUserId(entity.getUserId());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(subscriptionrole);
	
		mvc.perform(put("/subscription/blogId:"+ entity.getBlogId()+ ",userId:"+ entity.getUserId()).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		SubscriptionEntity de = createEntity();
		de.setBlogId(entity.getBlogId());
		de.setUserId(entity.getUserId());
		subscription_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/subscription?search=blogId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/subscription?search=subscriptionblogId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property subscriptionblogId not found!"));

	} 
	
	@Test
	public void GetBlog_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/subscription/blogId:111/blog")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=blogId:111"));
	
	}    
	@Test
	public void GetBlog_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/subscription/blogId:111,userId:111/blog")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetBlog_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/subscription/blogId:1,userId:1/blog")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	@Test
	public void GetUser_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/subscription/blogId:111/user")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=blogId:111"));
	
	}    
	@Test
	public void GetUser_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/subscription/blogId:111,userId:111/user")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetUser_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/subscription/blogId:1,userId:1/user")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
    

}
