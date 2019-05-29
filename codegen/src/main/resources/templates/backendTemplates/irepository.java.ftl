package [=PackageName].domain.IRepository;

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
import java.util.List;
<#elseif relationValue.relation =="ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if parent?keep_after("-") == relationValue.eName>  
import org.springframework.data.repository.query.Param;
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
</#if>
</#list>
</#if>
</#list>
import [=PackageName].domain.model.[=EntityClassName];

<#if History!false>
@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "[=ApiPath]", path = "[=ApiPath]")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], Long>, <#list Relationship as relationKey, relationValue><#if relationValue.relation =="ManyToMany"><#list RelationInput as relationInput><#assign parent = relationInput><#if parent?keep_after("-") == relationValue.eName>
	 [=ClassName]CustomRepository,</#if></#list></#if></#list>QuerydslPredicateExecutor<[=EntityClassName]> {

	  @Query("select e from [=EntityClassName] e where e.id = ?1")
	  [=EntityClassName] findById(long id);
	   
	 <#list Relationship as relationKey, relationValue>
     <#if relationValue.relation == "OneToMany">
	  @Query("select e from [=relationValue.eName]Entity e where e.[=ClassName?uncap_first].id = ?1")
	  List<[=relationValue.eName]Entity> findBy[=relationValue.eName]([=relationValue.joinColumnType] id);
	 </#if>
     </#list>

    
	   
}
