package [=PackageName].application.Authorization.Userpermission.Dto;

public class CreateUserpermissionOutput {

  private Long permissionId;
  private Long userId;
  private String userUserName;
  private String permissionName;
  
  public String getUserUserName() {
   return userUserName;
  }

  public void setUserUserName(String userUserName){
   this.userUserName = userUserName;
  }
  
  public String getPermissionName() {
   return permissionName;
  }

  public void setPermissionName(String permissionName){
   this.permissionName = permissionName;
  }
  
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
