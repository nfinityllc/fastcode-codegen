package com.testg.tmep.application.Tagdetails.Dto;

import java.util.Date;

public class GetTagOutput {
  private String description;
  private String tagid;
  private String title;

  private String tagdetailsTid;
  
  public String getTagdetailsTid() {
  	return tagdetailsTid;
  }

  public void settagdetailsTid(String tagdetailsTid){
  	this.tagdetailsTid = tagdetailsTid;
  }
  private String tagdetailsTitle;
  
  public String getTagdetailsTitle() {
  	return tagdetailsTitle;
  }

  public void settagdetailsTitle(String tagdetailsTitle){
  	this.tagdetailsTitle = tagdetailsTitle;
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
