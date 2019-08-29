package [=PackageName].application.Authorization.[=AuthenticationTable]permission;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto.*;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;


@Mapper(componentModel = "spring")
public interface [=AuthenticationTable]permissionMapper {

    [=AuthenticationTable]permissionEntity Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permissionDto);
   
   @Mappings({ 
   @Mapping(source = "[=AuthenticationTable?uncap_first].username", target = "[=AuthenticationTable?uncap_first]Username"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].userid", target = "userid"),                   
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId"),                   
   }) 
   Create[=AuthenticationTable]permissionOutput [=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput([=AuthenticationTable]permissionEntity entity);

    [=AuthenticationTable]permissionEntity Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permissionDto);

   @Mappings({ 
   @Mapping(source = "[=AuthenticationTable?uncap_first].username", target = "[=AuthenticationTable?uncap_first]Username"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].userid", target = "userid"),                   
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId"),                   
   }) 
   Update[=AuthenticationTable]permissionOutput [=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput([=AuthenticationTable]permissionEntity entity);

   @Mappings({ 
   @Mapping(source = "[=AuthenticationTable?uncap_first].username", target = "[=AuthenticationTable?uncap_first]Username"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].userid", target = "userid"),                   
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId"),                   
   }) 
   Find[=AuthenticationTable]permissionByIdOutput [=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable]permissionEntity entity);


   @Mappings({
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.permissionId", target = "[=AuthenticationTable?uncap_first]permissionPermissionId"),
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.userid", target = "[=AuthenticationTable?uncap_first]permissionUserid"),
   })
   Get[=AuthenticationTable]Output [=AuthenticationTable]EntityToGet[=AuthenticationTable]Output([=AuthenticationTable]Entity [=AuthenticationTable?uncap_first], [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);
 

   @Mappings({
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.permissionId", target = "[=AuthenticationTable?uncap_first]permissionPermissionId"),
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.userid", target = "[=AuthenticationTable?uncap_first]permissionUserid"),
   })
   GetPermissionOutput PermissionEntityToGetPermissionOutput(PermissionEntity permission, [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);
 

}
