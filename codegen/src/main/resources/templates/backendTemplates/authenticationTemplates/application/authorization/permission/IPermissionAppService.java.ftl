package [=PackageName].application.authorization.permission;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application.authorization.permission.dto.*;

import java.util.List;

@Service
public interface IPermissionAppService {
    // CRUD Operations
    CreatePermissionOutput Create(CreatePermissionInput input);

    void Delete(Long pid);

    UpdatePermissionOutput Update(Long permissionId, UpdatePermissionInput input);

    FindPermissionByIdOutput FindById(Long pid);

    List<FindPermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

}
