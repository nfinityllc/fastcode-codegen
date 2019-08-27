package [=PackageName].domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;

@Entity
@Table(name = "Userpermission", schema = "sample")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>
@IdClass(UserpermissionId.class)
public class UserpermissionEntity<#if Audit!false> extends AuditedEntity<String></#if> implements Serializable {

  private Long permissionId;
  private Long userId;
 
  public UserpermissionEntity() {
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
  @JoinColumn(name = "userId", insertable=false, updatable=false)
  public UserEntity getUser() {
    return user;
  }
  public void setUser(UserEntity user) {
    this.user = user;
  }
  
  private UserEntity user;
 
  @Id
  @Column(name = "userId", nullable = false)
  public Long getUserId() {
  return userId;
  }

  public void setUserId(Long userId){
  this.userId = userId;
  }
  
//  @Override
//  public boolean equals(Object o) {
//    if (this == o) return true;
//      if (!(o instanceof UserpermissionEntity)) return false;
//        UserpermissionEntity userpermission = (UserpermissionEntity) o;
//        return id != null && id.equals(userpermission.id);
//  }

}

  
      


