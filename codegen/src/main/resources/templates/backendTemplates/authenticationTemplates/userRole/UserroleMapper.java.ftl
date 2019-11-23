package [=PackageName].application.Authorization.[=AuthenticationTable]role;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].application.Authorization.[=AuthenticationTable]role.Dto.*;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;

@Mapper(componentModel = "spring")
public interface [=AuthenticationTable]roleMapper {

   [=AuthenticationTable]roleEntity Create[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]roleDto);
   
   @Mappings({ 
   <#if (AuthenticationType!="none" && !UserInput??)>
   @Mapping(source = "[=AuthenticationTable?uncap_first].userName", target = "[=AuthenticationTable?uncap_first]DescriptiveField"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].id", target = "[=AuthenticationTable?uncap_first]Id"),  
   <#elseif AuthenticationType!="none" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=key?uncap_first]", target = "[=AuthenticationTable?uncap_first][=key?cap_first]"),  
   </#if> 
   </#list>
   </#if>
   </#if> 
   <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=DescriptiveField[AuthenticationTable].fieldName?uncap_first]", target = "[=DescriptiveField[AuthenticationTable].description?uncap_first]"),  
   <#else>
   <#if AuthenticationFields??>
   <#list AuthenticationFields as authKey,authValue>
   <#if authKey== "UserName">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=authValue.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first]DescriptiveField"),
   </#if>
   </#list>
   </#if>
   </#if>          
   @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
   @Mapping(source = "role.id", target = "roleId")                   
   }) 
   Create[=AuthenticationTable]roleOutput [=AuthenticationTable]roleEntityToCreate[=AuthenticationTable]roleOutput([=AuthenticationTable]roleEntity entity);

   [=AuthenticationTable]roleEntity Update[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]roleDto);

   @Mappings({ 
   <#if (AuthenticationType!="none" && !UserInput??)>
   @Mapping(source = "[=AuthenticationTable?uncap_first].userName", target = "[=AuthenticationTable?uncap_first]DescriptiveField"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].id", target = "[=AuthenticationTable?uncap_first]Id"),  
   <#elseif AuthenticationType!="none" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=key?uncap_first]", target = "[=AuthenticationTable?uncap_first][=key?cap_first]"),  
   </#if> 
   </#list>
   </#if>
   </#if> 
   <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=DescriptiveField[AuthenticationTable].fieldName?uncap_first]", target = "[=DescriptiveField[AuthenticationTable].description?uncap_first]"),  
   <#else>
   <#if AuthenticationFields??>
   <#list AuthenticationFields as authKey,authValue>
   <#if authKey== "UserName">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=authValue.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first]DescriptiveField"),
   </#if>
   </#list>
   </#if>
   </#if>             
   @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
   @Mapping(source = "role.id", target = "roleId")                  
   }) 
   Update[=AuthenticationTable]roleOutput [=AuthenticationTable]roleEntityToUpdate[=AuthenticationTable]roleOutput([=AuthenticationTable]roleEntity entity);

   @Mappings({ 
   <#if (AuthenticationType!="none" && !UserInput??)>
   @Mapping(source = "[=AuthenticationTable?uncap_first].userName", target = "[=AuthenticationTable?uncap_first]DescriptiveField"),                   
   @Mapping(source = "[=AuthenticationTable?uncap_first].id", target = "[=AuthenticationTable?uncap_first]Id"),  
   <#elseif AuthenticationType!="none" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=key?uncap_first]", target = "[=AuthenticationTable?uncap_first][=key?cap_first]"),  
   </#if> 
   </#list>
   </#if>
   </#if> 
   <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=DescriptiveField[AuthenticationTable].fieldName?uncap_first]", target = "[=DescriptiveField[AuthenticationTable].description?uncap_first]"),  
   <#else>
   <#if AuthenticationFields??>
   <#list AuthenticationFields as authKey,authValue>
   <#if authKey== "UserName">
   @Mapping(source = "[=AuthenticationTable?uncap_first].[=authValue.fieldName?uncap_first]", target = "[=AuthenticationTable?uncap_first]DescriptiveField"),
   </#if>
   </#list>
   </#if>
   </#if>              
   @Mapping(source = "role.name", target = "roleDescriptiveField"),                   
   @Mapping(source = "role.id", target = "roleId")                  
   })
   Find[=AuthenticationTable]roleByIdOutput [=AuthenticationTable]roleEntityToFind[=AuthenticationTable]roleByIdOutput([=AuthenticationTable]roleEntity entity);

   @Mappings({
   @Mapping(source = "[=AuthenticationTable?uncap_first]role.roleId", target = "[=AuthenticationTable?uncap_first]roleRoleId"),
   <#if (AuthenticationType!="none" && !UserInput??)>
   @Mapping(source = "[=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first]Id", target = "[=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first]Id")
   <#elseif AuthenticationType!="none" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first][=key?cap_first]", target = "[=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first]"),
   </#if> 
   </#list>
   </#if>
   </#if>
   })
   Get[=AuthenticationTable]Output [=AuthenticationTable]EntityToGet[=AuthenticationTable]Output([=AuthenticationTable]Entity [=AuthenticationTable?uncap_first], [=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role);
 
   @Mappings({
   <#if (AuthenticationType!="none" && !UserInput??)>
   @Mapping(source = "[=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first]Id", target = "[=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first]Id"),
   <#elseif AuthenticationType!="none" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   @Mapping(source = "[=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first][=key?cap_first]", target = "[=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first]"),
   </#if> 
   </#list>
   </#if>
   </#if>
   @Mapping(source = "[=AuthenticationTable?uncap_first]role.roleId", target = "[=AuthenticationTable?uncap_first]roleRoleId"),
   @Mapping(source = "role.id", target = "id")
   })
   GetRoleOutput RoleEntityToGetRoleOutput(RoleEntity role, [=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role);
 
}
