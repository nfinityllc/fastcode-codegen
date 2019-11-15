package com.testg.tmep.domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;
@Entity
@Table(name = "post", schema = "test4")
@IdClass(PostId.class)
public class PostEntity implements Serializable {

  private String description;
  private String postid;
  private String title;
 
  public PostEntity() {
	}

  @Basic
  @Column(name = "description", nullable = true, length =256)
  public String getDescription() {
  return description;
  }

  public void setDescription(String description){
  this.description = description;
  }
  
  @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true) 
  public Set<PostdetailsEntity> getPostdetailsSet() { 
      return postdetailsSet; 
  } 
 
  public void setPostdetailsSet(Set<PostdetailsEntity> postdetails) { 
      this.postdetailsSet = postdetails; 
  } 
 
  private Set<PostdetailsEntity> postdetailsSet = new HashSet<PostdetailsEntity>(); 
  @Id
  @Column(name = "postid", nullable = true, length =256)
  public String getPostid() {
  return postid;
  }

  public void setPostid(String postid){
  this.postid = postid;
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
//      if (!(o instanceof PostEntity)) return false;
//        PostEntity post = (PostEntity) o;
//        return id != null && id.equals(post.id);
//  }

}

  
      


