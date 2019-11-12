package com.testg.tmep.domain.model;

import java.io.Serializable;

public class TagId implements Serializable {

    private String tagid;
    private String title;
    public TagId() {

    }
    public TagId(String tagid,String title) {
  		this.tagid =tagid;
  		this.title =title;
    }
    
    public String getTagid() {
        return tagid;
    }
    public void setTagid(String tagid){
        this.tagid = tagid;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title){
        this.title = title;
    }
    
}