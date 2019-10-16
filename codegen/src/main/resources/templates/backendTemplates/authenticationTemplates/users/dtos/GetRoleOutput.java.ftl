package [=PackageName].application.Authorization.[=AuthenticationTable].Dto;

import java.util.Date;

public class GetRoleOutput {
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
   	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
    private [=value] [=AuthenticationTable?uncap_first][=key?cap_first];
  	</#if> 
  	</#list>
  	</#if>
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "UserName">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	private [=authValue.fieldType] [=AuthenticationTable?uncap_first]DescriptiveField;
    </#if>
    </#if>
    </#list>
  	</#if>
    </#if>

    <#if AuthenticationType!="none" && !UserInput?? >
  	public Long getUserId() {
  	return userId;
  	}

  	public void setUserId(Long userId){
  	this.userId = userId;
  	}
  	
  	public String getUserDescriptiveField() {
   		return userDescriptiveField;
  	}

  	public void setUserDescriptiveField(String userDescriptiveField){
   		this.userDescriptiveField = userDescriptiveField;
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
    <#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "UserName">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	public [=authValue.fieldType] get[=AuthenticationTable?cap_first]DescriptiveField() {
   		return [=AuthenticationTable?uncap_first]DescriptiveField;
  	}

  	public void set[=AuthenticationTable?cap_first]DescriptiveField([=authValue.fieldType] [=AuthenticationTable?uncap_first]DescriptiveField){
   		this.[=AuthenticationTable?uncap_first]DescriptiveField = [=AuthenticationTable?uncap_first]DescriptiveField;
  	}
  	</#if>
    </#if>
    </#list>
    </#if>
  	</#if>

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

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

