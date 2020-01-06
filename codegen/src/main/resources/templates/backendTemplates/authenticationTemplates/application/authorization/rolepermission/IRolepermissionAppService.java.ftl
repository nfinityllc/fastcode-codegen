package [=PackageName].application.authorization.rolepermission;

import java.util.List;

import [=PackageName].domain.model.RolepermissionId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application.authorization.rolepermission.dto.*;

@Service
public interface IRolepermissionAppService {

	CreateRolepermissionOutput Create(CreateRolepermissionInput rolepermission);

    void Delete(RolepermissionId rolepermissionId );

    UpdateRolepermissionOutput Update(RolepermissionId rolepermissionId , UpdateRolepermissionInput input);

    FindRolepermissionByIdOutput FindById(RolepermissionId rolepermissionId );

    List<FindRolepermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;
	
	public RolepermissionId parseRolepermissionKey(String keysString);
    //Permission
    GetPermissionOutput GetPermission(RolepermissionId rolepermissionId );
    //Role
    GetRoleOutput GetRole(RolepermissionId rolepermissionId );
}
