package [=PackageName].application.Authorization.Rolepermission.Dto;

public class CreateRolepermissionOutput {

  private Long permissionId;
  private Long roleId;
  private String permissionName;
  private String roleDisplayName;
  
  public String getPermissionName() {
   return permissionName;
  }

  public void setPermissionName(String permissionName){
   this.permissionName = permissionName;
  }
  
  public String getRoleDisplayName() {
   return roleDisplayName;
  }

  public void setRoleDisplayName(String roleDisplayName){
   this.roleDisplayName = roleDisplayName;
  }
  
  public Long getPermissionId() {
  return permissionId;
  }

  public void setPermissionId(Long permissionId){
  this.permissionId = permissionId;
  }
  
  public Long getRoleId() {
  return roleId;
  }

  public void setRoleId(Long roleId){
  this.roleId = roleId;
  }
}
