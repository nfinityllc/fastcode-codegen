package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

public class Update[=AuthenticationTable]permissionOutput {

  private Long permissionId;
  	<#if AuthenticationType=="database" && !UserInput??>
    private Long userId;
    private String userName;
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
    private [=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	</#if> 
  	</#list>
  	</#if>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "User Name">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	private [=authValue.fieldType] [=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first];
    </#if>
    </#if>
    </#list>
    </#if>
  	</#if>
   <#if DescriptiveField??>
    <#if DescriptiveField[AuthenticationTable]??>
    <#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
    private [=DescriptiveField[AuthenticationTable].fieldType?cap_first] [=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first];
    </#if>
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
  	public Long getUserId() {
  	return userId;
  	}

  	public void setUserId(Long userId){
  	this.userId = userId;
  	}
  	
  	public String getUserName() {
   		return userName;
  	}

  	public void setUserName(String userName){
   		this.userName = userName;
  	}
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  	 public [=value.fieldType] get[=AuthenticationTable?cap_first][=value.fieldName?cap_first]() {
  	 	return [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	 }

  	 public void set[=AuthenticationTable?cap_first][=value.fieldName?cap_first]([=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first]){
  	 	this.[=AuthenticationTable?uncap_first][=value.fieldName?cap_first] = [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	 }
  	</#if> 
  	</#list>
  	</#if>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "User Name">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	 public [=authValue.fieldType] get[=AuthenticationTable?cap_first][=authValue.fieldName?cap_first]() {
   	  	return [=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first];
  	 }

  	 public void set[=AuthenticationTable?cap_first][=authValue.fieldName?cap_first]([=authValue.fieldType] [=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]){
   	   	this.[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first] = [=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first];
  	 }
  	</#if>
    </#if>
    </#list>
    </#if>
  	</#if>
  <#if DescriptiveField??>
   <#if DescriptiveField[AuthenticationTable]??>
   <#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
    public [=DescriptiveField[AuthenticationTable].fieldType?cap_first] get[=AuthenticationTable][=DescriptiveField[AuthenticationTable].fieldName?cap_first]() {
     	return [=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first];
    }

    public void set[=AuthenticationTable][=DescriptiveField[AuthenticationTable].fieldName?cap_first]([=DescriptiveField[AuthenticationTable].fieldType?cap_first] [=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first]){
    	this.[=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first] = [=AuthenticationTable?uncap_first][=DescriptiveField[AuthenticationTable].fieldName?cap_first];
    }
  </#if>
   </#if>
   </#if>
}