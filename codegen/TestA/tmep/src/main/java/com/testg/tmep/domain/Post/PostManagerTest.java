package com.testg.tmep.domain.Post;

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

import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.IRepository.IPostdetailsRepository;
import com.testg.tmep.domain.model.PostId;
import com.testg.tmep.domain.IRepository.IPostRepository;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class PostManagerTest {

	@InjectMocks
	PostManager _postManager;
	
	@Mock
	IPostRepository  _postRepository;
    
    @Mock
	IPostdetailsRepository  _postdetailsRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	@Mock
	private PostId postId;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_postManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findPostById_IdIsNotNullAndIdExists_ReturnPost() {
		PostEntity post =mock(PostEntity.class);

        Optional<PostEntity> dbPost = Optional.of((PostEntity) post);
		Mockito.<Optional<PostEntity>>when(_postRepository.findById(any(PostId.class))).thenReturn(dbPost);
		Assertions.assertThat(_postManager.FindById(postId)).isEqualTo(post);
	}

	@Test 
	public void findPostById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	    Mockito.<Optional<PostEntity>>when(_postRepository.findById(any(PostId.class))).thenReturn(Optional.empty());
		Assertions.assertThat(_postManager.FindById(postId)).isEqualTo(null);
	}
	
	@Test
	public void createPost_PostIsNotNullAndPostDoesNotExist_StorePost() {

		PostEntity post =mock(PostEntity.class);
		Mockito.when(_postRepository.save(any(PostEntity.class))).thenReturn(post);
		Assertions.assertThat(_postManager.Create(post)).isEqualTo(post);
	}

	@Test
	public void deletePost_PostExists_RemovePost() {

		PostEntity post =mock(PostEntity.class);
		_postManager.Delete(post);
		verify(_postRepository).delete(post);
	}

	@Test
	public void updatePost_PostIsNotNullAndPostExists_UpdatePost() {
		
		PostEntity post =mock(PostEntity.class);
		Mockito.when(_postRepository.save(any(PostEntity.class))).thenReturn(post);
		Assertions.assertThat(_postManager.Update(post)).isEqualTo(post);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<PostEntity> post = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_postRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(post);
		Assertions.assertThat(_postManager.FindAll(predicate,pageable)).isEqualTo(post);
	}
	
}
