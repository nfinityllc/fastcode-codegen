package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

import java.util.Date;

public class Get[=AuthenticationTable]Output {
 
   <#list Fields as key,value>
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   	private [=value] [=key];
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
   <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
    private [=value] [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first];
  	public [=value] get[=AuthenticationTable]permission[=AuthenticationTable?cap_first][=key?cap_first]() {
		return [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first];
    }

	public void set[=AuthenticationTable]permission[=AuthenticationTable?cap_first][=key?cap_first]([=value] [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first]){
   		this.[=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first] = [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first];
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
  <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  
  	public [=value?cap_first] get[=key?cap_first]() {
  		return [=key];
  	}

  	public void set[=key?cap_first]([=value?cap_first] [=key]){
  		this.[=key] = [=key];
  	}
  </#if>
</#list>

}
