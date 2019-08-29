package [=PackageName].domain.model;

import java.io.Serializable;

public class [=AuthenticationTable]permissionId implements Serializable {

    private Long permissionId;
    private Long userid;
    
    public [=AuthenticationTable]permissionId() {

    }
    public [=AuthenticationTable]permissionId(Long permissionId,Long userid) {
  		this.permissionId =permissionId;
  		this.userid =userid;
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