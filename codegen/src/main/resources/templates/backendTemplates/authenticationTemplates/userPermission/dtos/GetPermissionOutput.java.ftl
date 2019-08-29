package [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto;

public class GetPermissionOutput {
  private String displayName;
  private Long id;
  private String name;

  private Long [=AuthenticationTable?uncap_first]permissionPermissionId;
  
  public Long get[=AuthenticationTable]permissionPermissionId() {
  return [=AuthenticationTable?uncap_first]permissionPermissionId;
  }

  public void set[=AuthenticationTable]permissionPermissionId(Long [=AuthenticationTable?uncap_first]permissionPermissionId){
  this.[=AuthenticationTable?uncap_first]permissionPermissionId = [=AuthenticationTable?uncap_first]permissionPermissionId;
  }
  private Long [=AuthenticationTable?uncap_first]permissionUserid;
  
  public Long get[=AuthenticationTable]permissionUserid() {
  return [=AuthenticationTable?uncap_first]permissionUserid;
  }

  public void set[=AuthenticationTable]permissionUserid(Long [=AuthenticationTable?uncap_first]permissionUserid){
  this.[=AuthenticationTable?uncap_first]permissionUserid = [=AuthenticationTable?uncap_first]permissionUserid;
  }
  public String getDisplayName() {
  return displayName;
  }

  public void setDisplayName(String displayName){
  this.displayName = displayName;
  }
  public Long getId() {
  return id;
  }

  public void setId(Long id){
  this.id = id;
  }
  public String getName() {
  return name;
  }

  public void setName(String name){
  this.name = name;
  }

}
