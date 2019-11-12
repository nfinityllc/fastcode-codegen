package com.testg.tmep.domain.Tagdetails;

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

import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.IRepository.ITagRepository;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.IRepository.ITagdetailsRepository;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class TagdetailsManagerTest {

	@InjectMocks
	TagdetailsManager _tagdetailsManager;
	
	@Mock
	ITagdetailsRepository  _tagdetailsRepository;
    
    @Mock
	ITagRepository  _tagRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	@Mock
	private TagId tagId;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_tagdetailsManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void findTagdetailsById_IdIsNotNullAndIdExists_ReturnTagdetails() {
		TagdetailsEntity tagdetails =mock(TagdetailsEntity.class);

        Optional<TagdetailsEntity> dbTagdetails = Optional.of((TagdetailsEntity) tagdetails);
		Mockito.<Optional<TagdetailsEntity>>when(_tagdetailsRepository.findById(any(TagId.class))).thenReturn(dbTagdetails);
		Assertions.assertThat(_tagdetailsManager.FindById(tagId)).isEqualTo(tagdetails);
	}

	@Test 
	public void findTagdetailsById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	    Mockito.<Optional<TagdetailsEntity>>when(_tagdetailsRepository.findById(any(TagId.class))).thenReturn(Optional.empty());
		Assertions.assertThat(_tagdetailsManager.FindById(tagId)).isEqualTo(null);
	}
	
	@Test
	public void createTagdetails_TagdetailsIsNotNullAndTagdetailsDoesNotExist_StoreTagdetails() {

		TagdetailsEntity tagdetails =mock(TagdetailsEntity.class);
		Mockito.when(_tagdetailsRepository.save(any(TagdetailsEntity.class))).thenReturn(tagdetails);
		Assertions.assertThat(_tagdetailsManager.Create(tagdetails)).isEqualTo(tagdetails);
	}

	@Test
	public void deleteTagdetails_TagdetailsExists_RemoveTagdetails() {

		TagdetailsEntity tagdetails =mock(TagdetailsEntity.class);
		_tagdetailsManager.Delete(tagdetails);
		verify(_tagdetailsRepository).delete(tagdetails);
	}

	@Test
	public void updateTagdetails_TagdetailsIsNotNullAndTagdetailsExists_UpdateTagdetails() {
		
		TagdetailsEntity tagdetails =mock(TagdetailsEntity.class);
		Mockito.when(_tagdetailsRepository.save(any(TagdetailsEntity.class))).thenReturn(tagdetails);
		Assertions.assertThat(_tagdetailsManager.Update(tagdetails)).isEqualTo(tagdetails);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<TagdetailsEntity> tagdetails = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_tagdetailsRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(tagdetails);
		Assertions.assertThat(_tagdetailsManager.FindAll(predicate,pageable)).isEqualTo(tagdetails);
	}
	
    //Tag
	@Test
	public void getTag_if_TagdetailsIdIsNotNull_returnTag() {

		TagdetailsEntity tagdetails = mock(TagdetailsEntity.class);
		TagEntity tag = mock(TagEntity.class);
		
        Optional<TagdetailsEntity> dbTagdetails = Optional.of((TagdetailsEntity) tagdetails);
		Mockito.<Optional<TagdetailsEntity>>when(_tagdetailsRepository.findById(any(TagId.class))).thenReturn(dbTagdetails);
		Mockito.when(tagdetails.getTag()).thenReturn(tag);
		Assertions.assertThat(_tagdetailsManager.GetTag(tagId)).isEqualTo(tag);

	}
	
}
