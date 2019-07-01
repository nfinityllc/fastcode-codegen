package [=PackageName].domain.Authorization.Roles;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.RolesEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import [=CommonModulePackage].Search.SearchFields;

import java.util.List;

import javax.validation.constraints.Positive;

public interface IRolesManager {

    // CRUD Operations
    RolesEntity Create(RolesEntity role);

    void Delete(RolesEntity role);

    RolesEntity Update(RolesEntity role);

    RolesEntity FindById(@Positive(message ="Id should be a positive value") Long roleId);

    Page<RolesEntity> FindAll(Predicate predicate, Pageable pageable);

    // Internal Operation
    RolesEntity FindByRoleName(String roleName);

    // Permissions Operations
    Boolean AddPermission(RolesEntity role, PermissionsEntity permission);

    void RemovePermission(RolesEntity role, PermissionsEntity permission);

   public PermissionsEntity GetPermissions(@Positive(message ="rolesId should be a positive value") Long rolesId,@Positive(message ="PermissionsId should be a positive value") Long permissionsId);

    public Page<PermissionsEntity> FindPermissions(@Positive(message ="rolesId should be a positive value") Long rolesId,List<SearchFields> fields,String operator,Pageable pageable);
}

