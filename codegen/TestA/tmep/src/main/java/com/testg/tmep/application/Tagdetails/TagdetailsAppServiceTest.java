package com.testg.tmep.application.Tagdetails;

import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.doNothing;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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

import com.testg.tmep.domain.Tagdetails.*;
import com.testg.tmep.CommonModule.Search.*;
import com.testg.tmep.application.Tagdetails.Dto.*;
import com.testg.tmep.domain.model.QTagdetailsEntity;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.Tag.TagManager;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class TagdetailsAppServiceTest {

	@InjectMocks
	TagdetailsAppService _appService;

	@Mock
	private TagdetailsManager _tagdetailsManager;
	
    @Mock
	private TagManager  _tagManager;
	
	@Mock
	private TagdetailsMapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;
	

	@Mock
	private TagId tagId;
	
	private static Long ID=15L;
	@Before
	public void setUp() throws Exception {

		MockitoAnnotations.initMocks(_appService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}
	
	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findTagdetailsById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_tagdetailsManager.FindById(any(TagId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById(tagId)).isEqualTo(null);
	}
	
	@Test
	public void findTagdetailsById_IdIsNotNullAndIdExists_ReturnTagdetails() {

		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);
		Mockito.when(_tagdetailsManager.FindById(any(TagId.class))).thenReturn(tagdetails);
		Assertions.assertThat(_appService.FindById(tagId)).isEqualTo(_mapper.TagdetailsEntityToFindTagdetailsByIdOutput(tagdetails));
	}
	
	 @Test 
    public void createTagdetails_TagdetailsIsNotNullAndTagdetailsDoesNotExist_StoreTagdetails() { 
 
       TagdetailsEntity tagdetailsEntity = mock(TagdetailsEntity.class); 
       CreateTagdetailsInput tagdetails = new CreateTagdetailsInput();
   
		TagEntity tag= mock(TagEntity.class);
        tagdetails.setTid(String.valueOf(ID));
		
        tagdetails.setTitle(String.valueOf(ID));
		
		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(tag);
		
        
        
       Mockito.when(_mapper.CreateTagdetailsInputToTagdetailsEntity(any(CreateTagdetailsInput.class))).thenReturn(tagdetailsEntity); 
       Mockito.when(_tagdetailsManager.Create(any(TagdetailsEntity.class))).thenReturn(tagdetailsEntity);
      
       Assertions.assertThat(_appService.Create(tagdetails)).isEqualTo(_mapper.TagdetailsEntityToCreateTagdetailsOutput(tagdetailsEntity)); 
    } 
  @Test
	public void createTagdetails_TagdetailsIsNotNullAndTagdetailsDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		CreateTagdetailsInput tagdetails = mock(CreateTagdetailsInput.class);
		
		Mockito.when(_mapper.CreateTagdetailsInputToTagdetailsEntity(any(CreateTagdetailsInput.class))).thenReturn(null); 
		Assertions.assertThat(_appService.Create(tagdetails)).isEqualTo(null);
	}
	
	@Test
	public void createTagdetails_TagdetailsIsNotNullAndTagdetailsDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {

		CreateTagdetailsInput tagdetails = new CreateTagdetailsInput();
	    
        tagdetails.setTid(String.valueOf(ID));
		
        tagdetails.setTitle(String.valueOf(ID));
		
     
		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(null);
		Assertions.assertThat(_appService.Create(tagdetails)).isEqualTo(null);
    }
    
    @Test
	public void updateTagdetails_TagdetailsIsNotNullAndTagdetailsDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		UpdateTagdetailsInput tagdetails = mock(UpdateTagdetailsInput.class);
		TagdetailsEntity tagdetailsEntity = mock(TagdetailsEntity.class); 
		
		Mockito.when(_mapper.UpdateTagdetailsInputToTagdetailsEntity(any(UpdateTagdetailsInput.class))).thenReturn(tagdetailsEntity); 
		Assertions.assertThat(_appService.Update(tagId,tagdetails)).isEqualTo(null);
	}
	
	@Test
	public void updateTagdetails_TagdetailsIsNotNullAndTagdetailsDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
		
		UpdateTagdetailsInput tagdetails = new UpdateTagdetailsInput();
        tagdetails.setTid(String.valueOf(ID));
		
        tagdetails.setTitle(String.valueOf(ID));
		
     
		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(null);
		Assertions.assertThat(_appService.Update(tagId,tagdetails)).isEqualTo(null);
	}

		
	@Test
	public void updateTagdetails_TagdetailsIdIsNotNullAndIdExists_ReturnUpdatedTagdetails() {

		TagdetailsEntity tagdetailsEntity = mock(TagdetailsEntity.class);
		UpdateTagdetailsInput tagdetails= mock(UpdateTagdetailsInput.class);
		Mockito.when(_mapper.UpdateTagdetailsInputToTagdetailsEntity(any(UpdateTagdetailsInput.class))).thenReturn(tagdetailsEntity);
		Mockito.when(_tagdetailsManager.Update(any(TagdetailsEntity.class))).thenReturn(tagdetailsEntity);
		Assertions.assertThat(_appService.Update(tagId,tagdetails)).isEqualTo(_mapper.TagdetailsEntityToUpdateTagdetailsOutput(tagdetailsEntity));
	}
    
	@Test
	public void deleteTagdetails_TagdetailsIsNotNullAndTagdetailsExists_TagdetailsRemoved() {

		TagdetailsEntity tagdetails= mock(TagdetailsEntity.class);
		Mockito.when(_tagdetailsManager.FindById(any(TagId.class))).thenReturn(tagdetails);
		_appService.Delete(tagId); 
		verify(_tagdetailsManager).Delete(tagdetails);
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<TagdetailsEntity> list = new ArrayList<>();
		Page<TagdetailsEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindTagdetailsByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_tagdetailsManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<TagdetailsEntity> list = new ArrayList<>();
		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);
		list.add(tagdetails);
    	Page<TagdetailsEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindTagdetailsByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.TagdetailsEntityToFindTagdetailsByIdOutput(tagdetails));
    	Mockito.when(_tagdetailsManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		QTagdetailsEntity tagdetails = QTagdetailsEntity.tagdetailsEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tagdetails.country.eq(search));
		Assertions.assertThat(_appService.searchAllProperties(tagdetails,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
        list.add("country");
		
		QTagdetailsEntity tagdetails = QTagdetailsEntity.tagdetailsEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tagdetails.country.eq("xyz"));
		
		Assertions.assertThat(_appService.searchSpecificProperty(tagdetails, list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		QTagdetailsEntity tagdetails = QTagdetailsEntity.tagdetailsEntity;
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
	    Map<String,SearchFields> map = new HashMap<>();
        map.put("country",searchFields);
		 Map<String,String> searchMap = new HashMap<>();
        searchMap.put("xyz",String.valueOf(ID));
		BooleanBuilder builder = new BooleanBuilder();
         builder.and(tagdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.searchKeyValuePair(tagdetails,map,searchMap)).isEqualTo(builder);
	}
	
	@Test (expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception {
		List<String> list = new ArrayList<>();
		list.add("xyz");
		_appService.checkProperties(list);
	}
	
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception {
		List<String> list = new ArrayList<>();
        list.add("country");
		_appService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception {

		QTagdetailsEntity tagdetails = QTagdetailsEntity.tagdetailsEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tagdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		QTagdetailsEntity tagdetails = QTagdetailsEntity.tagdetailsEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
        fields.setFieldName("country");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tagdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
	
		Map<String,SearchFields> map = new HashMap<>();
		QTagdetailsEntity tagdetails = QTagdetailsEntity.tagdetailsEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		search.setValue("xyz");
		search.setOperator("equals");
        fields.setFieldName("country");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tagdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
   //Tag
	@Test
	public void GetTag_IfTagdetailsIdAndTagIdIsNotNullAndTagdetailsExists_ReturnTag() {
		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);
		TagEntity tag = mock(TagEntity.class);

		Mockito.when(_tagdetailsManager.FindById(any(TagId.class))).thenReturn(tagdetails);
		Mockito.when(_tagdetailsManager.GetTag(any(TagId.class))).thenReturn(tag);
		Assertions.assertThat(_appService.GetTag(tagId)).isEqualTo(_mapper.TagEntityToGetTagOutput(tag, tagdetails));
	}

	@Test 
	public void GetTag_IfTagdetailsIdAndTagIdIsNotNullAndTagdetailsDoesNotExist_ReturnNull() {
		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);

		Mockito.when(_tagdetailsManager.FindById(any(TagId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetTag(tagId)).isEqualTo(null);
	}
 

}

