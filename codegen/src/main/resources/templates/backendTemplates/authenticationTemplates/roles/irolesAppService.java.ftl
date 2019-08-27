package [=PackageName].application.Authorization.Role;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Authorization.Role.Dto.*;

import javax.validation.constraints.Positive;
import java.util.List;

@Service
public interface IRoleAppService {
    // CRUD Operations

    CreateRoleOutput Create(CreateRoleInput input);

    void Delete(@Positive(message ="RoleId should be a positive value") Long rid);

    UpdateRoleOutput Update(@Positive(message ="RoleId should be a positive value") Long roleId, UpdateRoleInput input);

    FindRoleByIdOutput FindById(@Positive(message ="RoleId should be a positive value") Long rid);

    List<FindRoleByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

}
