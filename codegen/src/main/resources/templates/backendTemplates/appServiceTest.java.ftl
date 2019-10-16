package [=PackageName].application<#if ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName];

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

import [=PackageName].domain<#if AuthenticationType!= "none" && ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName].*;
import [=CommonModulePackage].Search.*;
import [=PackageName].application<#if AuthenticationType!= "none" && ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName].Dto.*;
import [=PackageName].domain.model.Q[=EntityClassName];
import [=PackageName].domain.model.[=EntityClassName];
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=ClassName]Id;
</#if>
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].domain<#if AuthenticationType!= "none" && relationValue.eName == AuthenticationTable>.Authorization</#if>.[=relationValue.eName].[=relationValue.eName]Manager;
<#if CompositeKeyClasses?seq_contains(relationValue.eName)>
import [=PackageName].domain.model.[=relationValue.eName]Id;
</#if>
</#if>
</#list>
<#if ClassName == AuthenticationTable>
import [=PackageName].domain.Authorization.Role.RoleManager;
import [=PackageName].domain.model.RoleEntity;
<#if Flowable!false>
import [=PackageName].domain.Flowable.Users.ActIdUserEntity;
import [=PackageName].application.Flowable.ActIdUserMapper;
import [=PackageName].application.Flowable.FlowableIdentityService;
</#if>
</#if>
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=ClassName]AppServiceTest {

	@InjectMocks
	[=ClassName]AppService _appService;

	@Mock
	private [=ClassName]Manager _[=ClassName?uncap_first]Manager;
	
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    @Mock
	private [=relationValue.eName]Manager  _[=relationValue.eName?uncap_first]Manager;
	
	</#if>
    </#list>
	@Mock
	private [=ClassName]Mapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;
	
	<#if ClassName == AuthenticationTable>
	@Mock
	private RoleManager _roleManager;
	
    <#if Flowable!false>
    @Mock
	private ActIdUserMapper actIdUserMapper;
	
	@Mock
	private FlowableIdentityService idmIdentityService;
    </#if>
    </#if>

	<#if CompositeKeyClasses?seq_contains(ClassName)>
	@Mock
	private [=ClassName]Id [=ClassName?uncap_first]Id;
	
	private static Long ID=15L;
	<#else>
	<#list Fields as key,value>
	<#if value.isPrimaryKey!false>
	<#if value.fieldType?lower_case == "long">
	private static [=value.fieldType?cap_first] ID=15L;
	
	<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
	private static [=value.fieldType?cap_first] ID=15;
	
	<#elseif value.fieldType?lower_case == "double">
	private static [value.fieldType?cap_first] ID=15D;
	
	<#elseif value.fieldType?lower_case == "string">
	private static String ID="15";
	</#if>
	</#if>
	</#list>
	</#if>
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
	public void find[=ClassName]ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn(null);
		Assertions.assertThat(_appService.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo(null);
	}
	
	@Test
	public void find[=ClassName]ById_IdIsNotNullAndIdExists_Return[=ClassName]() {

		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		Mockito.when(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_appService.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo(_mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?uncap_first]));
	}
	
	 @Test 
    public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExist_Store[=ClassName]() { 
 
       [=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class); 
       Create[=ClassName]Input [=ClassName?uncap_first] = new Create[=ClassName]Input();
   
        <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first]= mock([=relationValue.eName]Entity.class);
        <#assign i=relationValue.joinDetails?size>
        <#if i !=0 >
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumnType == "String">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](String.valueOf(ID));
        <#elseif joinDetails.joinColumnType == "Long">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Long.valueOf(ID));
        <#elseif joinDetails.joinColumnType == "Integer">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Integer.valueOf(ID));
		<#elseif joinDetails.joinColumnType == "Double">
		[=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Double.valueOf(ID)); 
		<#elseif joinDetails.joinColumnType == "Short">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Short.valueOf(ID));
		</#if>
		
        </#if>
        </#if>
        </#list>
		</#if>
		Mockito.when(_[=relationValue.eName?uncap_first]Manager.FindById(<#if i ==1 ><#list relationValue.joinDetails as joinDetails><#if joinDetails.joinEntityName == relationValue.eName><#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumnType == "String">any(String.class)<#elseif joinDetails.joinColumnType == "Long">any(Long.class)<#elseif joinDetails.joinColumnType == "Integer">any(Integer.class)<#elseif joinDetails.joinColumnType == "Double">any(Double.class)<#elseif joinDetails.joinColumnType == "Short">any(Short.class)</#if></#if></#if></#list><#else>any([=relationValue.eName]Id.class)</#if>)).thenReturn([=relationValue.eName?uncap_first]);
		
        </#if>
        
        </#if>
		</#list>
        
       <#if ClassName == AuthenticationTable>
       RoleEntity foundRole = mock(RoleEntity.class);
       Mockito.when(_roleManager.FindById(anyLong())).thenReturn(foundRole);
       <#if Flowable!false>
       ActIdUserEntity actIdUser = mock (ActIdUserEntity.class);
			
	   Mockito.when(actIdUserMapper.createUsersEntityToActIdUserEntity(any(CustomUserEntity.class))).thenReturn(actIdUser);
	   doNothing().when(idmIdentityService).createUser(any(CustomUserEntity.class),any(ActIdUserEntity.class)); 
       </#if>
       </#if>
       Mockito.when(_mapper.Create[=ClassName]InputTo[=ClassName]Entity(any(Create[=ClassName]Input.class))).thenReturn([=ClassName?uncap_first]Entity); 
       Mockito.when(_[=ClassName?uncap_first]Manager.Create(any([=ClassName]Entity.class))).thenReturn([=ClassName?uncap_first]Entity);
      
       Assertions.assertThat(_appService.Create([=ClassName?uncap_first])).isEqualTo(_mapper.[=EntityClassName]ToCreate[=ClassName]Output([=ClassName?uncap_first]Entity)); 
    } 
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"  >
<#if relationValue.isParent==false>
<#assign i=relationValue.joinDetails?size>
<#if i==1>
<#list relationValue.joinDetails as joinDetails>
<#if joinDetails.joinEntityName == relationValue.eName>
<#if joinDetails.joinColumn??>
<#if joinDetails.isJoinColumnOptional==false>
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		Create[=ClassName]Input [=ClassName?uncap_first] = mock(Create[=ClassName]Input.class);
		
		Mockito.when(_mapper.Create[=ClassName]InputTo[=ClassName]Entity(any(Create[=ClassName]Input.class))).thenReturn(null); 
		Assertions.assertThat(_appService.Create([=ClassName?uncap_first])).isEqualTo(null);
	}
	
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {

		Create[=ClassName]Input [=ClassName?uncap_first] = new Create[=ClassName]Input();
	    
        <#assign i=relationValue.joinDetails?size>
        <#if i !=0 >
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumnType?lower_case == "string">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](String.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "long">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Long.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "integer">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Integer.valueOf(ID));
		<#elseif joinDetails.joinColumnType?lower_case == "double">
		[=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Double.valueOf(ID)); 
		<#elseif joinDetails.joinColumnType?lower_case == "short">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Short.valueOf(ID));
		</#if>
		
        </#if>
        </#if>
        </#list>
		</#if>
     
		Mockito.when(_[=relationValue.eName?uncap_first]Manager.FindById(<#assign i=relationValue.joinDetails?size><#if i ==1 ><#list relationValue.joinDetails as joinDetails><#if joinDetails.joinEntityName == relationValue.eName><#if joinDetails.joinColumn??><#if joinDetails.joinColumnType?lower_case == "string">any(String.class)<#elseif joinDetails.joinColumnType?lower_case == "long">any(Long.class)<#elseif joinDetails.joinColumnType?lower_case == "integer">any(Integer.class)<#elseif joinDetails.joinColumnType?lower_case == "double">any(Double.class)<#elseif joinDetails.joinColumnType?lower_case == "short">any(Short.class)</#if></#if></#if></#list><#else>any([=relationValue.eName]Id.class)</#if>)).thenReturn(null);
		Assertions.assertThat(_appService.Create([=ClassName?uncap_first])).isEqualTo(null);
    }
    
    @Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		Update[=ClassName]Input [=ClassName?uncap_first] = mock(Update[=ClassName]Input.class);
		[=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class); 
		
		Mockito.when(_mapper.Update[=ClassName]InputTo[=ClassName]Entity(any(Update[=ClassName]Input.class))).thenReturn([=ClassName?uncap_first]Entity); 
		Assertions.assertThat(_appService.Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>,[=ClassName?uncap_first])).isEqualTo(null);
	}
	
	@Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
		
		Update[=ClassName]Input [=ClassName?uncap_first] = new Update[=ClassName]Input();
	    <#assign i=relationValue.joinDetails?size>
        <#if i !=0 >
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumnType?lower_case == "string">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](String.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "long">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Long.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "integer">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Integer.valueOf(ID));
		<#elseif joinDetails.joinColumnType?lower_case == "double">
		[=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Double.valueOf(ID)); 
		<#elseif joinDetails.joinColumnType?lower_case == "short">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Short.valueOf(ID));
		</#if>
		
        </#if>
        </#if>
        </#list>
		</#if>
     
		Mockito.when(_[=relationValue.eName?uncap_first]Manager.FindById(<#assign i=relationValue.joinDetails?size><#if i ==1 ><#list relationValue.joinDetails as joinDetails><#if joinDetails.joinEntityName == relationValue.eName><#if joinDetails.joinColumn??><#if joinDetails.joinColumnType?lower_case == "string">any(String.class)<#elseif joinDetails.joinColumnType?lower_case == "long">any(Long.class)<#elseif joinDetails.joinColumnType?lower_case == "integer">any(Integer.class)<#elseif joinDetails.joinColumnType?lower_case == "double">any(Double.class)<#elseif joinDetails.joinColumnType?lower_case == "short">any(Short.class)</#if></#if></#if></#list><#else>any([=relationValue.eName]Id.class)</#if>)).thenReturn(null);
		Assertions.assertThat(_appService.Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>,[=ClassName?uncap_first])).isEqualTo(null);
	}

<#else>
    @Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNullAndChildIsNotMandatory_Store[=ClassName]() {

		[=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class);
		Create[=ClassName]Input [=ClassName?uncap_first] = mock(Create[=ClassName]Input.class);
		
		Mockito.when(_mapper.Create[=ClassName]InputTo[=EntityClassName](any(Create[=ClassName]Input.class))).thenReturn([=ClassName?uncap_first]Entity);
		Mockito.when(_[=ClassName?uncap_first]Manager.Create(any([=EntityClassName].class))).thenReturn([=ClassName?uncap_first]Entity);
		Assertions.assertThat(_appService.Create([=ClassName?uncap_first])).isEqualTo(_mapper.[=EntityClassName]ToCreate[=ClassName]Output([=ClassName?uncap_first]Entity));

	}
	
	
    @Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNullAndChildIsNotMandatory_ReturnUpdated[=ClassName]() {

		[=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class);
		Update[=ClassName]Input [=ClassName?uncap_first] = mock(Update[=ClassName]Input.class);
		
		Mockito.when(_mapper.Update[=ClassName]InputTo[=EntityClassName](any(Update[=ClassName]Input.class))).thenReturn([=ClassName?uncap_first]Entity);
		Mockito.when(_[=ClassName?uncap_first]Manager.Update(any([=EntityClassName].class))).thenReturn([=ClassName?uncap_first]Entity);
		Assertions.assertThat(_appService.Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>,[=ClassName?uncap_first])).isEqualTo(_mapper.[=EntityClassName]ToUpdate[=ClassName]Output([=ClassName?uncap_first]Entity));
	}
	
</#if>
</#if>
</#if>
</#list>
<#else>
  @Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		Create[=ClassName]Input [=ClassName?uncap_first] = mock(Create[=ClassName]Input.class);
		
		Mockito.when(_mapper.Create[=ClassName]InputTo[=ClassName]Entity(any(Create[=ClassName]Input.class))).thenReturn(null); 
		Assertions.assertThat(_appService.Create([=ClassName?uncap_first])).isEqualTo(null);
	}
	
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {

		Create[=ClassName]Input [=ClassName?uncap_first] = new Create[=ClassName]Input();
	    
        <#assign i=relationValue.joinDetails?size>
        <#if i !=0 >
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumnType?lower_case == "string">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](String.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "long">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Long.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "integer">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Integer.valueOf(ID));
		<#elseif joinDetails.joinColumnType?lower_case == "double">
		[=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Double.valueOf(ID)); 
		<#elseif joinDetails.joinColumnType?lower_case == "short">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Short.valueOf(ID));
		</#if>
		
        </#if>
        </#if>
        </#list>
		</#if>
     
		Mockito.when(_[=relationValue.eName?uncap_first]Manager.FindById(<#assign i=relationValue.joinDetails?size><#if i ==1 ><#list relationValue.joinDetails as joinDetails><#if joinDetails.joinEntityName == relationValue.eName><#if joinDetails.joinColumn??><#if joinDetails.joinColumnType?lower_case == "string">any(String.class)<#elseif joinDetails.joinColumnType?lower_case == "long">any(Long.class)<#elseif joinDetails.joinColumnType?lower_case == "integer">any(Integer.class)<#elseif joinDetails.joinColumnType?lower_case == "double">any(Double.class)<#elseif joinDetails.joinColumnType?lower_case == "short">any(Short.class)</#if></#if></#if></#list><#else>any([=relationValue.eName]Id.class)</#if>)).thenReturn(null);
		Assertions.assertThat(_appService.Create([=ClassName?uncap_first])).isEqualTo(null);
    }
    
    @Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNullAndChildIsMandatory_ReturnNull() {

		Update[=ClassName]Input [=ClassName?uncap_first] = mock(Update[=ClassName]Input.class);
		[=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class); 
		
		Mockito.when(_mapper.Update[=ClassName]InputTo[=ClassName]Entity(any(Update[=ClassName]Input.class))).thenReturn([=ClassName?uncap_first]Entity); 
		Assertions.assertThat(_appService.Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>,[=ClassName?uncap_first])).isEqualTo(null);
	}
	
	@Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExistAndChildIsNotNullAndChildIsMandatoryAndFindByIdIsNull_ReturnNull() {
		
		Update[=ClassName]Input [=ClassName?uncap_first] = new Update[=ClassName]Input();
	    <#assign i=relationValue.joinDetails?size>
        <#if i !=0 >
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumnType?lower_case == "string">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](String.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "long">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Long.valueOf(ID));
        <#elseif joinDetails.joinColumnType?lower_case == "integer">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Integer.valueOf(ID));
		<#elseif joinDetails.joinColumnType?lower_case == "double">
		[=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Double.valueOf(ID)); 
		<#elseif joinDetails.joinColumnType?lower_case == "short">
        [=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first](Short.valueOf(ID));
		</#if>
		
        </#if>
        </#if>
        </#list>
		</#if>
     
		Mockito.when(_[=relationValue.eName?uncap_first]Manager.FindById(<#assign i=relationValue.joinDetails?size><#if i ==1 ><#list relationValue.joinDetails as joinDetails><#if joinDetails.joinEntityName == relationValue.eName><#if joinDetails.joinColumn??><#if joinDetails.joinColumnType?lower_case == "string">any(String.class)<#elseif joinDetails.joinColumnType?lower_case == "long">any(Long.class)<#elseif joinDetails.joinColumnType?lower_case == "integer">any(Integer.class)<#elseif joinDetails.joinColumnType?lower_case == "double">any(Double.class)<#elseif joinDetails.joinColumnType?lower_case == "short">any(Short.class)</#if></#if></#if></#list><#else>any([=relationValue.eName]Id.class)</#if>)).thenReturn(null);
		Assertions.assertThat(_appService.Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>,[=ClassName?uncap_first])).isEqualTo(null);
	}

</#if>
</#if>
		
<#break>
</#if>
</#list>
	@Test
	public void update[=ClassName]_[=ClassName]IdIsNotNullAndIdExists_ReturnUpdated[=ClassName]() {

		[=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class);
		Update[=ClassName]Input [=ClassName?uncap_first]= mock(Update[=ClassName]Input.class);
		<#if ClassName == AuthenticationTable>
        RoleEntity foundRole = mock(RoleEntity.class);
        Mockito.when(_roleManager.FindById(anyLong())).thenReturn(foundRole);
        <#if Flowable!false>
        ActIdUserEntity actIdUser = mock (ActIdUserEntity.class);
		Mockito.when(actIdUserMapper.createUsersEntityToActIdUserEntity(any([=ClassName]Entity.class))).thenReturn(actIdUser);
		doNothing().when(idmIdentityService).updateUser(any([=ClassName]Entity.class),any(ActIdUserEntity.class),anyString()); 
		Mockito.when(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn([=ClassName?uncap_first]Entity);
		</#if>
		</#if>
		Mockito.when(_mapper.Update[=ClassName]InputTo[=EntityClassName](any(Update[=ClassName]Input.class))).thenReturn([=ClassName?uncap_first]Entity);
		Mockito.when(_[=ClassName?uncap_first]Manager.Update(any([=EntityClassName].class))).thenReturn([=ClassName?uncap_first]Entity);
		Assertions.assertThat(_appService.Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>,[=ClassName?uncap_first])).isEqualTo(_mapper.[=EntityClassName]ToUpdate[=ClassName]Output([=ClassName?uncap_first]Entity));
	}
    
	@Test
	public void delete[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]Exists_[=ClassName]Removed() {

		[=EntityClassName] [=ClassName?uncap_first]= mock([=EntityClassName].class);
		Mockito.when(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn([=ClassName?uncap_first]);
		<#if ClassName == AuthenticationTable>
		<#if Flowable!false>
		doNothing().when(idmIdentityService).deleteUser(anyString()); 
		</#if>
		</#if>
		_appService.Delete(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>); 
		verify(_[=ClassName?uncap_first]Manager).Delete([=ClassName?uncap_first]);
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<[=EntityClassName]> list = new ArrayList<>();
		Page<[=EntityClassName]> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(_[=ClassName?uncap_first]Manager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<[=EntityClassName]> list = new ArrayList<>();
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		list.add([=ClassName?uncap_first]);
    	Page<[=EntityClassName]> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		output.add(_mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?uncap_first]));
    	Mockito.when(_[=ClassName?uncap_first]Manager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		Q[=EntityClassName] [=ClassName?uncap_first] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		BooleanBuilder builder = new BooleanBuilder();
    	<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        builder.or([=ClassName?uncap_first].[=value.fieldName].eq(search));
		</#if> 
		</#if> 
        </#list>
		Assertions.assertThat(_appService.searchAllProperties([=ClassName?uncap_first],search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        list.add("[=value.fieldName]");
		</#if> 
		</#if> 
        </#list>
		
		Q[=EntityClassName] [=ClassName?uncap_first] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		BooleanBuilder builder = new BooleanBuilder();
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        builder.or([=ClassName?uncap_first].[=value.fieldName].eq("xyz"));
		</#if> 
		</#if> 
        </#list>
		
		Assertions.assertThat(_appService.searchSpecificProperty([=ClassName?uncap_first], list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		Q[=EntityClassName] [=ClassName?uncap_first] = Q[=EntityClassName].[=EntityClassName?uncap_first];
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
	    Map<String,SearchFields> map = new HashMap<>();
	    <#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        map.put("[=value.fieldName]",searchFields);
        <#break>
		</#if> 
		</#if> 
        </#list>		
		 Map<String,String> searchMap = new HashMap<>();
        searchMap.put("xyz",String.valueOf(ID));
		BooleanBuilder builder = new BooleanBuilder();
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
         builder.and([=ClassName?uncap_first].[=value.fieldName].eq("xyz"));
        <#break>
		</#if> 
		</#if> 
        </#list>
		Assertions.assertThat(_appService.searchKeyValuePair([=ClassName?uncap_first],map,searchMap)).isEqualTo(builder);
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
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        list.add("[=value.fieldName]");
		</#if> 
		</#if> 
        </#list>
		_appService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception {

		Q[=EntityClassName] [=ClassName?uncap_first] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        builder.or([=ClassName?uncap_first].[=value.fieldName].eq("xyz"));
		</#if> 
		</#if> 
        </#list>
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		Q[=EntityClassName] [=ClassName?uncap_first] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        fields.setFieldName("[=value.fieldName]");
        <#break>
		</#if> 
		</#if> 
        </#list>
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        builder.or([=ClassName?uncap_first].[=value.fieldName].eq("xyz"));
        <#break>
		</#if> 
		</#if> 
        </#list>
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
	
		Map<String,SearchFields> map = new HashMap<>();
		Q[=EntityClassName] [=ClassName?uncap_first] = Q[=EntityClassName].[=EntityClassName?uncap_first];
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		search.setValue("xyz");
		search.setOperator("equals");
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        fields.setFieldName("[=value.fieldName]");
        <#break>
		</#if> 
		</#if> 
        </#list>
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
	    <#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        builder.or([=ClassName?uncap_first].[=value.fieldName].eq("xyz"));
        <#break>
		</#if> 
		</#if> 
        </#list>
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
   <#list Relationship as relationKey, relationValue>
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   //[=relationValue.eName]
	@Test
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]Exists_Return[=relationValue.eName]() {
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);

		Mockito.when(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn([=ClassName?uncap_first]);
		Mockito.when(_[=ClassName?uncap_first]Manager.Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn([=relationValue.eName?uncap_first]);
		Assertions.assertThat(_appService.Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo(_mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName?uncap_first], [=ClassName?uncap_first]));
	}

	@Test 
	public void Get[=relationValue.eName]_If[=ClassName]IdAnd[=relationValue.eName]IdIsNotNullAnd[=ClassName]DoesNotExist_ReturnNull() {
		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);

		Mockito.when(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=ClassName]Id.class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn(null);
		Assertions.assertThat(_appService.Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo(null);
	}
 
   </#if>
  </#list>

}

