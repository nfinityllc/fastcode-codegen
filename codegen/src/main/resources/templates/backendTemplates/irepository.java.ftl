package [=PackageName].domain.IRepository;

import java.util.List;
<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;
</#if>
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "OneToMany">
import [=PackageName].domain.model.[=relationValue.eName]Entity;     
</#if>
</#list>
import [=PackageName].domain.model.[=EntityClassName];

<#if History!false>
@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "[=ApiPath]", path = "[=ApiPath]")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], Long>, QuerydslPredicateExecutor<[=EntityClassName]> {

	   @Query("select e from [=EntityClassName] e where e.id = ?1")
	   [=EntityClassName] findById(long id);
	   
	 <#list Relationship as relationKey, relationValue>
     <#if relationValue.relation == "OneToMany">
	   @Query("select e from [=relationValue.eName]Entity e where e.[=ClassName?uncap_first].id = ?1")
	   List<[=relationValue.eName]Entity> findBy[=relationValue.eName]([=relationValue.joinColumnType] id);
	 </#if>
     </#list>
	   
}
