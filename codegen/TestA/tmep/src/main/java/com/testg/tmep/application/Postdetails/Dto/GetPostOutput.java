package com.testg.tmep.application.Postdetails.Dto;

import java.util.Date;

public class GetPostOutput {
  private String description;
  private String postid;
  private String title;

  private String postdetailsPdid;
  
  public String getPostdetailsPdid() {
  	return postdetailsPdid;
  }

  public void setpostdetailsPdid(String postdetailsPdid){
  	this.postdetailsPdid = postdetailsPdid;
  }
  private String postdetailsPid;
  
  public String getPostdetailsPid() {
  	return postdetailsPid;
  }

  public void setpostdetailsPid(String postdetailsPid){
  	this.postdetailsPid = postdetailsPid;
  }
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
