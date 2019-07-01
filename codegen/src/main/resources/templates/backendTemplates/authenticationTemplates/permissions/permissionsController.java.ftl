package [=PackageName].RestControllers;

import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].application.Authorization.Permissions.Dto.*;
import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].logging.LoggingHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

@RestController
@RequestMapping("/permissions")
public class PermissionController {

	@Autowired
	private PermissionAppService permissionAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	// CRUD Operations

	// ------------ Create a permission ------------
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreatePermissionOutput> Create(@RequestBody @Valid CreatePermissionInput permission) {

		FindPermissionByNameOutput existing = permissionAppService.FindByPermissionName(permission.getName());

		if (existing != null) {
			logHelper.getLogger().error("There already exists a permission with name=%s", permission.getName());
			throw new EntityExistsException(
					String.format("There already exists a permission with name=%s", permission.getName()));
		}
		return new ResponseEntity(permissionAppService.Create(permission), HttpStatus.OK);
	}

	// ------------ Delete a permission ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{pid}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String pid) {
		FindPermissionByIdOutput existing = permissionAppService.FindById(Long.valueOf(pid));

		if (existing == null) {
			logHelper.getLogger().error("There does not exist a permission wth a id=%s", pid);
			throw new EntityNotFoundException(
					String.format("There does not exist a permission wth a id=%s", pid));
		}
		permissionAppService.Delete(Long.valueOf(pid));
	}
	// ------------ Update a permission ------------

	@RequestMapping(value = "/{pid}", method = RequestMethod.PUT)
	public ResponseEntity<UpdatePermissionOutput> Update(@PathVariable String pid, @RequestBody @Valid UpdatePermissionInput permission) {

		FindPermissionByIdOutput existing = permissionAppService.FindById(Long.valueOf(pid));
		if (existing == null) {
			logHelper.getLogger().error("Unable to update. Permission with id {} not found.", pid);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(permissionAppService.Update(Long.valueOf(pid), permission), HttpStatus.OK);
	}

	// ------------ Retrieve a permission ------------
	@RequestMapping(value = "/{pid}", method = RequestMethod.GET)
	public ResponseEntity<FindPermissionByIdOutput> FindById(@PathVariable String pid) {

		FindPermissionByIdOutput existing = permissionAppService.FindById(Long.valueOf(pid));

		if (existing == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(existing, HttpStatus.OK);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value = "search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable offsetPageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(permissionAppService.Find(searchCriteria, offsetPageable));
	}
}
