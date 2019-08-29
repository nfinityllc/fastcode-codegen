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
  private Long userid;
 
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
  
  @ManyToOne
  @JoinColumn(name = "[=AuthenticationTable?uncap_first]id", insertable=false, updatable=false)
  public [=AuthenticationTable]Entity get[=AuthenticationTable]() {
    return [=AuthenticationTable?uncap_first];
  }
  public void set[=AuthenticationTable]([=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]) {
    this.[=AuthenticationTable?uncap_first] = [=AuthenticationTable?uncap_first];
  }
  
  private [=AuthenticationTable]Entity [=AuthenticationTable?uncap_first];
 
  @Id
  @Column(name = "userid", nullable = false)
  public Long getUserid() {
  return userid;
  }

  public void setUserid(Long userid){
  this.userid = userid;
  }
  
//  @Override
//  public boolean equals(Object o) {
//    if (this == o) return true;
//      if (!(o instanceof UserpermissionEntity)) return false;
//        UserpermissionEntity userpermission = (UserpermissionEntity) o;
//        return id != null && id.equals(userpermission.id);
//  }

}

  
      


