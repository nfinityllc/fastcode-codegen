package com.testg.tmep.application.Tag.Dto;

import java.util.Date;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class CreateTagInput {

  @Length(max = 256, message = "description must be less than 256 characters")
  private String description;
  
  @Length(max = 256, message = "tagid must be less than 256 characters")
  private String tagid;
  
  @Length(max = 256, message = "title must be less than 256 characters")
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
