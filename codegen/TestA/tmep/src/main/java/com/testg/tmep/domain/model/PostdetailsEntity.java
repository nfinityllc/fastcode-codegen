package com.testg.tmep.domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;
@Entity
@Table(name = "postdetails", schema = "test4")
@IdClass(PostdetailsId.class)
public class PostdetailsEntity implements Serializable {

  private String country;
  private String pdid;
  private String pid;
 
  public PostdetailsEntity() {
	}

  @Basic
  @Column(name = "country", nullable = true, length =256)
  public String getCountry() {
  return country;
  }

  public void setCountry(String country){
  this.country = country;
  }
  
  @Id
  @Column(name = "pdid", nullable = true, length =2147483647)
  public String getPdid() {
  return pdid;
  }

  public void setPdid(String pdid){
  this.pdid = pdid;
  }
  
  @Id
  @Column(name = "pid", nullable = true, length =256)
  public String getPid() {
  return pid;
  }

  public void setPid(String pid){
  this.pid = pid;
  }
  
  
  @ManyToOne(fetch=FetchType.LAZY, cascade=CascadeType.MERGE)
  @JoinColumns({@JoinColumn(name="pid", referencedColumnName="postid", insertable=false, updatable=false),@JoinColumn(name="title", referencedColumnName="title", insertable=false, updatable=false)})
  public PostEntity getPost() {
    return post;
  }
  public void setPost(PostEntity post) {
    this.post = post;
  }
  
  private PostEntity post;


//  @Override
//  public boolean equals(Object o) {
//    if (this == o) return true;
//      if (!(o instanceof PostdetailsEntity)) return false;
//        PostdetailsEntity postdetails = (PostdetailsEntity) o;
//        return id != null && id.equals(postdetails.id);
//  }

}

  
      


