package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class Update[=AuthenticationTable]permissionInput {

  @NotNull(message = "permission Id Should not be null")
  private Long permissionId;
  
  @NotNull(message = "user Id Should not be null")
  private Long userid;

  public Long getPermissionId() {
  return permissionId;
  }

  public void setPermissionId(Long permissionId){
  this.permissionId = permissionId;
  }
  public Long getUserid() {
  return userid;
  }

  public void setUserid(Long userid){
  this.userid = userid;
  }
 
}
