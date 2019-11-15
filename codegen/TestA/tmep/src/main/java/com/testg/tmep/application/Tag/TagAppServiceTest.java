package com.testg.tmep.application.Tag;

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

import com.testg.tmep.domain.Tag.*;
import com.testg.tmep.CommonModule.Search.*;
import com.testg.tmep.application.Tag.Dto.*;
import com.testg.tmep.domain.model.QTagEntity;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.Tagdetails.TagdetailsManager;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class TagAppServiceTest {

	@InjectMocks
	TagAppService _appService;

	@Mock
	private TagManager _tagManager;
	
    @Mock
	private TagdetailsManager  _tagdetailsManager;
	
	@Mock
	private TagMapper _mapper;

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
	public void findTagById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById(tagId)).isEqualTo(null);
	}
	
	@Test
	public void findTagById_IdIsNotNullAndIdExists_ReturnTag() {

		TagEntity tag = mock(TagEntity.class);
		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(tag);
		Assertions.assertThat(_appService.FindById(tagId)).isEqualTo(_mapper.TagEntityToFindTagByIdOutput(tag));
	}
	
	 @Test 
    public void createTag_TagIsNotNullAndTagDoesNotExist_StoreTag() { 
 
       TagEntity tagEntity = mock(TagEntity.class); 
       CreateTagInput tag = new CreateTagInput();
   
        
        
       Mockito.when(_mapper.CreateTagInputToTagEntity(any(CreateTagInput.class))).thenReturn(tagEntity); 
       Mockito.when(_tagManager.Create(any(TagEntity.class))).thenReturn(tagEntity);
      
       Assertions.assertThat(_appService.Create(tag)).isEqualTo(_mapper.TagEntityToCreateTagOutput(tagEntity)); 
    } 
		
	@Test
	public void updateTag_TagIdIsNotNullAndIdExists_ReturnUpdatedTag() {

		TagEntity tagEntity = mock(TagEntity.class);
		UpdateTagInput tag= mock(UpdateTagInput.class);
		Mockito.when(_mapper.UpdateTagInputToTagEntity(any(UpdateTagInput.class))).thenReturn(tagEntity);
		Mockito.when(_tagManager.Update(any(TagEntity.class))).thenReturn(tagEntity);
		Assertions.assertThat(_appService.Update(tagId,tag)).isEqualTo(_mapper.TagEntityToUpdateTagOutput(tagEntity));
	}
    
	@Test
	public void deleteTag_TagIsNotNullAndTagExists_TagRemoved() {

		TagEntity tag= mock(TagEntity.class);
		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(tag);
		_appService.Delete(tagId); 
		verify(_tagManager).Delete(tag);
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<TagEntity> list = new ArrayList<>();
		Page<TagEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindTagByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_tagManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<TagEntity> list = new ArrayList<>();
		TagEntity tag = mock(TagEntity.class);
		list.add(tag);
    	Page<TagEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindTagByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.TagEntityToFindTagByIdOutput(tag));
    	Mockito.when(_tagManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		QTagEntity tag = QTagEntity.tagEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tag.description.eq(search));
		Assertions.assertThat(_appService.searchAllProperties(tag,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
        list.add("description");
		
		QTagEntity tag = QTagEntity.tagEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tag.description.eq("xyz"));
		
		Assertions.assertThat(_appService.searchSpecificProperty(tag, list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		QTagEntity tag = QTagEntity.tagEntity;
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
	    Map<String,SearchFields> map = new HashMap<>();
        map.put("description",searchFields);
		 Map<String,String> searchMap = new HashMap<>();
        searchMap.put("xyz",String.valueOf(ID));
		BooleanBuilder builder = new BooleanBuilder();
         builder.and(tag.description.eq("xyz"));
		Assertions.assertThat(_appService.searchKeyValuePair(tag,map,searchMap)).isEqualTo(builder);
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
        list.add("description");
		_appService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception {

		QTagEntity tag = QTagEntity.tagEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tag.description.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		QTagEntity tag = QTagEntity.tagEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
        fields.setFieldName("description");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tag.description.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
	
		Map<String,SearchFields> map = new HashMap<>();
		QTagEntity tag = QTagEntity.tagEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		search.setValue("xyz");
		search.setOperator("equals");
        fields.setFieldName("description");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(tag.description.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
   //Tagdetails
	@Test
	public void GetTagdetails_IfTagIdAndTagdetailsIdIsNotNullAndTagExists_ReturnTagdetails() {
		TagEntity tag = mock(TagEntity.class);
		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);

		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(tag);
		Mockito.when(_tagManager.GetTagdetails(any(TagId.class))).thenReturn(tagdetails);
		Assertions.assertThat(_appService.GetTagdetails(tagId)).isEqualTo(_mapper.TagdetailsEntityToGetTagdetailsOutput(tagdetails, tag));
	}

	@Test 
	public void GetTagdetails_IfTagIdAndTagdetailsIdIsNotNullAndTagDoesNotExist_ReturnNull() {
		TagEntity tag = mock(TagEntity.class);

		Mockito.when(_tagManager.FindById(any(TagId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetTagdetails(tagId)).isEqualTo(null);
	}
 

}

