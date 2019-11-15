package com.testg.tmep.domain.IRepository;

import com.testg.tmep.domain.model.TagId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import java.util.List;
import com.testg.tmep.domain.model.TagdetailsEntity;

@RepositoryRestResource(collectionResourceRel = "tagdetails", path = "tagdetails")
public interface ITagdetailsRepository extends JpaRepository<TagdetailsEntity, TagId>,QuerydslPredicateExecutor<TagdetailsEntity> {
//    @Query("select e from TagdetailsEntity e where e.tid = ?1 and e.title = ?2")
//	TagdetailsEntity findById(String tid,String title);
}
