package [=PackageName].application.Authorization.Userpermission.Dto;

public class GetPermissionOutput {
  private String displayName;
  private Long id;
  private String name;

  private Long userpermissionPermissionId;
  
  public Long getuserpermissionPermissionId() {
  return userpermissionPermissionId;
  }

  public void setuserpermissionPermissionId(Long userpermissionPermissionId){
  this.userpermissionPermissionId = userpermissionPermissionId;
  }
  private Long userpermissionUserId;
  
  public Long getuserpermissionUserId() {
  return userpermissionUserId;
  }

  public void setuserpermissionUserId(Long userpermissionUserId){
  this.userpermissionUserId = userpermissionUserId;
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
