package com.nfinity.model;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
public class UsersEntity2 {
    private long id;
    private Timestamp creationtime;
    private String creatoruserid;
    private Timestamp lastmodificationtime;
    private String lastmodifieruserid;
    private Integer accessfailedcount;
    private String authenticationsource;
    private String emailaddress;
    private String emailconfirmationcode;
    private String firstname;
    private boolean isactive;
    private Boolean isemailconfirmed;
    private Boolean islockoutenabled;
    private String isphonenumberconfirmed;
    private Boolean twofactorenabled;
    private Timestamp lastlogintime;
    private String lastname;
    private Timestamp lockoutenddateutc;
    private String password;
    private String passwordresetcode;
    private String phonenumber;
    private Long profilepictureid;
    private String username;

    @Id
    @Column(name = "id")
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "creationtime")
    public Timestamp getCreationtime() {
        return creationtime;
    }

    public void setCreationtime(Timestamp creationtime) {
        this.creationtime = creationtime;
    }

    @Basic
    @Column(name = "creatoruserid")
    public String getCreatoruserid() {
        return creatoruserid;
    }

    public void setCreatoruserid(String creatoruserid) {
        this.creatoruserid = creatoruserid;
    }

    @Basic
    @Column(name = "lastmodificationtime")
    public Timestamp getLastmodificationtime() {
        return lastmodificationtime;
    }

    public void setLastmodificationtime(Timestamp lastmodificationtime) {
        this.lastmodificationtime = lastmodificationtime;
    }

    @Basic
    @Column(name = "lastmodifieruserid")
    public String getLastmodifieruserid() {
        return lastmodifieruserid;
    }

    public void setLastmodifieruserid(String lastmodifieruserid) {
        this.lastmodifieruserid = lastmodifieruserid;
    }

    @Basic
    @Column(name = "accessfailedcount")
    public Integer getAccessfailedcount() {
        return accessfailedcount;
    }

    public void setAccessfailedcount(Integer accessfailedcount) {
        this.accessfailedcount = accessfailedcount;
    }

    @Basic
    @Column(name = "authenticationsource")
    public String getAuthenticationsource() {
        return authenticationsource;
    }

    public void setAuthenticationsource(String authenticationsource) {
        this.authenticationsource = authenticationsource;
    }

    @Basic
    @Column(name = "emailaddress")
    public String getEmailaddress() {
        return emailaddress;
    }

    public void setEmailaddress(String emailaddress) {
        this.emailaddress = emailaddress;
    }

    @Basic
    @Column(name = "emailconfirmationcode")
    public String getEmailconfirmationcode() {
        return emailconfirmationcode;
    }

    public void setEmailconfirmationcode(String emailconfirmationcode) {
        this.emailconfirmationcode = emailconfirmationcode;
    }

    @Basic
    @Column(name = "firstname")
    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    @Basic
    @Column(name = "isactive")
    public boolean isIsactive() {
        return isactive;
    }

    public void setIsactive(boolean isactive) {
        this.isactive = isactive;
    }

    @Basic
    @Column(name = "isemailconfirmed")
    public Boolean getIsemailconfirmed() {
        return isemailconfirmed;
    }

    public void setIsemailconfirmed(Boolean isemailconfirmed) {
        this.isemailconfirmed = isemailconfirmed;
    }

    @Basic
    @Column(name = "islockoutenabled")
    public Boolean getIslockoutenabled() {
        return islockoutenabled;
    }

    public void setIslockoutenabled(Boolean islockoutenabled) {
        this.islockoutenabled = islockoutenabled;
    }

    @Basic
    @Column(name = "isphonenumberconfirmed")
    public String getIsphonenumberconfirmed() {
        return isphonenumberconfirmed;
    }

    public void setIsphonenumberconfirmed(String isphonenumberconfirmed) {
        this.isphonenumberconfirmed = isphonenumberconfirmed;
    }

    @Basic
    @Column(name = "twofactorenabled")
    public Boolean getTwofactorenabled() {
        return twofactorenabled;
    }

    public void setTwofactorenabled(Boolean twofactorenabled) {
        this.twofactorenabled = twofactorenabled;
    }

    @Basic
    @Column(name = "lastlogintime")
    public Timestamp getLastlogintime() {
        return lastlogintime;
    }

    public void setLastlogintime(Timestamp lastlogintime) {
        this.lastlogintime = lastlogintime;
    }

    @Basic
    @Column(name = "lastname")
    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    @Basic
    @Column(name = "lockoutenddateutc")
    public Timestamp getLockoutenddateutc() {
        return lockoutenddateutc;
    }

    public void setLockoutenddateutc(Timestamp lockoutenddateutc) {
        this.lockoutenddateutc = lockoutenddateutc;
    }

    @Basic
    @Column(name = "password")
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Basic
    @Column(name = "passwordresetcode")
    public String getPasswordresetcode() {
        return passwordresetcode;
    }

    public void setPasswordresetcode(String passwordresetcode) {
        this.passwordresetcode = passwordresetcode;
    }

    @Basic
    @Column(name = "phonenumber")
    public String getPhonenumber() {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }

    @Basic
    @Column(name = "profilepictureid")
    public Long getProfilepictureid() {
        return profilepictureid;
    }

    public void setProfilepictureid(Long profilepictureid) {
        this.profilepictureid = profilepictureid;
    }

    @Basic
    @Column(name = "username")
    public String getUsername() {
        return username;
    }

    // Users⁩ ▸ ⁨getachew⁩ ▸ ⁨fc⁩ ▸ ⁨fastCode⁩
    // --t=all --e="com.nfinity.model.Permission" --s=/Users/getachew/fc/exer/model/
    // --d=/Users/getachew/fc/exer/CODEGEN/generated
    public void setUsername(String username) {
        this.username = username;
    }

}
