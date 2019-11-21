package [=PackageName].domain.model;

import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name = "[=AuthenticationTable]role", schema = "[=SchemaName]")
@IdClass(UserroleId.class)
public class [=AuthenticationTable]roleEntity implements Serializable {

  private Long roleId;
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
 
  public [=AuthenticationTable]roleEntity() {
  }
  
  public UserroleEntity(Long userId, Long roleId) {
	  this.roleId = roleId;
	  this.userId = userId;
  }

  @ManyToOne
  @JoinColumn(name = "roleId", insertable=false, updatable=false)
  public RoleEntity getRole() {
    return role;
  }
  public void setRole(RoleEntity role) {
    this.role = role;
  }
  
  private RoleEntity role;
 
  @Id
  @Column(name = "roleId", nullable = false)
  public Long getRoleId() {
  return roleId;
  }

  public void setRoleId(Long roleId){
  this.roleId = roleId;
  }
  
  <#if (AuthenticationType!="none" && !UserInput??)>
  @Id
  @Column(name = "userId", nullable = false)
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
  @Id
  @Column(name = "[=AuthenticationTable?uncap_first][=key?cap_first]", nullable = false)
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
  
  @ManyToOne
  <#if (AuthenticationType!="none" && !UserInput??)>
  @JoinColumn(name = "[=AuthenticationTable?uncap_first]Id", insertable=false, updatable=false)
  <#elseif AuthenticationType!="none" && UserInput??>
  <#if PrimaryKeys??>
  <#assign i=PrimaryKeys?size>
  <#if i==1>
  <#list PrimaryKeys as key,value>
  @JoinColumn(name = "[=AuthenticationTable?uncap_first][=key?cap_first]", insertable=false, updatable=false)
  <#break>
  </#list>
  <#else>
  @JoinColumns({<#list PrimaryKeys as key,value><#if key_has_next>@JoinColumn(name="[=AuthenticationTable?uncap_first][=key?cap_first]"<#if value?lower_case !="string">,columnDefinition="[=value?cap_first]"</#if>, referencedColumnName="[=key?uncap_first]", nullable=false, insertable=false, updatable=false),<#else>@JoinColumn(name="[=AuthenticationTable?uncap_first][=key?cap_first]"<#if value?lower_case !="string">, columnDefinition="[=value?cap_first]"</#if>, referencedColumnName="[=key?uncap_first]", nullable=false,insertable=false, updatable=false)</#if></#list>})
  </#if>
  </#if>
  </#if> 
  public [=AuthenticationTable]Entity get[=AuthenticationTable]() {
    return [=AuthenticationTable?uncap_first];
  }
  public void set[=AuthenticationTable]([=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]) {
    this.[=AuthenticationTable?uncap_first] = [=AuthenticationTable?uncap_first];
  }
  
  private [=AuthenticationTable]Entity [=AuthenticationTable?uncap_first];
  
}

  
      


