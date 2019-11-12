package [=PackageName].domain.IRepository;

<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;
</#if>
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
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
import java.util.List;
import [=PackageName].domain.model.[=EntityClassName];

<#if History!false>
@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "[=ApiPath]", path = "[=ApiPath]")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], <#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list></#if>>,QuerydslPredicateExecutor<[=EntityClassName]> {
<#if CompositeKeyClasses?seq_contains(ClassName)>
    <#assign count = 0>
//    @Query("select e from [=EntityClassName] e where <#list PrimaryKeys?keys as key><#assign count = count+1><#if key_has_next>e.[=key] = ?[=count] and <#else>e.[=key] = ?[=count]"</#if></#list>)
//	[=EntityClassName] findById(<#list PrimaryKeys?keys as key><#if key_has_next>[=PrimaryKeys[key]] [=key],<#else>[=PrimaryKeys[key]] [=key]</#if></#list>);
<#else>
<#list Fields as key,value>
 <#if value.isPrimaryKey!false>
 <#if value.fieldType?lower_case == "long" >
//      @Query("select e from [=EntityClassName] e where e.[=value.fieldName] = ?1")
//	  [=EntityClassName] findById(long [=value.fieldName]);
  <#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "string">
//      @Query("select e from [=EntityClassName] e where e.[=value.fieldName] = ?1")
//	  [=EntityClassName] findById([=value.fieldType] [=value.fieldName]);
  </#if>

  </#if>
</#list>
</#if>
<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
    @Query("select u from [=EntityClassName] u where u.[=authValue.fieldName?uncap_first] = ?1")
    [=EntityClassName] findBy[=authValue.fieldName?cap_first](String value);  
    </#if>
    </#list> 
</#if>
</#if>
}
