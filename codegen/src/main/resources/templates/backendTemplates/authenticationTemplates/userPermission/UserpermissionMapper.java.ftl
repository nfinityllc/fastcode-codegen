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
   <#if AuthenticationType=="database" && !UserInput??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].userName", target = "[=AuthenticationTable?uncap_first]UserName"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].userId", target = "userId"),  
   <#elseif AuthenticationType=="database" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=value.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]"),  
   </#if> 
   </#list>
   </#if>
   <#if AuthenticationFields??>
   <#list AuthenticationFields as authKey,authValue>
   <#if authKey== "User Name">
   <#if !PrimaryKeys[authValue.fieldName]??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=authValue.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]"),  
   </#if>
   </#if>
   </#list>
   </#if>
   </#if> 
   <#if DescriptiveField??>
   <#if DescriptiveField[AuthenticationTable]??>
   <#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=DescriptiveField[AuthenticationTable].fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first]"),  
   </#if>
   </#if>
 	</#if>               
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId")                   
   }) 
   Create[=AuthenticationTable]permissionOutput [=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput([=AuthenticationTable]permissionEntity entity);

   [=AuthenticationTable]permissionEntity Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permissionDto);

   @Mappings({ 
   <#if AuthenticationType=="database" && !UserInput??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].userName", target = "[=AuthenticationTable?uncap_first]UserName"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].userId", target = "userId"),  
   <#elseif AuthenticationType=="database" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=value.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]"),  
   </#if> 
   </#list>
   </#if>
   <#if AuthenticationFields??>
   <#list AuthenticationFields as authKey,authValue>
   <#if authKey== "User Name">
   <#if !PrimaryKeys[authValue.fieldName]??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=authValue.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]"),  
   </#if>
   </#if>
   </#list>
   </#if>
   </#if>  
   <#if DescriptiveField??>
   <#if DescriptiveField[AuthenticationTable]??>
   <#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=DescriptiveField[AuthenticationTable].fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first]"),  
 	</#if>     
	</#if>
   </#if>                  
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId")                  
   }) 
   Update[=AuthenticationTable]permissionOutput [=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput([=AuthenticationTable]permissionEntity entity);

   @Mappings({ 
   <#if AuthenticationType=="database" && !UserInput??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].userName", target = "[=AuthenticationTable?uncap_first]UserName"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].userId", target = "userId"),  
   <#elseif AuthenticationType=="database" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=value.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]"),  
   </#if> 
   </#list>
   </#if>
   <#if AuthenticationFields??>
   <#list AuthenticationFields as authKey,authValue>
   <#if authKey== "User Name">
   <#if !PrimaryKeys[authValue.fieldName]??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=authValue.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]"),  
   </#if>
   </#if>
   </#list>
   </#if>
   </#if>  
   <#if DescriptiveField??>
   <#if DescriptiveField[AuthenticationTable]??>
   <#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=DescriptiveField[AuthenticationTable].fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first]"),  
    </#if>     
	</#if>
   </#if>                
   @Mapping(source = "permission.name", target = "permissionName"),                   
   @Mapping(source = "permission.id", target = "permissionId")                  
   }) 
   Find[=AuthenticationTable]permissionByIdOutput [=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable]permissionEntity entity);


   @Mappings({
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.permissionId", target = "[=AuthenticationTable?uncap_first]permissionPermissionId"),
   <#if AuthenticationType=="database" && !UserInput??>
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.userId", target = "[=AuthenticationTable?uncap_first]permissionUserId")
   <#elseif AuthenticationType=="database" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.[=value.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first]"),
   </#if> 
   </#list>
   </#if>
   </#if>
   })
   Get[=AuthenticationTable]Output [=AuthenticationTable]EntityToGet[=AuthenticationTable]Output([=AuthenticationTable]Entity [=AuthenticationTable?uncap_first], [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);
 

   @Mappings({
   <#if AuthenticationType=="database" && !UserInput??>
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.userId", target = "[=AuthenticationTable?uncap_first]permissionUserId"),
   <#elseif AuthenticationType=="database" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.[=value.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first]"),
   </#if> 
   </#list>
   </#if>
   </#if>
   @Mapping(source = "[=AuthenticationTable?uncap_first]permission.permissionId", target = "[=AuthenticationTable?uncap_first]permissionPermissionId"),
   @Mapping(source = "permission.id", target = "id")
   })
   GetPermissionOutput PermissionEntityToGetPermissionOutput(PermissionEntity permission, [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission);
 

}
