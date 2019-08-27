package [=PackageName].application.Authorization.Userpermission.Dto;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class UpdateUserpermissionInput {

  @NotNull(message = "permissionId Should not be null")
  private Long permissionId;
  
  @NotNull(message = "userId Should not be null")
  private Long userId;

  public Long getPermissionId() {
  return permissionId;
  }

  public void setPermissionId(Long permissionId){
  this.permissionId = permissionId;
  }
  public Long getUserId() {
  return userId;
  }

  public void setUserId(Long userId){
  this.userId = userId;
  }
 
}
