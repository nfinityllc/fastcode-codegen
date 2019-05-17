package [=PackageName].RestControllers;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;
import java.util.List;
import java.util.ArrayList;

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

import [=PackageName].Utils.OffsetBasedPageRequest;
import [=PackageName].application.[=ClassName].[=ClassName]AppService;
import [=PackageName].application.[=ClassName].[=ClassName]Mapper;
import [=PackageName].application.[=ClassName].Dto.*;
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].application.[=relationValue.eName].Dto.Find[=relationValue.eName]ByIdOutput;
import [=PackageName].application.[=relationValue.eName].[=relationValue.eName]AppService;
</#if>
</#list>
import [=PackageName].Utils.LoggingHelper;

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

	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update[=ClassName]Output> Update(@PathVariable String id, @RequestBody @Valid Update[=ClassName]Input [=ClassName?uncap_first]) {
		Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));
		if (current[=ClassName] == null) {
			logHelper.getLogger().error("Unable to update. [=ClassName] with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_[=ClassName?uncap_first]AppService.Update(Long.valueOf(id),[=ClassName?uncap_first]), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find[=ClassName]ByIdOutput> FindById(@PathVariable String id) {

		Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(Long.valueOf(id));

		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value = "search", required=false) String search,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);

		return ResponseEntity.ok(_[=ClassName?uncap_first]AppService.Find(search,Pageable));
	}

<#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">

	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName](@PathVariable String [=InstanceName]id) {
		Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName](Long.valueOf([=InstanceName]id));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
   <#elseif relationValue.relation == "OneToMany">

	@RequestMapping(value = "/{[=relationValue.joinColumn?lower_case]}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity Get[=relationValue.eName](@PathVariable String [=InstanceName]id,@RequestParam(value = "search", required=false) String search,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		if(search==null || search.isEmpty()) {
			search = "[=relationValue.joinColumn];" + [=relationValue.joinColumn?lower_case];
		}
		else {
			search = search + ",[=relationValue.joinColumn];" + [=relationValue.joinColumn?lower_case];
		}
   		List<Find[=relationValue.eName]ByIdOutput> output = _[=relationValue.eName?uncap_first]AppService.Find(search,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if parent?keep_after("-") == relationValue.eName>
    // [=relationValue.eName] related methods
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

	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]/{[=relationValue.eName?uncap_first]id}", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName]ById(@PathVariable String [=InstanceName]id, @PathVariable String [=relationValue.eName?uncap_first]id) {
		Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?uncap_first]id));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}

	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity Get[=relationValue.eName]List(@PathVariable String [=InstanceName]id) {
		List<Get[=relationValue.eName]Output> output = _[=ClassName?uncap_first]AppService.Get[=relationValue.eName]List(Long.valueOf([=InstanceName]id));
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
   </#if>
   </#list>
   </#if>
  
  </#list>

}

