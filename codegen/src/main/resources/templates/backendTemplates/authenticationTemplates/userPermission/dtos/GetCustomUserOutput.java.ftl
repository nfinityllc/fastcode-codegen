package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

import java.util.Date;

public class Get[=AuthenticationTable]Output {
 
   <#list Fields as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
   	private [=value.fieldType] [=value.fieldName];
   </#if> 
   </#list>

   	private Long [=AuthenticationTable]permissionPermissionId;
  
   <#if AuthenticationType!="none" && !UserInput??>
   	private Long [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id;
  
   	public Long get[=AuthenticationTable]permission[=AuthenticationTable]Id() {
   		return [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id;
   	}

   	public void set[=AuthenticationTable]permission[=AuthenticationTable]Id(Long [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id){
   		this.[=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id = [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id;
   	}
   <#elseif AuthenticationType!="none" && UserInput??>
   <#if PrimaryKeys??>
   <#list PrimaryKeys as key,value>
   <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
    private [=value.fieldType] [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first];
  	public [=value.fieldType] get[=AuthenticationTable]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first]() {
		return [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first];
    }

	public void set[=AuthenticationTable]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first]([=value.fieldType] [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first]){
   		this.[=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first] = [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=value.fieldName?cap_first];
   	}
   </#if> 
   </#list>
   </#if>
   </#if>
  
	public Long get[=AuthenticationTable]permissionPermissionId() {
   		return [=AuthenticationTable]permissionPermissionId;
    }

  	public void set[=AuthenticationTable]permissionPermissionId(Long [=AuthenticationTable]permissionPermissionId){
  		this.[=AuthenticationTable]permissionPermissionId = [=AuthenticationTable]permissionPermissionId;
  	}
  
  <#list Fields as key,value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  
  	public [=value.fieldType?cap_first] get[=value.fieldName?cap_first]() {
  		return [=value.fieldName];
  	}

  	public void set[=value.fieldName?cap_first]([=value.fieldType?cap_first] [=value.fieldName]){
  		this.[=value.fieldName] = [=value.fieldName];
  	}
  </#if>
</#list>

}
