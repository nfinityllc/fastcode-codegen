package com.testg.tmep.domain.IRepository;

import com.testg.tmep.domain.model.PostId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import com.testg.tmep.domain.model.PostdetailsEntity; 
import java.util.List;
import com.testg.tmep.domain.model.PostEntity;

@RepositoryRestResource(collectionResourceRel = "post", path = "post")
public interface IPostRepository extends JpaRepository<PostEntity, PostId>,QuerydslPredicateExecutor<PostEntity> {
//    @Query("select e from PostEntity e where e.postid = ?1 and e.title = ?2")
//	PostEntity findById(String postid,String title);
}
