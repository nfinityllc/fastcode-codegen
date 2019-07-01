package [=PackageName].application.Authorization.Roles;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Authorization.Roles.Dto.*;

import javax.validation.constraints.Positive;

import java.util.List;

@Service
public interface IRoleAppService {
    // CRUD Operations

    CreateRoleOutput Create( CreateRoleInput input);

    void Delete(@Positive(message ="RoleId should be a positive value") Long rid);

    UpdateRoleOutput Update(@Positive(message ="RoleId should be a positive value") Long roleId, UpdateRoleInput input);

    FindRoleByIdOutput FindById(@Positive(message ="RoleId should be a positive value") Long rid);

    List<FindRoleByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;


    // Operations With Permission
    Boolean AddPermission(@Positive(message ="RoleId should be a positive value") Long roleId,@Positive(message ="PermissionId should be a positive value") Long pid);

    void RemovePermission(@Positive(message ="RoleId should be a positive value") Long rid, @Positive(message ="PermissionId should be a positive value") Long pid);

    GetPermissionOutput GetPermissions(@Positive(message ="RoleId should be a positive value") Long rid, @Positive(message ="PermissionId should be a positive value") Long pid);

    List<GetPermissionOutput> GetPermissionsList(@Positive(message ="RoleId should be a positive value") Long rid,SearchCriteria search,String operator,Pageable pageable) throws Exception;
}
