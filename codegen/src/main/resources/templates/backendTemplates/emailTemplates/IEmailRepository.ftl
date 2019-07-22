package com.nfinity.fastcode.domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.nfinity.fastcode.domain.Authorization.Email.EmailEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "email", path = "email")
public interface IEmailRepository extends JpaRepository<EmailEntity, Long>, QuerydslPredicateExecutor<EmailEntity> {

	   @Query("select e from EmailEntity e where e.id = ?1")
	   EmailEntity findById(long id);

	   @Query("select e from EmailEntity e where e.templateName = ?1")
	   EmailEntity findByEmailName(String value);
	
}
