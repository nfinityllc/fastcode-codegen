package [=PackageName].domain.IRepository;

<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;
</#if>
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=EntityClassName];
</#if>
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "OneToMany">
import [=PackageName].domain.model.[=relationValue.eName]Entity; 
import java.util.List;
</#if>
</#list>
import [=PackageName].domain.model.[=EntityClassName];

<#if History!false>
@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "[=ApiPath]", path = "[=ApiPath]")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], Long>,QuerydslPredicateExecutor<[=EntityClassName]> {

<#if CompositeKeyClasses?seq_contains(ClassName)>
    <#assign count = 0>
    @Query("select e from [=EntityClassName] e where <#list PrimaryKeys?keys as key><#assign count = count+1><#if key_has_next>e.[=key] = ?[=count] and <#else>e.[=key] = ?[=count]"</#if></#list>)
	[=EntityClassName] findById(<#list PrimaryKeys?keys as key><#if key_has_next>[=PrimaryKeys[key]] [=key],<#else>[=PrimaryKeys[key]] [=key]</#if></#list>);
<#else>
<#list Fields as key,value>
 <#if value.isPrimaryKey!false>
 <#if value.fieldType?lower_case == "long" >
      @Query("select e from [=EntityClassName] e where e.[=value.fieldName] = ?1")
	  [=EntityClassName] findById(long [=value.fieldName]);
  <#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "string">
      @Query("select e from [=EntityClassName] e where e.[=value.fieldName] = ?1")
	  [=EntityClassName] findById([=value.fieldType] [=value.fieldName]);
	  
  </#if>

  </#if>
</#list>
</#if>

	 <#list Relationship as relationKey, relationValue>
     <#if relationValue.relation == "OneToMany">
     <#list relationValue.joinDetails as joinDetails>
     <#if joinDetails.joinEntityName == relationValue.eName>
     <#if joinDetails.joinColumn??>
	  @Query("select e from [=relationValue.eName]Entity e where e.[=ClassName?uncap_first].[=joinDetails.joinColumn] = ?1")
	  List<[=relationValue.eName]Entity> findBy[=relationValue.eName]([=joinDetails.joinColumnType] [=joinDetails.joinColumn]);
	 </#if>
     </#if>
     </#list>
     </#if>
     </#list>
	   
}
