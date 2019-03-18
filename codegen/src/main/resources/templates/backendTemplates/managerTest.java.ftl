package com.nfinity.fastcode.domain.Authorization.${PackageName};

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

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

import com.nfinity.fastcode.domain.IRepository.I${ClassName}Repository;
import com.nfinity.fastcode.logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class ${ClassName}ManagerTest {

	@InjectMocks
	${ClassName}Manager _manager;
	
	@Mock
	I${ClassName}Repository  _repository;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_manager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void find${ClassName}ById_IdIsNotNullAndIdExists_Return${ClassName}() {
		${ClassName}Entity ${ClassName?lower_case} =mock(${ClassName}Entity.class);

		Mockito.when(_repository.findById(anyLong())).thenReturn(${ClassName?lower_case});
		Assertions.assertThat(_manager.FindById(ID)).isEqualTo(${ClassName?lower_case});
	}

	@Test 
	public void find${ClassName}ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	Mockito.when(_repository.findById(anyLong())).thenReturn(null);
	Assertions.assertThat(_manager.FindById(ID)).isEqualTo(null);
	}
	
	@Test
	public void find${ClassName}ByName_NameIsNotNullAndNameExists_Return${ClassName}() {
		${ClassName}Entity ${ClassName?lower_case} =mock(${ClassName}Entity.class);

		Mockito.when(_repository.findByName(anyString())).thenReturn(${ClassName?lower_case});
		Assertions.assertThat(_manager.FindByName("xyz")).isEqualTo(${ClassName?lower_case});
	}

	@Test 
	public void find${ClassName?lower_case}ByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {

		Mockito.when(_repository.findByName(anyString())).thenReturn(null);
		Assertions.assertThat(_manager.FindByName("xyz")).isEqualTo(null);
	
	}
	
	@Test
	public void create${ClassName}_${ClassName}IsNotNullAnd${ClassName}DoesNotExist_Store${ClassName}() {

		${ClassName}Entity ${ClassName?lower_case} =mock(${ClassName}Entity.class);
		Mockito.when(_repository.save(any(${ClassName}Entity.class))).thenReturn(${ClassName?lower_case});
		Assertions.assertThat(_manager.Create(${ClassName?lower_case})).isEqualTo(${ClassName?lower_case});
	}

	@Test
	public void delete${ClassName}_${ClassName}Exists_Remove${ClassName}() {

		${ClassName}Entity ${ClassName?lower_case} =mock(${ClassName}Entity.class);
		_manager.Delete(${ClassName?lower_case});
		verify(_repository).delete(${ClassName?lower_case});
	}

	@Test
	public void update${ClassName}_${ClassName}IsNotNullAnd${ClassName}Exists_Update${ClassName}() {
		
		${ClassName}Entity ${ClassName?lower_case} =mock(${ClassName}Entity.class);
		Mockito.when(_repository.save(any(${ClassName}Entity.class))).thenReturn(${ClassName?lower_case});
		Assertions.assertThat(_manager.Update(${ClassName?lower_case})).isEqualTo(${ClassName?lower_case});
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<${ClassName}Entity> ${ClassName?lower_case} = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_repository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(${ClassName?lower_case});
		Assertions.assertThat(_manager.FindAll(predicate,pageable)).isEqualTo(${ClassName?lower_case});
	}
}
