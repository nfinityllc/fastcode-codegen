package [=PackageName].application.authorization.user;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].search.SearchCriteria;
import [=PackageName].application.authorization.user.dto.*;

import java.util.List;

@Service
public interface IUserAppService {

	CreateUserOutput Create(CreateUserInput user);

    void Delete(Long id);

    UpdateUserOutput Update(Long userId, UpdateUserInput input);

    FindUserByIdOutput FindById(Long id);

    List<FindUserByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

}
