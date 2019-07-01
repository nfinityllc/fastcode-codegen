package [=PackageName].domain.IRepository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].domain.model.PermissionsEntity;

public interface UsersCustomRepository {

 Page<PermissionsEntity> getAllPermissions(Long usersId,List<SearchFields> search,String operator,Pageable pageable);
	
}
