package [=PackageName].domain.model;

import java.io.Serializable;

public class [=AuthenticationTable]permissionId implements Serializable {

    private Long permissionId;
    <#if (AuthenticationType!="none" && !UserInput??)>
    private Long userId;
  	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
    private [=value] [=AuthenticationTable?uncap_first][=key?cap_first];
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
    
    public [=AuthenticationTable]permissionId() {

    }

    public [=AuthenticationTable]permissionId(Long permissionId,<#if (AuthenticationType!="none" && !UserInput??)>Long userId<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if key_has_next>[=value] [=AuthenticationTable?uncap_first][=key?cap_first],<#else>[=value] [=AuthenticationTable?uncap_first][=key?cap_first]</#if></#list></#if>){
  		this.permissionId =permissionId;
  		<#if (AuthenticationType!="none" && !UserInput??)>
   		this.userId =userId;
  	    <#elseif AuthenticationType!="none" && UserInput??>
        <#list PrimaryKeys as key,value>
        this.[=AuthenticationTable?uncap_first][=key?cap_first]=[=AuthenticationTable?uncap_first][=key?cap_first];
        </#list>
        </#if>
    }
    
    public Long getPermissionId() {
        return permissionId;
    }
    public void setPermissionId(Long permissionId){
        this.permissionId = permissionId;
    }
    <#if (AuthenticationType!="none" && !UserInput??)>
  	public Long getUserId() {
  		return userId;
  	}

  	public void setUserId(Long userId){
  		this.userId = userId;
  	}
  	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  	public [=value] get[=AuthenticationTable?cap_first][=key?cap_first]() {
  		return [=AuthenticationTable?uncap_first][=key?cap_first];
  	}

  	public void set[=AuthenticationTable?cap_first][=key?cap_first]([=value] [=AuthenticationTable?uncap_first][=key?cap_first]){
  		this.[=AuthenticationTable?uncap_first][=key?cap_first] = [=AuthenticationTable?uncap_first][=key?cap_first];
  	}
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
    
}