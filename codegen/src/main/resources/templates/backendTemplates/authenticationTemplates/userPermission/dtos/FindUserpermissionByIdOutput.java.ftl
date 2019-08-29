package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

public class Find[=AuthenticationTable]permissionByIdOutput {

  private Long permissionId;
  private Long userid;

  private String [=AuthenticationTable?uncap_first]Username;
  private String permissionName;
  
  public String get[=AuthenticationTable]Username() {
   return [=AuthenticationTable?uncap_first]Username;
  }

  public void set[=AuthenticationTable]Username(String [=AuthenticationTable?uncap_first]Username){
   this.[=AuthenticationTable?uncap_first]Username = [=AuthenticationTable?uncap_first]Username;
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
  public Long getUserid() {
  return userid;
  }

  public void setUserid(Long userid){
  this.userid = userid;
  }

}
