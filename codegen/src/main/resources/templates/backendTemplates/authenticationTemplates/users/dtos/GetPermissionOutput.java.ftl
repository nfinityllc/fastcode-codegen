package [=PackageName].application.Authorization.User.Dto;

public class GetPermissionOutput {

    private Long id;
    private String displayName;
    private String name;
    <#if Audit!false>
    private String creatorUserId;
    private java.util.Date creationTime;
    private String lastModifierUserId;
    private java.util.Date lastModificationTime;
    </#if>
    <#if AuthenticationType!="none" && !UserInput??>
    private Long userId;
    private String userDescriptiveField;
  	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
    private [=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  	</#if> 
  	</#list>
  	</#if>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "UserName">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	private [=authValue.fieldType] [=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first];
    </#if>
    </#if>
    </#list>
  	</#if>
    </#if>

    <#if AuthenticationType!="none" && !UserInput??>
  	public Long getUserId() {
  	return userid;
  	}

  	public void setUserId(Long userId){
  	this.userId = userId;
  	}
  	
  	public String getUserDescriptiveField() {
   		return userDescriptiveField;
  	}

  	public void setUsername(String userDescriptiveField){
   		this.userDescriptiveField = userDescriptiveField;
  	}
  	<#elseif AuthenticationType!="none" && UserInput??>
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
  	<#if authKey== "UserName">
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

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    <#if Audit!false>
    public java.util.Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(java.util.Date creationTime) {
      	this.creationTime = creationTime;
    }

    public String getLastModifierUserId() {
      	return lastModifierUserId;
    }

    public void setLastModifierUserId(String lastModifierUserId) {
      	this.lastModifierUserId = lastModifierUserId;
    }

    public java.util.Date getLastModificationTime() {
      	return lastModificationTime;
    }

    public void setLastModificationTime(java.util.Date lastModificationTime) {
      	this.lastModificationTime = lastModificationTime;
    }

    public String getCreatorUserId() {
      	return creatorUserId;
    }

    public void setCreatorUserId(String creatorUserId) {
      	this.creatorUserId = creatorUserId;
    }
</#if>
}
