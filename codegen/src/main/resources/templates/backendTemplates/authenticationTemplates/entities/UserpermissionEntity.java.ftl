package [=PackageName].domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;

@Entity
@Table(name = "[=AuthenticationTable]permission", schema = "[=SchemaName]")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>
@IdClass([=AuthenticationTable]permissionId.class)
public class [=AuthenticationTable]permissionEntity<#if Audit!false> extends AuditedEntity<String></#if> implements Serializable {

  private Long permissionId;
  <#if AuthenticationType=="database" && !UserInput??>
  private Long userId;
  <#elseif AuthenticationType=="database" && UserInput??>
  <#if PrimaryKeys??>
  <#list PrimaryKeys as key,value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  private [=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  </#if> 
  </#list>
  </#if>
  </#if>
  public [=AuthenticationTable]permissionEntity() {
	}

  @ManyToOne
  @JoinColumn(name = "permissionId", insertable=false, updatable=false)
  public PermissionEntity getPermission() {
    return permission;
  }
  public void setPermission(PermissionEntity permission) {
    this.permission = permission;
  }
  
  private PermissionEntity permission;
 
  @Id
  @Column(name = "permissionId", nullable = false)
  public Long getPermissionId() {
  return permissionId;
  }

  public void setPermissionId(Long permissionId){
  this.permissionId = permissionId;
  }
  
  <#if AuthenticationType=="database" && !UserInput??>
  @Id
  @Column(name = "userId", nullable = false)
  public Long getUserId() {
  return userId;
  }

  public void setUserId(Long userId){
  this.userId = userId;
  }
  <#elseif AuthenticationType=="database" && UserInput??>
  <#if PrimaryKeys??>
  <#list PrimaryKeys as key,value>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  @Id
  @Column(name = "[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]", nullable = false)
  public [=value.fieldType] get[=AuthenticationTable][=value.fieldName?cap_first]() {
  return [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  }

  public void set[=AuthenticationTable][=value.fieldName?cap_first]([=value.fieldType] [=AuthenticationTable?uncap_first][=value.fieldName?cap_first]){
  this.[=AuthenticationTable?uncap_first][=value.fieldName?cap_first] = [=AuthenticationTable?uncap_first][=value.fieldName?cap_first];
  }
  </#if> 
  </#list>
  </#if>
  </#if>
  
  @ManyToOne
  <#if AuthenticationType=="database" && !UserInput??>
  @JoinColumn(name = "[=AuthenticationTable?uncap_first]Id", insertable=false, updatable=false)
  <#elseif AuthenticationType=="database" && UserInput??>
  <#if PrimaryKeys??>
  <#assign i=PrimaryKeys?size>
  <#if i==1>
  <#list PrimaryKeys as key,value>
  @JoinColumn(name = "[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]", insertable=false, updatable=false)
  <#break>
  </#list>
  <#else>
  @JoinColumns({<#list PrimaryKeys as key,value><#if key_has_next>@JoinColumn(name="[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]"<#if value.fieldType?lower_case !="string">,columnDefinition="[=value.fieldType?cap_first]"</#if>, referencedColumnName="[=value.fieldName?uncap_first]", nullable=false, insertable=false, updatable=false),<#else>@JoinColumn(name="[=AuthenticationTable?uncap_first][=value.fieldName?cap_first]"<#if value.fieldType?lower_case !="string">, columnDefinition="[=value.fieldType?cap_first]"</#if>, referencedColumnName="[=value.fieldName?uncap_first]", nullable=false,insertable=false, updatable=false)</#if></#list>})
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
 
  
//  @Override
//  public boolean equals(Object o) {
//    if (this == o) return true;
//      if (!(o instanceof UserpermissionEntity)) return false;
//        UserpermissionEntity userpermission = (UserpermissionEntity) o;
//        return id != null && id.equals(userpermission.id);
//  }

}

  
      


