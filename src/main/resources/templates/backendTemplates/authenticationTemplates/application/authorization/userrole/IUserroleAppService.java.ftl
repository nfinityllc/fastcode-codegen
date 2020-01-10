package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role;

import java.util.List;
import javax.validation.constraints.Positive;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.*;

@Service
public interface I[=AuthenticationTable]roleAppService {

	Create[=AuthenticationTable]roleOutput Create(Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role);

    void Delete([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);

    Update[=AuthenticationTable]roleOutput Update([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId, Update[=AuthenticationTable]roleInput input);

    Find[=AuthenticationTable]roleByIdOutput FindById([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);

    List<Find[=AuthenticationTable]roleByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	public [=AuthenticationTable]roleId parse[=AuthenticationTable]roleKey(String keysString);
    
    //[=AuthenticationTable]
    Get[=AuthenticationTable]Output Get[=AuthenticationTable]([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);
    
    //Role
    GetRoleOutput GetRole([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId);
}
