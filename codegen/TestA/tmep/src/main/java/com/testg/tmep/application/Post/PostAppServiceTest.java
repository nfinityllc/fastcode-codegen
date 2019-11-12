package com.testg.tmep.application.Post;

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

import com.testg.tmep.domain.Post.*;
import com.testg.tmep.CommonModule.Search.*;
import com.testg.tmep.application.Post.Dto.*;
import com.testg.tmep.domain.model.QPostEntity;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.model.PostId;
import com.testg.tmep.domain.model.PostdetailsEntity;
import com.testg.tmep.domain.Postdetails.PostdetailsManager;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class PostAppServiceTest {

	@InjectMocks
	PostAppService _appService;

	@Mock
	private PostManager _postManager;
	
    @Mock
	private PostdetailsManager  _postdetailsManager;
	
	@Mock
	private PostMapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;
	

	@Mock
	private PostId postId;
	
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
	public void findPostById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_postManager.FindById(any(PostId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById(postId)).isEqualTo(null);
	}
	
	@Test
	public void findPostById_IdIsNotNullAndIdExists_ReturnPost() {

		PostEntity post = mock(PostEntity.class);
		Mockito.when(_postManager.FindById(any(PostId.class))).thenReturn(post);
		Assertions.assertThat(_appService.FindById(postId)).isEqualTo(_mapper.PostEntityToFindPostByIdOutput(post));
	}
	
	 @Test 
    public void createPost_PostIsNotNullAndPostDoesNotExist_StorePost() { 
 
       PostEntity postEntity = mock(PostEntity.class); 
       CreatePostInput post = new CreatePostInput();
   
        
       Mockito.when(_mapper.CreatePostInputToPostEntity(any(CreatePostInput.class))).thenReturn(postEntity); 
       Mockito.when(_postManager.Create(any(PostEntity.class))).thenReturn(postEntity);
      
       Assertions.assertThat(_appService.Create(post)).isEqualTo(_mapper.PostEntityToCreatePostOutput(postEntity)); 
    } 
	@Test
	public void updatePost_PostIdIsNotNullAndIdExists_ReturnUpdatedPost() {

		PostEntity postEntity = mock(PostEntity.class);
		UpdatePostInput post= mock(UpdatePostInput.class);
		Mockito.when(_mapper.UpdatePostInputToPostEntity(any(UpdatePostInput.class))).thenReturn(postEntity);
		Mockito.when(_postManager.Update(any(PostEntity.class))).thenReturn(postEntity);
		Assertions.assertThat(_appService.Update(postId,post)).isEqualTo(_mapper.PostEntityToUpdatePostOutput(postEntity));
	}
    
	@Test
	public void deletePost_PostIsNotNullAndPostExists_PostRemoved() {

		PostEntity post= mock(PostEntity.class);
		Mockito.when(_postManager.FindById(any(PostId.class))).thenReturn(post);
		_appService.Delete(postId); 
		verify(_postManager).Delete(post);
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<PostEntity> list = new ArrayList<>();
		Page<PostEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindPostByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_postManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<PostEntity> list = new ArrayList<>();
		PostEntity post = mock(PostEntity.class);
		list.add(post);
    	Page<PostEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindPostByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.PostEntityToFindPostByIdOutput(post));
    	Mockito.when(_postManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		QPostEntity post = QPostEntity.postEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(post.description.eq(search));
		Assertions.assertThat(_appService.searchAllProperties(post,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
        list.add("description");
		
		QPostEntity post = QPostEntity.postEntity;
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(post.description.eq("xyz"));
		
		Assertions.assertThat(_appService.searchSpecificProperty(post, list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		QPostEntity post = QPostEntity.postEntity;
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
	    Map<String,SearchFields> map = new HashMap<>();
        map.put("description",searchFields);
		 Map<String,String> searchMap = new HashMap<>();
        searchMap.put("xyz",String.valueOf(ID));
		BooleanBuilder builder = new BooleanBuilder();
         builder.and(post.description.eq("xyz"));
		Assertions.assertThat(_appService.searchKeyValuePair(post,map,searchMap)).isEqualTo(builder);
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

		QPostEntity post = QPostEntity.postEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
        builder.or(post.description.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		QPostEntity post = QPostEntity.postEntity;
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
        builder.or(post.description.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
	
		Map<String,SearchFields> map = new HashMap<>();
		QPostEntity post = QPostEntity.postEntity;
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
        builder.or(post.description.eq("xyz"));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	

}

