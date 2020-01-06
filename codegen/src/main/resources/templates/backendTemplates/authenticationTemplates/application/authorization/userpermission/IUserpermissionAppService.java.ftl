package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission;

import java.util.List;

import javax.validation.constraints.Positive;
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.*;

@Service
public interface I[=AuthenticationTable]permissionAppService {

	Create[=AuthenticationTable]permissionOutput Create(Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission);
    
    void Delete([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );

    Update[=AuthenticationTable]permissionOutput Update([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId , Update[=AuthenticationTable]permissionInput input);

    Find[=AuthenticationTable]permissionByIdOutput FindById([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );

    List<Find[=AuthenticationTable]permissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;
	
	public [=AuthenticationTable]permissionId parse[=AuthenticationTable]permissionKey(String keysString);
    //[=AuthenticationTable?uncap_first]
    Get[=AuthenticationTable]Output Get[=AuthenticationTable]([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );
    //Permission
    GetPermissionOutput GetPermission([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId );
}
