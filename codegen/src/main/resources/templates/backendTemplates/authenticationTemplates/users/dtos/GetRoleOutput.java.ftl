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
    <#if AuthenticationType=="database" && !UserInput??>
    private Long userid;
    private String username;
  	<#elseif AuthenticationType=="database" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
   	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
    private [=value] [=key?uncap_first];
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
  	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
    public [=value] get[=key?cap_first]() {
  	return [=key?uncap_first];
  	}

  	public void set[=key?cap_first]([=value] [=key?uncap_first]){
  	this.[=key?uncap_first] = [=key?uncap_first];
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

