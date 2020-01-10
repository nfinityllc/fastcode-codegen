package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class Create[=AuthenticationTable]roleInput {

  @NotNull(message = "roleId Should not be null")
  private Long roleId;
  
  <#if (AuthenticationType!="none" && !UserInput??)>
  @NotNull(message = "user Id Should not be null")
  private Long [=AuthenticationTable?uncap_first]Id;
  <#elseif AuthenticationType!="none" && UserInput??>
  <#if PrimaryKeys??>
  <#list PrimaryKeys as key,value>
  <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  @NotNull(message = "[=key?uncap_first] Should not be null")
  private [=value] [=AuthenticationTable?uncap_first][=key?cap_first];
  </#if> 
  </#list>
  </#if>
  </#if>

  public Long getRoleId() {
  	return roleId;
  }

  public void setRoleId(Long roleId){
  	this.roleId = roleId;
  }
  
  <#if (AuthenticationType!="none" && !UserInput??)>
  public Long get[=AuthenticationTable?cap_first]Id() {
  	return [=AuthenticationTable?uncap_first]Id;
  }

  public void set[=AuthenticationTable?cap_first]Id(Long [=AuthenticationTable?uncap_first]Id){
  	this.[=AuthenticationTable?uncap_first]Id = [=AuthenticationTable?uncap_first]Id;
  }
  <#elseif AuthenticationType!="none" && UserInput??>
  <#if PrimaryKeys??>
  <#list PrimaryKeys as key,value>
  <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  public [=value] get[=AuthenticationTable][=key?cap_first]() {
  	return [=AuthenticationTable?uncap_first][=key?cap_first];
  }

  public void set[=AuthenticationTable][=key?cap_first]([=value] [=AuthenticationTable?uncap_first][=key?cap_first]){
  	this.[=AuthenticationTable?uncap_first][=key?cap_first] = [=AuthenticationTable?uncap_first][=key?cap_first];
  }
  </#if> 
  </#list>
  </#if>
  </#if>
  	
}
