package com.testg.tmep.domain.Tag;

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

import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.IRepository.ITagdetailsRepository;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.IRepository.ITagRepository;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class TagManagerTest {

	@InjectMocks
	TagManager _tagManager;
	
	@Mock
	ITagRepository  _tagRepository;
    
    @Mock
	ITagdetailsRepository  _tagdetailsRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	@Mock
	private TagId tagId;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_tagManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findTagById_IdIsNotNullAndIdExists_ReturnTag() {
		TagEntity tag =mock(TagEntity.class);

        Optional<TagEntity> dbTag = Optional.of((TagEntity) tag);
		Mockito.<Optional<TagEntity>>when(_tagRepository.findById(any(TagId.class))).thenReturn(dbTag);
		Assertions.assertThat(_tagManager.FindById(tagId)).isEqualTo(tag);
	}

	@Test 
	public void findTagById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	    Mockito.<Optional<TagEntity>>when(_tagRepository.findById(any(TagId.class))).thenReturn(Optional.empty());
		Assertions.assertThat(_tagManager.FindById(tagId)).isEqualTo(null);
	}
	
	@Test
	public void createTag_TagIsNotNullAndTagDoesNotExist_StoreTag() {

		TagEntity tag =mock(TagEntity.class);
		Mockito.when(_tagRepository.save(any(TagEntity.class))).thenReturn(tag);
		Assertions.assertThat(_tagManager.Create(tag)).isEqualTo(tag);
	}

	@Test
	public void deleteTag_TagExists_RemoveTag() {

		TagEntity tag =mock(TagEntity.class);
		_tagManager.Delete(tag);
		verify(_tagRepository).delete(tag);
	}

	@Test
	public void updateTag_TagIsNotNullAndTagExists_UpdateTag() {
		
		TagEntity tag =mock(TagEntity.class);
		Mockito.when(_tagRepository.save(any(TagEntity.class))).thenReturn(tag);
		Assertions.assertThat(_tagManager.Update(tag)).isEqualTo(tag);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<TagEntity> tag = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_tagRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(tag);
		Assertions.assertThat(_tagManager.FindAll(predicate,pageable)).isEqualTo(tag);
	}
	
    //Tagdetails
	@Test
	public void getTagdetails_if_TagIdIsNotNull_returnTagdetails() {

		TagEntity tag = mock(TagEntity.class);
		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);
		
        Optional<TagEntity> dbTag = Optional.of((TagEntity) tag);
		Mockito.<Optional<TagEntity>>when(_tagRepository.findById(any(TagId.class))).thenReturn(dbTag);
		Mockito.when(tag.getTagdetails()).thenReturn(tagdetails);
		Assertions.assertThat(_tagManager.GetTagdetails(tagId)).isEqualTo(tagdetails);

	}
	
}
