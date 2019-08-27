package [=PackageName].application.Authorization.User.Dto;

import java.util.Date;

public class GetRoleOutput {
    private Long id;
    private String displayName;
    private String name;
    <#if Audit!false>
    private String creatorUserId;
    private java.util.Date creationTime;
    private String lastModifierUserId;
    private java.util.Date lastModificationTime;
    </#if>
    private Long userId;
    private String userName;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    <#if Audit!false>
    public java.util.Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(java.util.Date creationTime) {
      	this.creationTime = creationTime;
    }

    public String getLastModifierUserId() {
      	return lastModifierUserId;
    }

    public void setLastModifierUserId(String lastModifierUserId) {
      	this.lastModifierUserId = lastModifierUserId;
    }

    public java.util.Date getLastModificationTime() {
      	return lastModificationTime;
    }

    public void setLastModificationTime(java.util.Date lastModificationTime) {
      	this.lastModificationTime = lastModificationTime;
    }

    public String getCreatorUserId() {
      	return creatorUserId;
    }

    public void setCreatorUserId(String creatorUserId) {
      	this.creatorUserId = creatorUserId;
    }
</#if>

}

