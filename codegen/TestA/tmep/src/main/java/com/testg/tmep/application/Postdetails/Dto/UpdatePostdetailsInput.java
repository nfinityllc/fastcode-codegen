package com.testg.tmep.application.Postdetails.Dto;

import java.util.Date;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class UpdatePostdetailsInput {

  @Length(max = 256, message = "country must be less than 256 characters")
  private String country;
  
  @Length(max = 2147483647, message = "pdid must be less than 2147483647 characters")
  private String pdid;
  
  @Length(max = 256, message = "pid must be less than 256 characters")
  private String pid;
  
  private String title;

  public String getTitle() {
  	return title;
  }

  public void setTitle(String title){
  	this.title = title;
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
