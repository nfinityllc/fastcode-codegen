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
import com.nfin.TEREL.application.Tag.TagAppService;
import com.nfin.TEREL.application.Tag.Dto.*;
import com.nfin.TEREL.domain.IRepository.ITagRepository;
import com.nfin.TEREL.domain.model.TagEntity;
import com.nfin.TEREL.application.EntryTag.EntryTagAppService;    

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class TagControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private ITagRepository tag_repository;
	
	@SpyBean
	private TagAppService tagAppService;
    
    @SpyBean
	private EntryTagAppService entryTagAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private TagEntity tag;

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
    em.createNativeQuery("drop table blog.EntryTag CASCADE").executeUpdate();
	em.createNativeQuery("drop table blog.Tag CASCADE").executeUpdate();
	em.getTransaction().commit();
	}

	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}

	public static TagEntity createEntity() {
		TagEntity tag = new TagEntity();
  		tag.setName("1");
		tag.setTagId(1L);
		return tag;
		 
	}

	public static CreateTagInput createTagInput() {
		CreateTagInput tag = new CreateTagInput();
		
  		tag.setName("2");
		
		return tag;
	}

	public static TagEntity createNewEntity() {
		TagEntity tag = new TagEntity();
  		tag.setName("3");
		tag.setTagId(3L);
		return tag;
	}

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);

		evictAllCaches();
		final TagController tagController = new TagController(tagAppService,entryTagAppService,
	logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup(tagController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		tag= createEntity();
		List<TagEntity> list= tag_repository.findAll();
		if(list.isEmpty())
			tag_repository.save(tag);

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/tag/1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/tag/111")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
		@Test
	public void CreateTag_TagDoesNotExist_ReturnStatusOk() throws Exception {
		CreateTagInput tag = createTagInput();
		 ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(tag);

		mvc.perform(post("/tag").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}     

	@Test
	public void DeleteTag_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        doReturn(null).when(tagAppService).FindById(111L);
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/tag/111")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a tag with a id=111"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		TagEntity entity = tag_repository.save(createNewEntity());

		FindTagByIdOutput output= new FindTagByIdOutput();
  		output.setName(entity.getName());
  		output.setTagId(entity.getTagId());

        Mockito.when(tagAppService.FindById(entity.getTagId())).thenReturn(output);
        
		mvc.perform(delete("/tag/" + entity.getTagId())
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void UpdateTag_TagDoesNotExist_ReturnStatusNotFound() throws Exception {

        doReturn(null).when(tagAppService).FindById(111L);

		UpdateTagInput tag = new UpdateTagInput();
  		tag.setName("111");
		tag.setTagId(111L);

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(tag);
		mvc.perform(put("/tag/111").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void UpdateTag_TagExists_ReturnStatusOk() throws Exception {
		TagEntity entity = tag_repository.save(createNewEntity());
		FindTagByIdOutput output= new FindTagByIdOutput();
        
  		output.setName(entity.getName());
  		output.setTagId(entity.getTagId());

        Mockito.when(tagAppService.FindById(entity.getTagId())).thenReturn(output);
        
		UpdateTagInput tag = new UpdateTagInput();
  		tag.setName(entity.getName());
  		tag.setTagId(entity.getTagId());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(tagrole);
	
		mvc.perform(put("/tag/" + entity.getTagId()).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		TagEntity de = createEntity();
		de.setTagId(entity.getTagId());
		tag_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/tag?search=tagId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/tag?search=tagtagId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property tagtagId not found!"));

	} 
	
	@Test
	public void GetEntryTag_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("tagId", "1");

		Mockito.when(tagAppService.parseEntryTagJoinColumn("tagId")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/tag/1/entryTag?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void GetEntryTag_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("tagId", "1");
		
        Mockito.when(tagAppService.parseEntryTagJoinColumn("tagId")).thenReturn(joinCol);
		mvc.perform(get("/tag/1/entryTag?search=tagId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetEntryTag_searchIsNotEmpty() throws Exception {
	
		Mockito.when(tagAppService.parseEntryTagJoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/tag/1/entryTag?search=tagid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
    

}
