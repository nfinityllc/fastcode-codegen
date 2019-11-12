package com.testg.tmep.domain.IRepository;

import com.testg.tmep.domain.model.TagId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import java.util.List;
import com.testg.tmep.domain.model.TagEntity;

@RepositoryRestResource(collectionResourceRel = "tag", path = "tag")
public interface ITagRepository extends JpaRepository<TagEntity, TagId>,QuerydslPredicateExecutor<TagEntity> {
//    @Query("select e from TagEntity e where e.tagid = ?1 and e.title = ?2")
//	TagEntity findById(String tagid,String title);
}
