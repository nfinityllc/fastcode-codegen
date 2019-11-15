package com.testg.tmep.domain.Postdetails;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

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
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.testg.tmep.domain.model.PostdetailsEntity;
import com.testg.tmep.domain.IRepository.IPostRepository;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.model.PostdetailsId;
import com.testg.tmep.domain.IRepository.IPostdetailsRepository;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class PostdetailsManagerTest {

	@InjectMocks
	PostdetailsManager _postdetailsManager;
	
	@Mock
	IPostdetailsRepository  _postdetailsRepository;
    
    @Mock
	IPostRepository  _postRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	@Mock
	private PostdetailsId postdetailsId;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_postdetailsManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findPostdetailsById_IdIsNotNullAndIdExists_ReturnPostdetails() {
		PostdetailsEntity postdetails =mock(PostdetailsEntity.class);

        Optional<PostdetailsEntity> dbPostdetails = Optional.of((PostdetailsEntity) postdetails);
		Mockito.<Optional<PostdetailsEntity>>when(_postdetailsRepository.findById(any(PostdetailsId.class))).thenReturn(dbPostdetails);
		Assertions.assertThat(_postdetailsManager.FindById(postdetailsId)).isEqualTo(postdetails);
	}

	@Test 
	public void findPostdetailsById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	    Mockito.<Optional<PostdetailsEntity>>when(_postdetailsRepository.findById(any(PostdetailsId.class))).thenReturn(Optional.empty());
		Assertions.assertThat(_postdetailsManager.FindById(postdetailsId)).isEqualTo(null);
	}
	
	@Test
	public void createPostdetails_PostdetailsIsNotNullAndPostdetailsDoesNotExist_StorePostdetails() {

		PostdetailsEntity postdetails =mock(PostdetailsEntity.class);
		Mockito.when(_postdetailsRepository.save(any(PostdetailsEntity.class))).thenReturn(postdetails);
		Assertions.assertThat(_postdetailsManager.Create(postdetails)).isEqualTo(postdetails);
	}

	@Test
	public void deletePostdetails_PostdetailsExists_RemovePostdetails() {

		PostdetailsEntity postdetails =mock(PostdetailsEntity.class);
		_postdetailsManager.Delete(postdetails);
		verify(_postdetailsRepository).delete(postdetails);
	}

	@Test
	public void updatePostdetails_PostdetailsIsNotNullAndPostdetailsExists_UpdatePostdetails() {
		
		PostdetailsEntity postdetails =mock(PostdetailsEntity.class);
		Mockito.when(_postdetailsRepository.save(any(PostdetailsEntity.class))).thenReturn(postdetails);
		Assertions.assertThat(_postdetailsManager.Update(postdetails)).isEqualTo(postdetails);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<PostdetailsEntity> postdetails = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_postdetailsRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(postdetails);
		Assertions.assertThat(_postdetailsManager.FindAll(predicate,pageable)).isEqualTo(postdetails);
	}
	
    //Post
	@Test
	public void getPost_if_PostdetailsIdIsNotNull_returnPost() {

		PostdetailsEntity postdetails = mock(PostdetailsEntity.class);
		PostEntity post = mock(PostEntity.class);
		
        Optional<PostdetailsEntity> dbPostdetails = Optional.of((PostdetailsEntity) postdetails);
		Mockito.<Optional<PostdetailsEntity>>when(_postdetailsRepository.findById(any(PostdetailsId.class))).thenReturn(dbPostdetails);
		Mockito.when(postdetails.getPost()).thenReturn(post);
		Assertions.assertThat(_postdetailsManager.GetPost(postdetailsId)).isEqualTo(post);

	}
	
}
