package com.testg.tmep.application.Postdetails.Dto;

import java.util.Date;
public class CreatePostdetailsOutput {

    private String country;
    private String pdid;
    private String pid;
	private String title;
	private String postDescriptiveField;
	
  public String getTitle() {
  	return title;
  }

  public void setTitle(String title){
  	this.title = title;
  }
  
  public String getPostDescriptiveField() {
  	return postDescriptiveField;
  }

  public void setPostDescriptiveField(String postDescriptiveField){
  	this.postDescriptiveField = postDescriptiveField;
  }
 
  public String getCountry() {
  	return country;
  }

  public void setCountry(String country){
  	this.country = country;
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
