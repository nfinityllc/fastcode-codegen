package com.testg.tmep.domain.model;

import java.io.Serializable;

public class PostdetailsId implements Serializable {

    private String pdid;
    private String pid;
    public PostdetailsId() {

    }
    public PostdetailsId(String pdid,String pid) {
  		this.pdid =pdid;
  		this.pid =pid;
    }
    
    public String getPdid() {
        return pdid;
    }
    public void setPdid(String pdid){
        this.pdid = pdid;
    }
    public String getPid() {
        return pid;
    }
    public void setPid(String pid){
        this.pid = pid;
    }
    
}