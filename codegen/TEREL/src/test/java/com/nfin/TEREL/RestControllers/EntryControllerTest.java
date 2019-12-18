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
import com.nfin.TEREL.application.Entry.EntryAppService;
import com.nfin.TEREL.application.Entry.Dto.*;
import com.nfin.TEREL.domain.IRepository.IEntryRepository;
import com.nfin.TEREL.domain.model.EntryEntity;
import com.nfin.TEREL.domain.IRepository.IBlogRepository;
import com.nfin.TEREL.domain.model.BlogEntity;
import com.nfin.TEREL.application.Blog.BlogAppService;    
import com.nfin.TEREL.application.EntryTag.EntryTagAppService;    

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class EntryControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private IEntryRepository entry_repository;
	
	@Autowired 
	private IBlogRepository blogRepository;
	
	@SpyBean
	private EntryAppService entryAppService;
    
    @SpyBean
	private BlogAppService blogAppService;
    
    @SpyBean
	private EntryTagAppService entryTagAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private EntryEntity entry;

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
    em.createNativeQuery("drop table blog.EntryTag CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.Entry CASCADE").executeUpdate();
	em.getTransaction().commit();
	}

	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}

	public static EntryEntity createEntity() {
		EntryEntity entry = new EntryEntity();
  		entry.setContent("1");
		entry.setDate(new Date());
		entry.setEntryId(1L);
  		entry.setTitle("1");
		return entry;
		 
	}

	public static CreateEntryInput createEntryInput() {
		CreateEntryInput entry = new CreateEntryInput();
		
  		entry.setContent("2");
		entry.setDate(new Date());
  		entry.setTitle("2");
		
		return entry;
	}

	public static EntryEntity createNewEntity() {
		EntryEntity entry = new EntryEntity();
  		entry.setContent("3");
		entry.setDate(new Date());
		entry.setEntryId(3L);
  		entry.setTitle("3");
		return entry;
	}

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);

		evictAllCaches();
		final EntryController entryController = new EntryController(entryAppService,blogAppService,entryTagAppService,
	logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup(entryController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		entry= createEntity();
		List<EntryEntity> list= entry_repository.findAll();
		if(list.isEmpty())
			entry_repository.save(entry);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/entry/1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/entry/111")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
		@Test
	public void CreateEntry_EntryDoesNotExist_ReturnStatusOk() throws Exception {
		CreateEntryInput entry = createEntryInput();
		 ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(entry);

		mvc.perform(post("/entry").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}     

	@Test
	public void DeleteEntry_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        doReturn(null).when(entryAppService).FindById(111L);
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/entry/111")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a entry with a id=111"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		EntryEntity entity = entry_repository.save(createNewEntity());

		FindEntryByIdOutput output= new FindEntryByIdOutput();
  		output.setContent(entity.getContent());
  		output.setDate(entity.getDate());
  		output.setEntryId(entity.getEntryId());
  		output.setTitle(entity.getTitle());

        Mockito.when(entryAppService.FindById(entity.getEntryId())).thenReturn(output);
        
		mvc.perform(delete("/entry/" + entity.getEntryId())
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void UpdateEntry_EntryDoesNotExist_ReturnStatusNotFound() throws Exception {

        doReturn(null).when(entryAppService).FindById(111L);

		UpdateEntryInput entry = new UpdateEntryInput();
  		entry.setContent("111");
		entry.setDate(new Date());
		entry.setEntryId(111L);
  		entry.setTitle("111");

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(entry);
		mvc.perform(put("/entry/111").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void UpdateEntry_EntryExists_ReturnStatusOk() throws Exception {
		EntryEntity entity = entry_repository.save(createNewEntity());
		FindEntryByIdOutput output= new FindEntryByIdOutput();
        
  		output.setContent(entity.getContent());
  		output.setDate(entity.getDate());
  		output.setEntryId(entity.getEntryId());
  		output.setTitle(entity.getTitle());

        Mockito.when(entryAppService.FindById(entity.getEntryId())).thenReturn(output);
        
		UpdateEntryInput entry = new UpdateEntryInput();
  		entry.setContent(entity.getContent());
  		entry.setDate(entity.getDate());
  		entry.setEntryId(entity.getEntryId());
  		entry.setTitle(entity.getTitle());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(entryrole);
	
		mvc.perform(put("/entry/" + entity.getEntryId()).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		EntryEntity de = createEntity();
		de.setEntryId(entity.getEntryId());
		entry_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/entry?search=entryId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/entry?search=entryentryId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property entryentryId not found!"));

	} 
	
	@Test
	public void GetBlog_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/entry/111/blog")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetBlog_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/entry/1/blog")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	@Test
	public void GetEntryTag_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("entryId", "1");

		Mockito.when(entryAppService.parseEntryTagJoinColumn("entryId")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/entry/1/entryTag?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetEntryTag_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("entryId", "1");
		
        Mockito.when(entryAppService.parseEntryTagJoinColumn("entryId")).thenReturn(joinCol);
		mvc.perform(get("/entry/1/entryTag?search=entryId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetEntryTag_searchIsNotEmpty() throws Exception {
	
		Mockito.when(entryAppService.parseEntryTagJoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/entry/1/entryTag?search=entryid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
    

}
