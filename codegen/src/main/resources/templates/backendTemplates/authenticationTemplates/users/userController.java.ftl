package [=PackageName].RestControllers;

import [=PackageName].application.Authorization.Permission.PermissionAppService;
import [=PackageName].application.Authorization.Permission.Dto.FindPermissionByIdOutput;
import [=PackageName].application.Authorization.Role.Dto.FindRoleByIdOutput;
import [=PackageName].application.Authorization.User.UserAppService;
import [=PackageName].application.Authorization.User.Dto.*;
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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

@RestController
@RequestMapping("/user")
public class UserController {


	@Autowired
	private UserAppService _userAppService;
    
    @Autowired
	private UserpermissionAppService  _userpermissionAppService;
	
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
	    CreateUserOutput output=_userAppService.Create(user);
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
    	FindUserByIdOutput existing = _userAppService.FindById(Long.valueOf(id));

        if (existing == null) {
        	logHelper.getLogger().error("There does not exist a user with a id=%s", id);
        	 throw new EntityNotFoundException(
	                    String.format("There does not exist a user with a id=%s", id));
	     
        }
    	
		_userAppService.Delete(Long.valueOf(id));
	}
	
	// ------------ Update user ------------
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdateUserOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateUserInput user) {
    FindUserByIdOutput currentUser = _userAppService.FindById(Long.valueOf(id));
		
		if (currentUser == null) {
			logHelper.getLogger().error("Unable to update. User with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
    return new ResponseEntity(_userAppService.Update(Long.valueOf(id),user), HttpStatus.OK);
	}


	// ------------ Retrieve a user ------------
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindUserByIdOutput> FindById(@PathVariable String id) {
    FindUserByIdOutput output = _userAppService.FindById(Long.valueOf(id));
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
		
		return ResponseEntity.ok(_userAppService.Find(searchCriteria,Pageable));
	}

	@RequestMapping(value = "/{userid}/userpermission", method = RequestMethod.GET)
	public ResponseEntity GetUserpermission(@PathVariable String userid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_userAppService.parseUserpermissionJoinColumn(userid);
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
 
  

	@RequestMapping(value = "/{userid}/role", method = RequestMethod.GET)
	public ResponseEntity<GetRoleOutput> GetRole(@PathVariable String id) {
    GetRoleOutput output= _userAppService.GetRole(Long.valueOf(id));
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}


}