package com.nfinity.fastcode.domain.IRepository;

import com.nfinity.fastcode.domain.Scheduler.JobDetailsEntity;
import com.nfinity.fastcode.domain.Scheduler.TriggerDetailsEntity;
import com.querydsl.core.types.Predicate;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "qrtz_triggers", path = "qrtz_triggers")

public interface ITriggerDetailsRepositoy extends JpaRepository<TriggerDetailsEntity, Long> , QuerydslPredicateExecutor<TriggerDetailsEntity> {

//	 @Query("select j from TriggerDetailsEntity j")
 //   Page<TriggerDetailsEntity> findAll(Pageable pageable);
}

