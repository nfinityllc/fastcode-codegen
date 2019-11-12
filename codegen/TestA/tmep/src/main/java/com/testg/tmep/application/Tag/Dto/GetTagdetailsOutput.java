package com.testg.tmep.application.Tag.Dto;

import java.util.Date;

public class GetTagdetailsOutput {
  private String country;
  private String tid;
  private String title;

  private String tagTagid;
  
  public String getTagTagid() {
  	return tagTagid;
  }

  public void settagTagid(String tagTagid){
  	this.tagTagid = tagTagid;
  }
  private String tagTitle;
  
  public String getTagTitle() {
  	return tagTitle;
  }

  public void settagTitle(String tagTitle){
  	this.tagTitle = tagTitle;
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
