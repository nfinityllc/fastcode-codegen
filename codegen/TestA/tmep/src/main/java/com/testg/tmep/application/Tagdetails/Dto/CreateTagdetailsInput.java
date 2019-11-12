package com.testg.tmep.application.Tagdetails.Dto;

import java.util.Date;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class CreateTagdetailsInput {

  @Length(max = 256, message = "country must be less than 256 characters")
  private String country;
  
  @Length(max = 256, message = "tid must be less than 256 characters")
  private String tid;
  
  @Length(max = 256, message = "title must be less than 256 characters")
  private String title;
  

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
