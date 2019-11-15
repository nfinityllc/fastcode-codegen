package com.testg.tmep.application.Tag.Dto;

import java.util.Date;
public class CreateTagOutput {

    private String description;
    private String tagid;
    private String title;
	private String tid;
	
  public String getTid() {
  	return tid;
  }

  public void setTid(String tid){
  	this.tid = tid;
  }
  
  public String getDescription() {
  	return description;
  }

  public void setDescription(String description){
  	this.description = description;
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
