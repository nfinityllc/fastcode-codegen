package com.testg.tmep.application.Post.Dto;

import java.util.Date;
public class UpdatePostOutput {

  private String description;
  private String postid;
  private String title;

  public String getDescription() {
  	return description;
  }

  public void setDescription(String description){
  	this.description = description;
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