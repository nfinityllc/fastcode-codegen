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
<#elseif relationValue.relation =="ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if parent?keep_after("-") == relationValue.eName>  
import org.springframework.data.repository.query.Param;
//import com.nfinity.demo.domain.model.[=relationValue.eName]Entity;
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
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], Long>, QuerydslPredicateExecutor<[=EntityClassName]> {

	   @Query("select e from [=EntityClassName] e where e.id = ?1")
	   [=EntityClassName] findById(long id);
	   
	 <#list Relationship as relationKey, relationValue>
     <#if relationValue.relation == "OneToMany">
	   @Query("select e from [=relationValue.eName]Entity e where e.[=ClassName?uncap_first].id = ?1")
	   List<[=relationValue.eName]Entity> findBy[=relationValue.eName]([=relationValue.joinColumnType] id);
	 <#elseif relationValue.relation =="ManyToMany">
	 <#list RelationInput as relationInput>
     <#assign parent = relationInput>
     <#if parent?keep_after("-") == relationValue.eName>
	  @Query("select c from [=relationValue.eName]Entity c join c.[=ClassName?uncap_first] s where (s.id= :id) "<#list relationValue.fDetails as fValue><#if fValue.fieldType?lower_case == "string">
	  +"and (c.[=fValue.fieldName] = :[=fValue.fieldName] OR :[=fValue.fieldName] is null)"</#if></#list>)
      Page<[=relationValue.eName]Entity> getData(@Param("id")Long [=ClassName?uncap_first]Id,<#list relationValue.fDetails as fValue><#if fValue.fieldType?lower_case == "string">@Param("[=fValue.fieldName]") String [=fValue.fieldName],</#if></#list>Pageable pageable);
	 </#if>
	 </#list>
	 </#if>
     </#list>
	   
}
