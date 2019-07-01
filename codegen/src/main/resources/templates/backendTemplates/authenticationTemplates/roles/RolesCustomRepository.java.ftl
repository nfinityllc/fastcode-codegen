package [=PackageName].domain.IRepository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import [=CommonModulePackage].Search.SearchFields;
import [=PackageName].domain.model.PermissionsEntity;

public interface RolesCustomRepository {

 Page<PermissionsEntity> getAllPermissions(Long rolesId,List<SearchFields> search,String operator,Pageable pageable);
	
}
