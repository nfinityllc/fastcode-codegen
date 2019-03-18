package com.ninfinity.model;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "permissions", schema = "dbo", catalog = "FCV2Db")
public class Permission { 
    private long id;
    private Timestamp creationtime;
    private String creatoruserid;
    private Timestamp lastmodificationtime;
    private String lastmodifieruserid;
    private String displayname;
    private String name;

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
    @Column(name = "displayname")
    public String getDisplayname() {
        return displayname;
    }

    public void setDisplayname(String displayname) {
        this.displayname = displayname;
    }

    @Basic
    @Column(name = "name")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
}
