package com.testg.tmep.domain.IRepository;

import com.testg.tmep.domain.model.PostdetailsId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import java.util.List;
import com.testg.tmep.domain.model.PostdetailsEntity;

@RepositoryRestResource(collectionResourceRel = "postdetails", path = "postdetails")
public interface IPostdetailsRepository extends JpaRepository<PostdetailsEntity, PostdetailsId>,QuerydslPredicateExecutor<PostdetailsEntity> {
//    @Query("select e from PostdetailsEntity e where e.pdid = ?1 and e.pid = ?2")
//	PostdetailsEntity findById(String pdid,String pid);
}
