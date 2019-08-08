package [=PackageName].RestControllers;

import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
<#if AuthenticationType != "none">
import org.springframework.security.access.prepost.PreAuthorize;
</#if>

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import [=PackageName].application.[=ClassName].[=ClassName]AppService;
import [=PackageName].application.[=ClassName].Dto.*;
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].application.[=relationValue.eName].[=relationValue.eName]AppService;
</#if>
<#if relationValue.relation == "OneToMany">
import java.util.List;
import [=PackageName].application.[=relationValue.eName].Dto.Find[=relationValue.eName]ByIdOutput;
</#if>
</#list>
import [=CommonModulePackage].logging.LoggingHelper;

@RestController
@RequestMapping("/[=ApiPath]")
public class [=ClassName]Controller {

	@Autowired
	private [=ClassName]AppService _[=ClassName?uncap_first]AppService;
    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    
    @Autowired
	private [=relationValue.eName]AppService  _[=relationValue.eName?uncap_first]AppService;
    </#if>
    </#list>

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;
    
    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_CREATE')")
    </#if>
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create[=ClassName]Output> Create(@RequestBody @Valid Create[=ClassName]Input [=ClassName?uncap_first]) {
		Create[=ClassName]Output output=_[=ClassName?uncap_first]AppService.Create([=ClassName?uncap_first]);
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete [=ClassName?uncap_first] ------------
	<#if AuthenticationType != "none">
//	@PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_DELETE')")
	</#if>
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	
<#list Fields as key,value>
<#if value.isPrimaryKey!false>
 <#if value.fieldType?lower_case == "long">
    Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));
 <#elseif value.fieldType?lower_case == "integer" >
    Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Integer.valueOf(id));
 <#elseif value.fieldType?lower_case == "short" >
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Short.valueOf(id));
 <#elseif value.fieldType?lower_case == "double" >
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Double.valueOf(id));
 <#elseif value.fieldType?lower_case == "string">
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(id);
 </#if>
</#if>  
</#list>
		if (output == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?uncap_first] with a id=%s", id);
			throw new EntityNotFoundException(
					String.format("There does not exist a [=ClassName?uncap_first] with a id=%s", id));
		}
		_[=ClassName?uncap_first]AppService.Delete(Long.valueOf(id));
	}
	
	// ------------ Update [=ClassName?uncap_first] ------------
	<#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_UPDATE')")
    </#if>
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update[=ClassName]Output> Update(@PathVariable String id, @RequestBody @Valid Update[=ClassName]Input [=ClassName?uncap_first]) {
<#list Fields as key,value>
<#if value.isPrimaryKey!false>
 <#if value.fieldType?lower_case == "long">
    Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));
 <#elseif value.fieldType?lower_case == "integer" >
    Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Integer.valueOf(id));
 <#elseif value.fieldType?lower_case == "short" >
  	Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Short.valueOf(id));
 <#elseif value.fieldType?lower_case == "double" >
  	Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Double.valueOf(id));
 <#elseif value.fieldType?lower_case == "string">
  	Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(id);
 </#if>
</#if>  
</#list>
		
		if (current[=ClassName] == null) {
			logHelper.getLogger().error("Unable to update. [=ClassName] with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_[=ClassName?uncap_first]AppService.Update(Long.valueOf(id),[=ClassName?uncap_first]), HttpStatus.OK);
	}

    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find[=ClassName]ByIdOutput> FindById(@PathVariable String id) {

<#list Fields as key,value>
<#if value.isPrimaryKey!false>
 <#if value.fieldType?lower_case == "long">
    Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));
 <#elseif value.fieldType?lower_case == "integer" >
    Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Integer.valueOf(id));
 <#elseif value.fieldType?lower_case == "short" >
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Short.valueOf(id));
 <#elseif value.fieldType?lower_case == "double" >
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Double.valueOf(id));
 <#elseif value.fieldType?lower_case == "string">
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(id);
 </#if> 
</#if> 
</#list>
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
    
    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_[=ClassName?uncap_first]AppService.Find(searchCriteria,Pageable));
	}
   <#list Relationship as relationKey, relationValue>
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">

    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName](@PathVariable String [=InstanceName]id) {
		Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName](Long.valueOf([=InstanceName]id));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
   <#elseif relationValue.relation == "OneToMany">
    
    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity Get[=relationValue.eName](@PathVariable String [=InstanceName]id, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		searchCriteria.setJoinColumn("[=relationValue.joinColumn?uncap_first]");
		searchCriteria.setJoinColumnValue(Long.valueOf([=InstanceName]id));
    	List<Find[=relationValue.eName]ByIdOutput> output = _[=relationValue.eName?uncap_first]AppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
 
   </#if>
  
  </#list>

}

