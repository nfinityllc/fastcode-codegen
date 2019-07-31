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
<#if relationValue.relation == "ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if relationKey == parent>
<#if parent?keep_after("-") == relationValue.eName>
import java.util.List;
import javax.persistence.EntityExistsException;
import [=PackageName].application.[=relationValue.eName].Dto.Find[=relationValue.eName]ByIdOutput;
</#if>
</#if>
</#list>
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
		Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));

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
		Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));
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

		Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));

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
   <#if relationValue.relation == "ManyToOne">

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
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if relationKey == parent>
  <#if parent?keep_after("-") == relationValue.eName>
    // [=relationValue.eName] related methods
    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_UPDATE')")
    </#if>
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]", method = RequestMethod.POST)
	public void Add[=relationValue.eName](@PathVariable String [=InstanceName]id, @RequestBody @Valid String [=relationValue.eName?uncap_first]id) {
		Find[=ClassName]ByIdOutput found[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf([=InstanceName]id));

		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?uncap_first] with a id=%s", [=InstanceName]id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a [=ClassName?uncap_first] with a id=%s", [=InstanceName]id));
		}
		Find[=relationValue.eName]ByIdOutput found[=relationValue.eName] = _[=relationValue.eName?uncap_first]AppService.FindById(Long.valueOf([=relationValue.eName?uncap_first]id));

        if (found[=relationValue.eName] == null) {
            logHelper.getLogger().error("There does not exist a [=relationValue.eName?uncap_first] with a id=%s", [=relationValue.eName?uncap_first]id);
            throw new EntityNotFoundException(
                    String.format("There does not exist a [=relationValue.eName?uncap_first] with a id=%s", [=relationValue.eName?uncap_first]id));
        }
		Boolean status = _[=ClassName?uncap_first]AppService.Add[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?uncap_first]id));
		if(status == false) {
	    	   logHelper.getLogger().error("The [=ClassName?uncap_first] already has the [=relationValue.eName?uncap_first]");
	    	   throw new EntityExistsException("The [=ClassName?uncap_first] already has the [=relationValue.eName?uncap_first]");
	   	}
	
	}
    
    <#if AuthenticationType != "none">
//  @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_UPDATE')")
    </#if>
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]/{[=relationValue.eName?uncap_first]id}", method = RequestMethod.DELETE)
	public void Remove[=relationValue.eName](@PathVariable String [=InstanceName]id, @PathVariable String [=relationValue.eName?uncap_first]id) {
		Find[=ClassName]ByIdOutput found[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf([=InstanceName]id));

		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?uncap_first] with a id = " + [=InstanceName]id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a [=ClassName?uncap_first] with a id=%s", [=InstanceName]id));
		}
		Find[=relationValue.eName]ByIdOutput found[=relationValue.eName] = _[=relationValue.eName?uncap_first]AppService.FindById(Long.valueOf([=relationValue.eName?uncap_first]id));

        if (found[=relationValue.eName] == null) {
            logHelper.getLogger().error("There does not exist a [=relationValue.eName?uncap_first] with a id =" + [=relationValue.eName?uncap_first]id);
            throw new EntityNotFoundException(
                    String.format("There does not exist a [=relationValue.eName?uncap_first] with a id=%s", [=relationValue.eName?uncap_first]id));
        }
		_[=ClassName?uncap_first]AppService.Remove[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?uncap_first]id));
		
	}
    
    <#if AuthenticationType != "none">
//    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]/{[=relationValue.eName?uncap_first]id}", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName]ById(@PathVariable String [=InstanceName]id, @PathVariable String [=relationValue.eName?uncap_first]id) {
		Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?uncap_first]id));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
	
	<#if AuthenticationType != "none">
//	@PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
	</#if>
    @RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity Get[=relationValue.eName]List(@PathVariable String [=InstanceName]id,@RequestParam(value = "search", required=false) String search,@RequestParam(value = "operator", required=false) String operator,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception{
		if (operator == null) { operator="equals"; } else if(!operator.equalsIgnoreCase("notEqual")) { operator="equals"; }
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
        SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);

		List<Get[=relationValue.eName]Output> output = _[=ClassName?uncap_first]AppService.Get[=relationValue.eName]List(Long.valueOf([=InstanceName]id),searchCriteria,operator,Pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
	
	<#if AuthenticationType != "none">
//	@PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
	</#if>
        @RequestMapping(value = "/{[=relationValue.joinColumn]}/available[=relationValue.eName]", method = RequestMethod.GET)
	public ResponseEntity GetAvailable[=relationValue.eName]List(@PathVariable String [=relationValue.joinColumn],@RequestParam(value = "search", required=false) String search,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception{
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);

		List<Find[=relationValue.eName]ByIdOutput> output = _[=ClassName?uncap_first]AppService.GetAvailable[=relationValue.eName]List(Long.valueOf([=relationValue.joinColumn]),search,Pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

   </#if>
   </#if>
   </#list>
   </#if>
  
  </#list>

}

