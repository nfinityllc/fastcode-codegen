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
import com.nfin.TEREL.application.Blog.BlogAppService;
import com.nfin.TEREL.application.Blog.Dto.*;
import com.nfin.TEREL.domain.IRepository.IBlogRepository;
import com.nfin.TEREL.domain.model.BlogEntity;
import com.nfin.TEREL.domain.IRepository.IUserRepository;
import com.nfin.TEREL.domain.model.UserEntity;
import com.nfin.TEREL.application.Subscription.SubscriptionAppService;    
import com.nfin.TEREL.application.Authorization.User.UserAppService;    
import com.nfin.TEREL.application.Entry.EntryAppService;    

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class BlogControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private IBlogRepository blog_repository;
	
	@Autowired 
	private IUserRepository userRepository;
	
	@SpyBean
	private BlogAppService blogAppService;
    
    @SpyBean
	private SubscriptionAppService subscriptionAppService;
    
    @SpyBean
	private UserAppService userAppService;
    
    @SpyBean
	private EntryAppService entryAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private BlogEntity blog;

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
    em.createNativeQuery("drop table blog.Subscription CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.User CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.User CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.Entry CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.Blog CASCADE").executeUpdate();
	em.getTransaction().commit();
	}

	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}

	public static BlogEntity createEntity() {
		BlogEntity blog = new BlogEntity();
		blog.setBlogId(1L);
  		blog.setHandle("1");
  		blog.setName("1");
		return blog;
		 
	}

	public static CreateBlogInput createBlogInput() {
		CreateBlogInput blog = new CreateBlogInput();
		
  		blog.setHandle("2");
  		blog.setName("2");
		
		return blog;
	}

	public static BlogEntity createNewEntity() {
		BlogEntity blog = new BlogEntity();
		blog.setBlogId(3L);
  		blog.setHandle("3");
  		blog.setName("3");
		return blog;
	}

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);

		evictAllCaches();
		final BlogController blogController = new BlogController(blogAppService,subscriptionAppService,userAppService,entryAppService,
	logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup(blogController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		blog= createEntity();
		List<BlogEntity> list= blog_repository.findAll();
		if(list.isEmpty())
			blog_repository.save(blog);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/blog/1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/blog/111")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
		@Test
	public void CreateBlog_BlogDoesNotExist_ReturnStatusOk() throws Exception {
		CreateBlogInput blog = createBlogInput();
		 ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(blog);

		mvc.perform(post("/blog").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}     

	@Test
	public void DeleteBlog_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        doReturn(null).when(blogAppService).FindById(111L);
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/blog/111")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a blog with a id=111"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		BlogEntity entity = blog_repository.save(createNewEntity());

		FindBlogByIdOutput output= new FindBlogByIdOutput();
  		output.setBlogId(entity.getBlogId());
  		output.setHandle(entity.getHandle());
  		output.setName(entity.getName());

        Mockito.when(blogAppService.FindById(entity.getBlogId())).thenReturn(output);
        
		mvc.perform(delete("/blog/" + entity.getBlogId())
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void UpdateBlog_BlogDoesNotExist_ReturnStatusNotFound() throws Exception {

        doReturn(null).when(blogAppService).FindById(111L);

		UpdateBlogInput blog = new UpdateBlogInput();
		blog.setBlogId(111L);
  		blog.setHandle("111");
  		blog.setName("111");

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(blog);
		mvc.perform(put("/blog/111").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void UpdateBlog_BlogExists_ReturnStatusOk() throws Exception {
		BlogEntity entity = blog_repository.save(createNewEntity());
		FindBlogByIdOutput output= new FindBlogByIdOutput();
        
  		output.setBlogId(entity.getBlogId());
  		output.setHandle(entity.getHandle());
  		output.setName(entity.getName());

        Mockito.when(blogAppService.FindById(entity.getBlogId())).thenReturn(output);
        
		UpdateBlogInput blog = new UpdateBlogInput();
  		blog.setBlogId(entity.getBlogId());
  		blog.setHandle(entity.getHandle());
  		blog.setName(entity.getName());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(blogrole);
	
		mvc.perform(put("/blog/" + entity.getBlogId()).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		BlogEntity de = createEntity();
		de.setBlogId(entity.getBlogId());
		blog_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/blog?search=blogId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/blog?search=blogblogId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property blogblogId not found!"));

	} 
	
	@Test
	public void GetSubscription_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("blogId", "1");

		Mockito.when(blogAppService.parseSubscriptionJoinColumn("blogId")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/blog/1/subscription?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetSubscription_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("blogId", "1");
		
        Mockito.when(blogAppService.parseSubscriptionJoinColumn("blogId")).thenReturn(joinCol);
		mvc.perform(get("/blog/1/subscription?search=blogId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetSubscription_searchIsNotEmpty() throws Exception {
	
		Mockito.when(blogAppService.parseSubscriptionJoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/blog/1/subscription?search=blogid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	@Test
	public void GetUser_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/blog/111/user")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetUser_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/blog/1/user")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	@Test
	public void GetEntry_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("blogId", "1");

		Mockito.when(blogAppService.parseEntryJoinColumn("blogId")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/blog/1/entry?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetEntry_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("blogId", "1");
		
        Mockito.when(blogAppService.parseEntryJoinColumn("blogId")).thenReturn(joinCol);
		mvc.perform(get("/blog/1/entry?search=blogId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetEntry_searchIsNotEmpty() throws Exception {
	
		Mockito.when(blogAppService.parseEntryJoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/blog/1/entry?search=blogid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
    

}
