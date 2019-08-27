package [=PackageName].application.Authorization.Userpermission;

import java.util.List;

import javax.validation.constraints.Positive;
import org.testing.demoTemp.domain.model.UserpermissionId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Authorization.Userpermission.Dto.*;

@Service
public interface IUserpermissionAppService {

	CreateUserpermissionOutput Create(CreateUserpermissionInput userpermission);

    void Delete(UserpermissionId userpermissionId );

    UpdateUserpermissionOutput Update(UserpermissionId userpermissionId , UpdateUserpermissionInput input);

    FindUserpermissionByIdOutput FindById(UserpermissionId userpermissionId );

    List<FindUserpermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;
	
	public UserpermissionId parseUserpermissionKey(String keysString);
    //User
    GetUserOutput GetUser(UserpermissionId userpermissionId );
    //Permission
    GetPermissionOutput GetPermission(UserpermissionId userpermissionId );
}
