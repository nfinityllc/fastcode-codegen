package [=PackageName].domain.model;

import java.io.Serializable;

public class [=AuthenticationTable]permissionId implements Serializable {

    private Long permissionId;
    <#if AuthenticationType=="database" && !UserInput??>
    private Long userid;
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
    private [=value.fieldType] [=value.fieldName?uncap_first];
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
    
    public [=AuthenticationTable]permissionId() {

    }
   
    public [=AuthenticationTable]permissionId(Long permissionId,<#if AuthenticationType=="database" && !UserInput??>Long userid<#elseif AuthenticationType=="database" && UserInput??><#list PrimaryKeys as key,value><#if key_has_next>[=value.fieldType] [=value.fieldName?uncap_first],<#else>[=value.fieldType] [=value.fieldName?uncap_first]</#if></#list></#if>){
  		this.permissionId =permissionId;
  		<#if AuthenticationType=="database" && !UserInput??>
   		this.userid =userid;
  	    <#elseif AuthenticationType=="database" && UserInput??>
        <#list PrimaryKeys as key,value>
        this.[=value.fieldName?uncap_first]=[=value.fieldName?uncap_first];
        </#list>
        </#if>
    }
    
    public Long getPermissionId() {
        return permissionId;
    }
    public void setPermissionId(Long permissionId){
        this.permissionId = permissionId;
    }
    <#if AuthenticationType=="database" && !UserInput??>
  	public Long getUserid() {
  		return userid;
  	}

  	public void setUserid(Long userid){
  		this.userid = userid;
  	}
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  	public [=value.fieldType] get[=value.fieldName?cap_first]() {
  		return [=value.fieldName?uncap_first];
  	}

  	public void set[=value.fieldName?cap_first]([=value.fieldType] [=value.fieldName?uncap_first]){
  		this.[=value.fieldName?uncap_first] = [=value.fieldName?uncap_first];
  	}
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
    
}