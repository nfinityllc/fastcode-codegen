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
import com.nfin.TEREL.application.EntryTag.EntryTagAppService;
import com.nfin.TEREL.application.EntryTag.Dto.*;
import com.nfin.TEREL.domain.IRepository.IEntryTagRepository;
import com.nfin.TEREL.domain.model.EntryTagEntity;
import com.nfin.TEREL.domain.IRepository.ITagRepository;
import com.nfin.TEREL.domain.model.TagEntity;
import com.nfin.TEREL.domain.IRepository.IEntryRepository;
import com.nfin.TEREL.domain.model.EntryEntity;
import com.nfin.TEREL.application.Tag.TagAppService;    
import com.nfin.TEREL.application.Entry.EntryAppService;    
import com.nfin.TEREL.domain.model.EntryTagId;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class EntryTagControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private IEntryTagRepository entryTag_repository;
	
	@Autowired 
	private ITagRepository tagRepository;
	
	@Autowired 
	private IEntryRepository entryRepository;
	
	@SpyBean
	private EntryTagAppService entryTagAppService;
    
    @SpyBean
	private TagAppService tagAppService;
    
    @SpyBean
	private EntryAppService entryAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private EntryTagEntity entryTag;

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
	em.createNativeQuery("drop table blog.Tag CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.Tag CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.Entry CASCADE").executeUpdate();
    em.createNativeQuery("drop table blog.Entry CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.EntryTag CASCADE").executeUpdate();
	em.getTransaction().commit();
	}

	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}

	public static EntryTagEntity createEntity() {
		EntryTagEntity entryTag = new EntryTagEntity();
		entryTag.setEntryId(1L);
		entryTag.setTagId(1L);
		return entryTag;
		 
	}

	public static CreateEntryTagInput createEntryTagInput() {
		CreateEntryTagInput entryTag = new CreateEntryTagInput();
		
		entryTag.setEntryId(2L);
		entryTag.setTagId(2L);
		
		return entryTag;
	}

	public static EntryTagEntity createNewEntity() {
		EntryTagEntity entryTag = new EntryTagEntity();
		entryTag.setEntryId(3L);
		entryTag.setTagId(3L);
		return entryTag;
	}

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);

		evictAllCaches();
		final EntryTagController entryTagController = new EntryTagController(entryTagAppService,tagAppService,entryAppService,
	logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup(entryTagController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		entryTag= createEntity();
		List<EntryTagEntity> list= entryTag_repository.findAll();
		if(list.isEmpty())
			entryTag_repository.save(entryTag);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/entryTag/entryId:1,tagId:1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/entryTag/entryId:111,tagId:111")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
		@Test
	public void CreateEntryTag_EntryTagDoesNotExist_ReturnStatusOk() throws Exception {
		CreateEntryTagInput entryTag = createEntryTagInput();
		 ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(entryTag);

		mvc.perform(post("/entryTag").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}     

	@Test
	public void DeleteEntryTag_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        doReturn(null).when(entryTagAppService).FindById(new EntryTagId(111L, 111L));
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/entryTag/entryId:111,tagId:111")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a entryTag with a id=entryId:111,tagId:111"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		EntryTagEntity entity = entryTag_repository.save(createNewEntity());

		FindEntryTagByIdOutput output= new FindEntryTagByIdOutput();
  		output.setEntryId(entity.getEntryId());
  		output.setTagId(entity.getTagId());

	    Mockito.when(entryTagAppService.FindById(new EntryTagId(entity.getEntryId(), entity.getTagId()))).thenReturn(output);
       
		mvc.perform(delete("/entryTag/entryId:"+ entity.getEntryId()+ ",tagId:"+ entity.getTagId())
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void UpdateEntryTag_EntryTagDoesNotExist_ReturnStatusNotFound() throws Exception {

        doReturn(null).when(entryTagAppService).FindById(new EntryTagId(111L, 111L));

		UpdateEntryTagInput entryTag = new UpdateEntryTagInput();
		entryTag.setEntryId(111L);
		entryTag.setTagId(111L);

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(entryTag);
		mvc.perform(put("/entryTag/entryId:111,tagId:111").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void UpdateEntryTag_EntryTagExists_ReturnStatusOk() throws Exception {
		EntryTagEntity entity = entryTag_repository.save(createNewEntity());
		FindEntryTagByIdOutput output= new FindEntryTagByIdOutput();
        
  		output.setEntryId(entity.getEntryId());
  		output.setTagId(entity.getTagId());

	    Mockito.when(entryTagAppService.FindById(new EntryTagId(entity.getEntryId(), entity.getTagId()))).thenReturn(output);
        
		UpdateEntryTagInput entryTag = new UpdateEntryTagInput();
  		entryTag.setEntryId(entity.getEntryId());
  		entryTag.setTagId(entity.getTagId());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(entryTagrole);
	
		mvc.perform(put("/entryTag/entryId:"+ entity.getEntryId()+ ",tagId:"+ entity.getTagId()).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		EntryTagEntity de = createEntity();
		de.setEntryId(entity.getEntryId());
		de.setTagId(entity.getTagId());
		entryTag_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/entryTag?search=entryId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/entryTag?search=entryTagentryId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property entryTagentryId not found!"));

	} 
	
	@Test
	public void GetTag_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/entryTag/entryId:111/tag")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=entryId:111"));
	
	}    
	@Test
	public void GetTag_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/entryTag/entryId:111,tagId:111/tag")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetTag_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/entryTag/entryId:1,tagId:1/tag")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	@Test
	public void GetEntry_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/entryTag/entryId:111/entry")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=entryId:111"));
	
	}    
	@Test
	public void GetEntry_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/entryTag/entryId:111,tagId:111/entry")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetEntry_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/entryTag/entryId:1,tagId:1/entry")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
    

}
