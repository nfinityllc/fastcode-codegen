package [=PackageName].domain.IRepository;
<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;
</#if>
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.[=EntityClassName];

<#if History!false>
@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "[=ApiPath]s", path = "[=ApiPath]s")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], Long>, QuerydslPredicateExecutor<[=EntityClassName]> {

	   @Query("select e from [=EntityClassName] e where e.id = ?1")
	   [=EntityClassName] findById(long id);
	   
}
