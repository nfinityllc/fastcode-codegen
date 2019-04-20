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
	private [=ClassName]AppService _[=ClassName?lower_case]AppService;
    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    
    @Autowired
	private [=relationValue.eName]AppService  _[=relationValue.eName?lower_case]AppService;
    </#if>
    </#list>

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;


	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create[=ClassName]Output> Create(@RequestBody @Valid Create[=ClassName]Input [=ClassName?lower_case]) {
		
		return new ResponseEntity(_[=ClassName?lower_case]AppService.Create([=ClassName?lower_case]), HttpStatus.OK);
	}

	// ------------ Delete [=ClassName?lower_case] ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
		Find[=ClassName]ByIdOutput output = _[=ClassName?lower_case]AppService.FindById(Long.valueOf(id));

		if (output == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?lower_case] with a id=%s", id);
			throw new EntityNotFoundException(
					String.format("There does not exist a [=ClassName?lower_case] with a id=%s", id));
		}
		_[=ClassName?lower_case]AppService.Delete(Long.valueOf(id));
	}
	// ------------ Update [=ClassName?lower_case] ------------

	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update[=ClassName]Output> Update(@PathVariable String id, @RequestBody @Valid Update[=ClassName]Input [=ClassName?lower_case]) {
		Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?lower_case]AppService.FindById(Long.valueOf(id));
		if (current[=ClassName] == null) {
			logHelper.getLogger().error("Unable to update. [=ClassName] with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_[=ClassName?lower_case]AppService.Update(Long.valueOf(id),[=ClassName?lower_case]), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find[=ClassName]ByIdOutput> FindById(@PathVariable String id) {

		Find[=ClassName]ByIdOutput output = _[=ClassName?lower_case]AppService.FindById(Long.valueOf(id));

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

		return ResponseEntity.ok(_[=ClassName?lower_case]AppService.Find(search,Pageable));
	}

<#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]", method = RequestMethod.POST)
	public void Add[=relationValue.eName](@PathVariable @Valid String [=InstanceName]id, @RequestBody @Valid String [=relationValue.eName?lower_case]id) {
		Find[=ClassName]ByIdOutput found[=ClassName] = _[=ClassName?lower_case]AppService.FindById(Long.valueOf([=InstanceName]id));

		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id));
		}
		Find[=relationValue.eName]ByIdOutput found[=relationValue.eName] = _[=relationValue.eName?lower_case]AppService.FindById(Long.valueOf([=relationValue.eName?lower_case]id));

        if (found[=relationValue.eName] == null) {
            logHelper.getLogger().error("There does not exist a [=relationValue.eName?lower_case] with a id=%s", [=relationValue.eName?lower_case]id);
            throw new EntityNotFoundException(
                    String.format("There does not exist a [=relationValue.eName?lower_case] with a id=%s", [=relationValue.eName?lower_case]id));
        }
		_[=ClassName?lower_case]AppService.Add[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?lower_case]id));
		
	}
	
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]", method = RequestMethod.DELETE)
	public void Remove[=relationValue.eName](@PathVariable String [=InstanceName]id) {
		Find[=ClassName]ByIdOutput found[=ClassName] = _[=ClassName?lower_case]AppService.FindById(Long.valueOf([=InstanceName]id));

		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id));
		}
		_[=ClassName?lower_case]AppService.Remove[=relationValue.eName](Long.valueOf([=InstanceName]id));
		
	}

	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName](@PathVariable String [=InstanceName]id) {
		Get[=relationValue.eName]Output output= _[=ClassName?lower_case]AppService.Get[=relationValue.eName](Long.valueOf([=InstanceName]id));
		
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
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]", method = RequestMethod.POST)
	public void Add[=relationValue.eName](@PathVariable String [=InstanceName]id, @RequestBody @Valid String [=relationValue.eName?lower_case]id) {
		Find[=ClassName]ByIdOutput found[=ClassName] = _[=ClassName?lower_case]AppService.FindById(Long.valueOf([=InstanceName]id));

		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id));
		}
		Find[=relationValue.eName]ByIdOutput found[=relationValue.eName] = _[=relationValue.eName?lower_case]AppService.FindById(Long.valueOf([=relationValue.eName?lower_case]id));

        if (found[=relationValue.eName] == null) {
            logHelper.getLogger().error("There does not exist a [=relationValue.eName?lower_case] with a id=%s", [=relationValue.eName?lower_case]id);
            throw new EntityNotFoundException(
                    String.format("There does not exist a [=relationValue.eName?lower_case] with a id=%s", [=relationValue.eName?lower_case]id));
        }
		Boolean status = _[=ClassName?lower_case]AppService.Add[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?lower_case]id));
		if(status == false)
	       {
	    	   logHelper.getLogger().error("The [=ClassName?lower_case] already has the [=relationValue.eName?lower_case]");
	    	   throw new EntityExistsException("The [=ClassName?lower_case] already has the [=relationValue.eName?lower_case]");
	   		 }
	
	}

	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]/{[=relationValue.eName?lower_case]id}", method = RequestMethod.DELETE)
	public void Remove[=relationValue.eName](@PathVariable String [=InstanceName]id, @PathVariable String [=relationValue.eName?lower_case]id) {
		Find[=ClassName]ByIdOutput found[=ClassName] = _[=ClassName?lower_case]AppService.FindById(Long.valueOf([=InstanceName]id));

		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?lower_case] with a id = " + [=InstanceName]id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a [=ClassName?lower_case] with a id=%s", [=InstanceName]id));
		}
		Find[=relationValue.eName]ByIdOutput found[=relationValue.eName] = _[=relationValue.eName?lower_case]AppService.FindById(Long.valueOf([=relationValue.eName?lower_case]id));

        if (found[=relationValue.eName] == null) {
            logHelper.getLogger().error("There does not exist a [=relationValue.eName?lower_case] with a id =" + [=relationValue.eName?lower_case]id);
            throw new EntityNotFoundException(
                    String.format("There does not exist a [=relationValue.eName?lower_case] with a id=%s", [=relationValue.eName?lower_case]id));
        }
		_[=ClassName?lower_case]AppService.Remove[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?lower_case]id));
		
	}

	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]/{[=relationValue.eName?lower_case]id}", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName]ById(@PathVariable String [=InstanceName]id, @PathVariable String [=relationValue.eName?lower_case]id) {
		Get[=relationValue.eName]Output output= _[=ClassName?lower_case]AppService.Get[=relationValue.eName](Long.valueOf([=InstanceName]id), Long.valueOf([=relationValue.eName?lower_case]id));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}

	@RequestMapping(value = "/{[=InstanceName]id}/[=relationValue.eName?lower_case]", method = RequestMethod.GET)
	public ResponseEntity Get[=relationValue.eName]s(@PathVariable String [=InstanceName]id) {
		List<Get[=relationValue.eName]Output> output = _[=ClassName?lower_case]AppService.Get[=relationValue.eName]s(Long.valueOf([=InstanceName]id));
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

