package com.testg.tmep.application.Post.Dto;

import java.util.Date;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class UpdatePostInput {

  @Length(max = 256, message = "description must be less than 256 characters")
  private String description;
  
  @Length(max = 256, message = "postid must be less than 256 characters")
  private String postid;
  
  @Length(max = 256, message = "title must be less than 256 characters")
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
