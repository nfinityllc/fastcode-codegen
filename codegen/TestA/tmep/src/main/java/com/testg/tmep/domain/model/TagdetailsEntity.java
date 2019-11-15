package com.testg.tmep.domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;
@Entity
@Table(name = "tagdetails", schema = "test4")
@IdClass(TagId.class)
public class TagdetailsEntity implements Serializable {

  private String country;
  private String tid;
  private String title;
 
  public TagdetailsEntity() {
	}

  @Basic
  @Column(name = "country", nullable = true, length =256)
  public String getCountry() {
  return country;
  }

  public void setCountry(String country){
  this.country = country;
  }
  
  
  @OneToOne(fetch=FetchType.LAZY, cascade=CascadeType.MERGE)
  @JoinColumns({@JoinColumn(name="tid", referencedColumnName="tagid", insertable=false, updatable=false),@JoinColumn(name="title", referencedColumnName="title", insertable=false, updatable=false)})
  public TagEntity getTag() {
    return tag;
  }
  public void setTag(TagEntity tag) {
    this.tag = tag;
  }
  
  private TagEntity tag;
  @Id
  @Column(name = "tid", nullable = true, length =256)
  public String getTid() {
  return tid;
  }

  public void setTid(String tid){
  this.tid = tid;
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
//      if (!(o instanceof TagdetailsEntity)) return false;
//        TagdetailsEntity tagdetails = (TagdetailsEntity) o;
//        return id != null && id.equals(tagdetails.id);
//  }

}

  
      


