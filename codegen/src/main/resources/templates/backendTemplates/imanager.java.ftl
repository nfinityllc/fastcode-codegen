package [=PackageName].domain.[=ClassName];

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import [=PackageName].domain.model.[=EntityClassName];
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=ClassName]Id;
</#if>
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>

public interface I[=ClassName]Manager {
    // CRUD Operations
    [=EntityClassName] Create([=EntityClassName] [=InstanceName]);

    void Delete([=EntityClassName] [=InstanceName]);

    [=EntityClassName] Update([=EntityClassName] [=InstanceName]);

    [=EntityClassName] FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> id</#if>);

    Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable);
   
   <#list Relationship as relationKey, relationValue>
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
    //[=relationValue.eName]
    public [=relationValue.eName]Entity Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> [=InstanceName]Id</#if>);
  
   </#if>
  </#list>
}
