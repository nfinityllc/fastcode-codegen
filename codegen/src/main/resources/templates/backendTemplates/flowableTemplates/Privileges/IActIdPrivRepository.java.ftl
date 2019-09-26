package [=PackageName].domain.IRepository;

import [=PackageName].domain.Flowable.Privileges.ActIdPrivEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;

@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "privileges", path = "privileges")
public interface IActIdPrivRepository extends JpaRepository<ActIdPrivEntity, String>, QuerydslPredicateExecutor<ActIdPrivEntity> {

    @Query("select p from ActIdPrivEntity p where p.name = ?1")
    ActIdPrivEntity findByName(String name);
    }
