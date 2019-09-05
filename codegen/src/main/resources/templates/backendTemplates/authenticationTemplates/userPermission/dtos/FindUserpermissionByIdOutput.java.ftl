package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

public class Find[=AuthenticationTable]permissionByIdOutput {

    private Long permissionId;
  	<#if AuthenticationType=="database" && !UserInput??>
    private Long userid;
    private String username;
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
    private [=value.fieldType] [=value.fieldName?uncap_first];
  	</#if> 
  	</#list>
  	</#if>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "User Name">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	private [=authValue.fieldType] [=authValue.fieldName?uncap_first];
    </#if>
    </#if>
    </#list>
  	</#if>
    </#if>
  	private String permissionName;
  
  	public String getPermissionName() {
   		return permissionName;
  	}

  	public void setPermissionName(String permissionName){
   		this.permissionName = permissionName;
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
  	
  	public String getUsername() {
   		return username;
  	}

  	public void setUsername(String username){
   		this.username = username;
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
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "User Name">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	public [=authValue.fieldType] get[=authValue.fieldName?cap_first]() {
   		return [=authValue.fieldName?uncap_first];
  	}

  	public void set[=authValue.fieldName?cap_first]([=authValue.fieldType] [=authValue.fieldName?uncap_first]){
   		this.[=authValue.fieldName?uncap_first] = [=authValue.fieldName?uncap_first];
  	}
  	</#if>
    </#if>
    </#list>
    </#if>
  	</#if>
}
