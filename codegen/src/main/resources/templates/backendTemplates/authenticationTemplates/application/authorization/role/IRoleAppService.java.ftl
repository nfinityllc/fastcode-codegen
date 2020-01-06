package [=PackageName].application.authorization.role;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application.authorization.role.dto.*;
import java.util.List;

@Service
public interface IRoleAppService {
    // CRUD Operations

    CreateRoleOutput Create(CreateRoleInput input);

    void Delete(Long rid);

    UpdateRoleOutput Update(Long roleId, UpdateRoleInput input);

    FindRoleByIdOutput FindById(Long rid);

    List<FindRoleByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

}
