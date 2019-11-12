package com.testg.tmep.domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;
@Entity
@Table(name = "tag", schema = "test4")
@IdClass(TagId.class)
public class TagEntity implements Serializable {

  private String description;
  private String tagid;
  private String title;
 
  public TagEntity() {
	}

  @Basic
  @Column(name = "description", nullable = true, length =256)
  public String getDescription() {
  return description;
  }

  public void setDescription(String description){
  this.description = description;
  }
  
  
  @OneToOne(mappedBy = "tag")
  public TagdetailsEntity getTagdetails() {
    return tagdetails;
  }
  public void setTagdetails(TagdetailsEntity tagdetails) {
    this.tagdetails = tagdetails;
  }
  
  private TagdetailsEntity tagdetails;
  @Id
  @Column(name = "tagid", nullable = true, length =256)
  public String getTagid() {
  return tagid;
  }

  public void setTagid(String tagid){
  this.tagid = tagid;
  }
  
  @Id
  @Column(name = "title", nullable = true, length =256)
  public String getTitle() {
  return title;
  }

  public void setTitle(String title){
  this.title = title;
  }
  


//  @Override
//  public boolean equals(Object o) {
//    if (this == o) return true;
//      if (!(o instanceof TagEntity)) return false;
//        TagEntity tag = (TagEntity) o;
//        return id != null && id.equals(tag.id);
//  }

}

  
      


