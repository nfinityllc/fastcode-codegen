package [=PackageName].RestControllers;

import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].application.Authorization.Permissions.Dto.FindPermissionByIdOutput;
import [=PackageName].application.Authorization.Roles.Dto.FindRoleByIdOutput;
import [=PackageName].application.Authorization.Users.UserAppService;
import [=PackageName].application.Authorization.Users.Dto.*;
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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

@RestController
@RequestMapping("/users")
public class UserController {


	@Autowired
	private UserAppService userAppService;
	
	@Autowired
    private PermissionAppService permissionAppService;
	
	@Autowired
    private PasswordEncoder pEncoder;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;


	// CRUD Operations

	// ------------ Create a user ------------
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreateUserOutput> Create(@RequestBody @Valid CreateUserInput user) {
		 FindUserByNameOutput foundUser = userAppService.FindByUserName(user.getUserName());

	        if (foundUser != null) {
	            logHelper.getLogger().error("There already exists a user with a name=%s", user.getUserName());
	            throw new EntityExistsException(
	                    String.format("There already exists a user with email address=%s", user.getUserName()));
	        }
	        
	    user.setPassword(pEncoder.encode(user.getPassword()));
	    CreateUserOutput output= userAppService.Create(user);
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete a user ------------
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
    	FindUserByIdOutput existing = userAppService.FindById(Long.valueOf(id));

        if (existing == null) {
        	logHelper.getLogger().error("There does not exist a user with a id=%s", id);
        	 throw new EntityNotFoundException(
	                    String.format("There does not exist a user with a id=%s", id));
	     
        }
    	
		userAppService.Delete(Long.valueOf(id));
	}
	// ------------ Update a user ------------

	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdateUserOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateUserInput user) {
		
		FindUserByIdOutput existing = userAppService.FindById(Long.valueOf(id));

        if (existing == null) {
			logHelper.getLogger().error("Unable to update. User with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(userAppService.Update(Long.valueOf(id), user), HttpStatus.OK);
	}

	// ------------ Retrieve a user ------------

//	@PreAuthorize("hasAuthority('ADMINS')")
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindUserByIdOutput> FindById(@PathVariable @Valid String id) {
		FindUserByIdOutput uo = userAppService.FindById(Long.valueOf(id));

		if (uo == null) {
			logHelper.getLogger().error("There does not exist a user with a id=%s", id);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a user with a id=%s", id));
		}
		return new ResponseEntity(uo, HttpStatus.OK);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value = "search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable offsetPageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(userAppService.Find(searchCriteria, offsetPageable));
	}

	@RequestMapping(value = "/{usersid}/roles", method = RequestMethod.GET)
	public ResponseEntity<GetRoleOutput> GetRoles(@PathVariable String usersid) {
		GetRoleOutput output= userAppService.GetRoles(Long.valueOf(usersid));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
  
    // Permissions related methods
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{usersid}/permissions", method = RequestMethod.POST)
	public void AddPermissions(@PathVariable String usersid, @RequestBody @Valid String permissionsid) {
		FindUserByIdOutput foundUsers = userAppService.FindById(Long.valueOf(usersid));

		if (foundUsers == null) {
			logHelper.getLogger().error("There does not exist a users with a id=%s", usersid);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a users with a id=%s", usersid));
		}
		FindPermissionByIdOutput foundPermissions = permissionAppService.FindById(Long.valueOf(permissionsid));

        if (foundPermissions == null) {
            logHelper.getLogger().error("There does not exist a permissions with a id=%s", permissionsid);
            throw new EntityNotFoundException(
                    String.format("There does not exist a permissions with a id=%s", permissionsid));
        }
		Boolean status = userAppService.AddPermissions(Long.valueOf(usersid), Long.valueOf(permissionsid));
		if(status == false) {
	    	   logHelper.getLogger().error("The users already has the permissions");
	    	   throw new EntityExistsException("The users already has the permissions");
	   	}
	
	}

	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{usersid}/permissions/{permissionsid}", method = RequestMethod.DELETE)
	public void RemovePermissions(@PathVariable String usersid, @PathVariable String permissionsid) {
		FindUserByIdOutput foundUsers = userAppService.FindById(Long.valueOf(usersid));

		if (foundUsers == null) {
			logHelper.getLogger().error("There does not exist a users with a id = " + usersid);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a users with a id=%s", usersid));
		}
		FindPermissionByIdOutput foundPermissions = permissionAppService.FindById(Long.valueOf(permissionsid));

        if (foundPermissions == null) {
            logHelper.getLogger().error("There does not exist a permissions with a id =" + permissionsid);
            throw new EntityNotFoundException(
                    String.format("There does not exist a permissions with a id=%s", permissionsid));
        }
		userAppService.RemovePermissions(Long.valueOf(usersid), Long.valueOf(permissionsid));
		
	}

	@RequestMapping(value = "/{usersid}/permissions/{permissionsid}", method = RequestMethod.GET)
	public ResponseEntity<GetPermissionOutput> GetPermissionsById(@PathVariable String usersid, @PathVariable String permissionsid) {
		GetPermissionOutput output= userAppService.GetPermissions(Long.valueOf(usersid), Long.valueOf(permissionsid));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
    @RequestMapping(value = "/{usersid}/permissions", method = RequestMethod.GET)
	public ResponseEntity GetPermissionsList(@PathVariable String usersid,@RequestParam(value = "search", required=false) String search,@RequestParam(value = "operator", required=false) String operator,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception{
		if (operator == null) { operator="equals"; } else if(!operator.equalsIgnoreCase("notEqual")) { operator="equals"; }
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
        SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);

		List<GetPermissionOutput> output = userAppService.GetPermissionsList(Long.valueOf(usersid),searchCriteria,operator,Pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}


}