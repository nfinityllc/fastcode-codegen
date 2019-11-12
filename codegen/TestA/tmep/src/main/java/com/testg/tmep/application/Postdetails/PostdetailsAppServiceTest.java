package com.testg.tmep.application.Postdetails;

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

import com.testg.tmep.domain.Postdetails.*;
import com.testg.tmep.CommonModule.Search.*;
import com.testg.tmep.application.Postdetails.Dto.*;
import com.testg.tmep.domain.model.QPostdetailsEntity;
import com.testg.tmep.domain.model.PostdetailsEntity;
import com.testg.tmep.domain.model.PostdetailsId;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.Post.PostManager;
import com.testg.tmep.domain.model.PostId;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class PostdetailsAppServiceTest {

	@InjectMocks
	PostdetailsAppService _appService;

	@Mock
	private PostdetailsManager _postdetailsManager;
	
    @Mock
	private PostManager  _postManager;
	
	@Mock
	private PostdetailsMapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;
	

	@Mock
	private PostdetailsId postdetailsId;
	
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
	public void findPostdetailsById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_postdetailsManager.FindById(any(PostdetailsId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById(postdetailsId)).isEqualTo(null);
	}
	
	@Test
	public void findPostdetailsById_IdIsNotNullAndIdExists_ReturnPostdetails() {

		PostdetailsEntity postdetails = mock(PostdetailsEntity.class);
		Mockito.when(_postdetailsManager.FindById(any(PostdetailsId.class))).thenReturn(postdetails);
		Assertions.assertThat(_appService.FindById(postdetailsId)).isEqualTo(_mapper.PostdetailsEntityToFindPostdetailsByIdOutput(postdetails));
	}
	
	 @Test 
    public void createPostdetails_PostdetailsIsNotNullAndPostdetailsDoesNotExist_StorePostdetails() { 
 
       PostdetailsEntity postdetailsEntity = mock(PostdetailsEntity.class); 
       CreatePostdetailsInput postdetails = new CreatePostdetailsInput();
   
		PostEntity post= mock(PostEntity.class);
        postdetails.setPid(String.valueOf(ID));
		
        postdetails.setTitle(String.valueOf(ID));
		
		Mockito.when(_postManager.FindById(any(PostId.class))).thenReturn(post);
		
        
        
       Mockito.when(_mapper.CreatePostdetailsInputToPostdetailsEntity(any(CreatePostdetailsInput.class))).thenReturn(postdetailsEntity); 
       Mockito.when(_postdetailsManager.Create(any(PostdetailsEntity.class))).thenReturn(postdetailsEntity);
      
       Assertions.assertThat(_appService.Create(postdetails)).isEqualTo(_mapper.PostdetailsEntityToCreatePostdetailsOutput(postdetailsEntity)); 
    } 
  @Test
	public void createPostdetails_PostdetailsIsNotNullAndPostdetailsDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		CreatePostdetailsInput postdetails = mock(CreatePostdetailsInput.class);
		
		Mockito.when(_mapper.CreatePostdetailsInputToPostdetailsEntity(any(CreatePostdetailsInput.class))).thenReturn(null); 
		Assertions.assertThat(_appService.Create(postdetails)).isEqualTo(null);
	}
	
	@Test
	public void createPostdetails_PostdetailsIsNotNullAndPostdetailsDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {

		CreatePostdetailsInput postdetails = new CreatePostdetailsInput();
	    
        postdetails.setPid(String.valueOf(ID));
		
        postdetails.setTitle(String.valueOf(ID));
		
     
		Mockito.when(_postManager.FindById(any(PostId.class))).thenReturn(null);
		Assertions.assertThat(_appService.Create(postdetails)).isEqualTo(null);
    }
    
    @Test
	public void updatePostdetails_PostdetailsIsNotNullAndPostdetailsDoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		UpdatePostdetailsInput postdetails = mock(UpdatePostdetailsInput.class);
		PostdetailsEntity postdetailsEntity = mock(PostdetailsEntity.class); 
		
		Mockito.when(_mapper.UpdatePostdetailsInputToPostdetailsEntity(any(UpdatePostdetailsInput.class))).thenReturn(postdetailsEntity); 
		Assertions.assertThat(_appService.Update(postdetailsId,postdetails)).isEqualTo(null);
	}
	
	@Test
	public void updatePostdetails_PostdetailsIsNotNullAndPostdetailsDoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
		
		UpdatePostdetailsInput postdetails = new UpdatePostdetailsInput();
        postdetails.setPid(String.valueOf(ID));
		
        postdetails.setTitle(String.valueOf(ID));
		
     
		Mockito.when(_postManager.FindById(any(PostId.class))).thenReturn(null);
		Assertions.assertThat(_appService.Update(postdetailsId,postdetails)).isEqualTo(null);
	}

		
	@Test
	public void updatePostdetails_PostdetailsIdIsNotNullAndIdExists_ReturnUpdatedPostdetails() {

		PostdetailsEntity postdetailsEntity = mock(PostdetailsEntity.class);
		UpdatePostdetailsInput postdetails= mock(UpdatePostdetailsInput.class);
		Mockito.when(_mapper.UpdatePostdetailsInputToPostdetailsEntity(any(UpdatePostdetailsInput.class))).thenReturn(postdetailsEntity);
		Mockito.when(_postdetailsManager.Update(any(PostdetailsEntity.class))).thenReturn(postdetailsEntity);
		Assertions.assertThat(_appService.Update(postdetailsId,postdetails)).isEqualTo(_mapper.PostdetailsEntityToUpdatePostdetailsOutput(postdetailsEntity));
	}
    
	@Test
	public void deletePostdetails_PostdetailsIsNotNullAndPostdetailsExists_PostdetailsRemoved() {

		PostdetailsEntity postdetails= mock(PostdetailsEntity.class);
		Mockito.when(_postdetailsManager.FindById(any(PostdetailsId.class))).thenReturn(postdetails);
		_appService.Delete(postdetailsId); 
		verify(_postdetailsManager).Delete(postdetails);
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<PostdetailsEntity> list = new ArrayList<>();
		Page<PostdetailsEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindPostdetailsByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_postdetailsManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<PostdetailsEntity> list = new ArrayList<>();
		PostdetailsEntity postdetails = mock(PostdetailsEntity.class);
		list.add(postdetails);
    	Page<PostdetailsEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindPostdetailsByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.PostdetailsEntityToFindPostdetailsByIdOutput(postdetails));
    	Mockito.when(_postdetailsManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		QPostdetailsEntity postdetails = QPostdetailsEntity.postdetailsEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(postdetails.country.eq(search));
		Assertions.assertThat(_appService.searchAllProperties(postdetails,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
        list.add("country");
		
		QPostdetailsEntity postdetails = QPostdetailsEntity.postdetailsEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(postdetails.country.eq("xyz"));
		
		Assertions.assertThat(_appService.searchSpecificProperty(postdetails, list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		QPostdetailsEntity postdetails = QPostdetailsEntity.postdetailsEntity;
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
	    Map<String,SearchFields> map = new HashMap<>();
        map.put("country",searchFields);
		 Map<String,String> searchMap = new HashMap<>();
        searchMap.put("xyz",String.valueOf(ID));
		BooleanBuilder builder = new BooleanBuilder();
         builder.and(postdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.searchKeyValuePair(postdetails,map,searchMap)).isEqualTo(builder);
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

		QPostdetailsEntity postdetails = QPostdetailsEntity.postdetailsEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(postdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		QPostdetailsEntity postdetails = QPostdetailsEntity.postdetailsEntity;
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
        builder.or(postdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
	
		Map<String,SearchFields> map = new HashMap<>();
		QPostdetailsEntity postdetails = QPostdetailsEntity.postdetailsEntity;
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
        builder.or(postdetails.country.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
   //Post
	@Test
	public void GetPost_IfPostdetailsIdAndPostIdIsNotNullAndPostdetailsExists_ReturnPost() {
		PostdetailsEntity postdetails = mock(PostdetailsEntity.class);
		PostEntity post = mock(PostEntity.class);

		Mockito.when(_postdetailsManager.FindById(any(PostdetailsId.class))).thenReturn(postdetails);
		Mockito.when(_postdetailsManager.GetPost(any(PostdetailsId.class))).thenReturn(post);
		Assertions.assertThat(_appService.GetPost(postdetailsId)).isEqualTo(_mapper.PostEntityToGetPostOutput(post, postdetails));
	}

	@Test 
	public void GetPost_IfPostdetailsIdAndPostIdIsNotNullAndPostdetailsDoesNotExist_ReturnNull() {
		PostdetailsEntity postdetails = mock(PostdetailsEntity.class);

		Mockito.when(_postdetailsManager.FindById(any(PostdetailsId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetPost(postdetailsId)).isEqualTo(null);
	}
 

}

