package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class Update[=AuthenticationTable]permissionInput {

  @NotNull(message = "permissionId Should not be null")
    private Long permissionId;
  
    <#if (AuthenticationType=="database" && !UserInput??) || AuthenticationType=="oidc" >
    @NotNull(message = "user Id Should not be null")
    private Long [=AuthenticationTable?uncap_first]Id;
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
    @NotNull(message = "[=value.fieldName?uncap_first] Should not be null")
    private [=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
  
  	public Long getPermissionId() {
  	return permissionId;
  	}

  	public void setPermissionId(Long permissionId){
  	this.permissionId = permissionId;
  	}
  
  	<#if (AuthenticationType=="database" && !UserInput??) || AuthenticationType=="oidc" >
  	public Long get[=AuthenticationTable?cap_first]Id() {
  	 	return [=AuthenticationTable?uncap_first]Id;
  	}

  	public void set[=AuthenticationTable?cap_first]Id(Long [=AuthenticationTable?uncap_first]Id){
  	  	this.[=AuthenticationTable?uncap_first]Id = [=AuthenticationTable?uncap_first]Id;
  	}
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  	public [=value.fieldType] get[=AuthenticationTable][=value.fieldName?cap_first]() {
  	return [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	}

  	public void set[=AuthenticationTable][=value.fieldName?cap_first]([=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first]){
  	this.[=AuthenticationTable?uncap_first][=value.fieldName?cap_first] = [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	}
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
 
}
