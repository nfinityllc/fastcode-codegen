package com.testg.tmep.application.Tagdetails.Dto;

import java.util.Date;
public class CreateTagdetailsOutput {

    private String country;
    private String tid;
    private String title;
	private String tagDescriptiveField;
	
  public String getTagDescriptiveField() {
  	return tagDescriptiveField;
  }

  public void setTagDescriptiveField(String tagDescriptiveField){
  	this.tagDescriptiveField = tagDescriptiveField;
  }
 
  public String getCountry() {
  	return country;
  }

  public void setCountry(String country){
  	this.country = country;
  }
  
  public String getTid() {
  	return tid;
  }

  public void setTid(String tid){
  	this.tid = tid;
  }
  
  public String getTitle() {
  	return title;
  }

  public void setTitle(String title){
  	this.title = title;
  }
  
}
