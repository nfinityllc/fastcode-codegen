package [=PackageName].RestControllers;

import [=PackageName].application.Authorization.Permission.PermissionAppService;
import [=PackageName].application.Authorization.Rolepermission.RolepermissionAppService;
import [=PackageName].application.Authorization.Userpermission.UserpermissionAppService;
import [=PackageName].application.Authorization.Permission.Dto.*;
import [=PackageName].application.Authorization.Rolepermission.Dto.FindRolepermissionByIdOutput;
import [=PackageName].application.Authorization.Userpermission.Dto.FindUserpermissionByIdOutput;
import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].logging.LoggingHelper;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

@RestController
@RequestMapping("/permission")
public class PermissionController {

	@Autowired
	private PermissionAppService _permissionAppService;
    
    @Autowired
	private RolepermissionAppService  _rolepermissionAppService;
    
    @Autowired
	private UserpermissionAppService  _userpermissionAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	// CRUD Operations

	// ------------ Create a permission ------------
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreatePermissionOutput> Create(@RequestBody @Valid CreatePermissionInput permission) {

		FindPermissionByNameOutput existing = _permissionAppService.FindByPermissionName(permission.getName());

		CreatePermissionOutput output=_permissionAppService.Create(permission);
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete permission ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
    FindPermissionByIdOutput output = _permissionAppService.FindById(Long.valueOf(id));
	if (output == null) {
		logHelper.getLogger().error("There does not exist a permission with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a permission with a id=%s", id));
	}
    _permissionAppService.Delete(Long.valueOf(id));
    }
	
	// ------------ Update permission ------------
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdatePermissionOutput> Update(@PathVariable String id, @RequestBody @Valid UpdatePermissionInput permission) {
    FindPermissionByIdOutput currentPermission = _permissionAppService.FindById(Long.valueOf(id));
		
		if (currentPermission == null) {
			logHelper.getLogger().error("Unable to update. Permission with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
    return new ResponseEntity(_permissionAppService.Update(Long.valueOf(id),permission), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindPermissionByIdOutput> FindById(@PathVariable String id) {
    FindPermissionByIdOutput output = _permissionAppService.FindById(Long.valueOf(id));
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
    
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_permissionAppService.Find(searchCriteria,Pageable));
	}
    
	@RequestMapping(value = "/{permissionid}/rolepermission", method = RequestMethod.GET)
	public ResponseEntity GetRolepermission(@PathVariable String permissionid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_permissionAppService.parseRolepermissionJoinColumn(permissionid);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<FindRolepermissionByIdOutput> output = _rolepermissionAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
 
  
    
	@RequestMapping(value = "/{permissionid}/userpermission", method = RequestMethod.GET)
	public ResponseEntity GetUserpermission(@PathVariable String permissionid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_permissionAppService.parseUserpermissionJoinColumn(permissionid);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<FindUserpermissionByIdOutput> output = _userpermissionAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	} 
}
