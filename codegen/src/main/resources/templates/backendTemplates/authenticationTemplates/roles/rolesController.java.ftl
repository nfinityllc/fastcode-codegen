package [=PackageName].RestControllers;

import [=PackageName].application.Authorization.Permissions.PermissionAppService;
import [=PackageName].application.Authorization.Permissions.Dto.FindPermissionByIdOutput;
<#if AuthenticationType == "database">
import [=PackageName].application.Authorization.Users.Dto.FindUserByIdOutput;
import [=PackageName].application.Authorization.Users.UserAppService;
</#if>
import [=PackageName].application.Authorization.Roles.RoleAppService;
import [=PackageName].application.Authorization.Roles.Dto.*;
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
import java.util.List;

@RestController
@RequestMapping("/roles")
public class RoleController {

    @Autowired
    private RoleAppService roleAppService;
    
    <#if AuthenticationType == "database">
    @Autowired
	private UserAppService  userAppService;
	</#if>
	@Autowired
	private PermissionAppService  permissionAppService;

    @Autowired
    private LoggingHelper logHelper;

    @Autowired
    private Environment env;

    // CRUD Operations

    // ------------ Create a role ------------
    @RequestMapping(method = RequestMethod.POST)
    public ResponseEntity<CreateRoleOutput> Create(@RequestBody @Valid CreateRoleInput role) {

        FindRoleByNameOutput foundRole = roleAppService.FindByRoleName(role.getName());

        if (foundRole != null) {
            logHelper.getLogger().error("There already exists a role with name=%s", role.getName());
            throw new EntityExistsException(
                    String.format("There already exists a role with name=%s", role.getName()));
        }

        return new ResponseEntity(roleAppService.Create(role), HttpStatus.OK);
    }

    // ------------ Delete a role ------------
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
    @RequestMapping(value = "/{rid}", method = RequestMethod.DELETE)
    public void Delete(@PathVariable String rid) {
    	
    	FindRoleByIdOutput ro = roleAppService.FindById(Long.valueOf(rid));

        if (ro == null) {
        	logHelper.getLogger().error("There does not exist a role wth a id=%s", rid);
            throw new EntityNotFoundException(
                    String.format("There does not exist a role wth a id=%s", rid));
        }
        roleAppService.Delete(Long.valueOf(rid));
    }
    // ------------ Update a role ------------

    @RequestMapping(value = "/{rid}", method = RequestMethod.PUT)
    public ResponseEntity<UpdateRoleOutput> Update(@PathVariable String rid, @RequestBody @Valid UpdateRoleInput role) {
        FindRoleByIdOutput currentRole = roleAppService.FindById(Long.valueOf(rid));
        if (currentRole == null) {
            logHelper.getLogger().error("Unable to update. Role with id {} not found.", rid);
            return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity(roleAppService.Update(Long.valueOf(rid), role), HttpStatus.OK);
    }

    @RequestMapping(value = "/{rid}", method = RequestMethod.GET)
    public ResponseEntity<FindRoleByIdOutput> FindById(@PathVariable String rid) {

        FindRoleByIdOutput ro = roleAppService.FindById(Long.valueOf(rid));

        if (ro == null) {
            return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity(ro, HttpStatus.OK);
    }

    @RequestMapping(method = RequestMethod.GET)
    public ResponseEntity Find(@RequestParam(value = "search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
        if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
        if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
        if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

        Pageable offsetPageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
    	SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
        return ResponseEntity.ok(roleAppService.Find(searchCriteria, offsetPageable));
    }
    <#if AuthenticationType == "database">
  @RequestMapping(value = "/{roleid}/users", method = RequestMethod.GET)
	public ResponseEntity GetUsers(@PathVariable String rolesid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		searchCriteria.setJoinColumn("roleId");
		searchCriteria.setJoinColumnValue(Long.valueOf(rolesid));
    	List<FindUserByIdOutput> output = userAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}  
	</#if>
	
	
    // Permissions related methods
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{rolesid}/permissions", method = RequestMethod.POST)
	public void AddPermissions(@PathVariable String rolesid, @RequestBody @Valid String permissionsid) {
		FindRoleByIdOutput foundRoles = roleAppService.FindById(Long.valueOf(rolesid));

		if (foundRoles == null) {
			logHelper.getLogger().error("There does not exist a roles with a id=%s", rolesid);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a roles with a id=%s", rolesid));
		}
		FindPermissionByIdOutput foundPermissions = permissionAppService.FindById(Long.valueOf(permissionsid));

        if (foundPermissions == null) {
            logHelper.getLogger().error("There does not exist a permissions with a id=%s", permissionsid);
            throw new EntityNotFoundException(
                    String.format("There does not exist a permissions with a id=%s", permissionsid));
        }
		Boolean status = roleAppService.AddPermission(Long.valueOf(rolesid), Long.valueOf(permissionsid));
		if(status == false) {
	    	   logHelper.getLogger().error("The roles already has the permissions");
	    	   throw new EntityExistsException("The roles already has the permissions");
	   	}
	
	}

	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{rolesid}/permissions/{permissionsid}", method = RequestMethod.DELETE)
	public void RemovePermissions(@PathVariable String rolesid, @PathVariable String permissionsid) {
		FindRoleByIdOutput foundRoles = roleAppService.FindById(Long.valueOf(rolesid));

		if (foundRoles == null) {
			logHelper.getLogger().error("There does not exist a roles with a id = " + rolesid);
       	 throw new EntityNotFoundException(
	                    String.format("There does not exist a roles with a id=%s", rolesid));
		}
		FindPermissionByIdOutput foundPermissions = permissionAppService.FindById(Long.valueOf(permissionsid));

        if (foundPermissions == null) {
            logHelper.getLogger().error("There does not exist a permissions with a id =" + permissionsid);
            throw new EntityNotFoundException(
                    String.format("There does not exist a permissions with a id=%s", permissionsid));
        }
		roleAppService.RemovePermission(Long.valueOf(rolesid), Long.valueOf(permissionsid));
		
	}

	@RequestMapping(value = "/{rolesid}/permissions/{permissionsid}", method = RequestMethod.GET)
	public ResponseEntity<GetPermissionOutput> GetPermissionsById(@PathVariable String rolesid, @PathVariable String permissionsid) {
		GetPermissionOutput output= roleAppService.GetPermissions(Long.valueOf(rolesid), Long.valueOf(permissionsid));
		
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
    @RequestMapping(value = "/{rolesid}/permissions", method = RequestMethod.GET)
	public ResponseEntity GetPermissionsList(@PathVariable String rolesid,@RequestParam(value = "search", required=false) String search,@RequestParam(value = "operator", required=false) String operator,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception{
		if (operator == null) { operator="equals"; } else if(!operator.equalsIgnoreCase("notEqual")) { operator="equals"; }
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
        SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);

		List<GetPermissionOutput> output = roleAppService.GetPermissionsList(Long.valueOf(rolesid),searchCriteria,operator,Pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

   

}