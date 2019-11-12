package com.testg.tmep.domain.model;

import java.io.Serializable;

public class PostId implements Serializable {

    private String postid;
    private String title;
    public PostId() {

    }
    public PostId(String postid,String title) {
  		this.postid =postid;
  		this.title =title;
    }
    
    public String getPostid() {
        return postid;
    }
    public void setPostid(String postid){
        this.postid = postid;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title){
        this.title = title;
    }
    
}