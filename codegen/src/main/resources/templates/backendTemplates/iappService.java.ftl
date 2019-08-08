package [=PackageName].application.[=ClassName];

import java.util.List;

import javax.validation.constraints.Positive;
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=ClassName]Id;
</#if>
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.[=ClassName].Dto.*;

@Service
public interface I[=ClassName]AppService {

	Create[=ClassName]Output Create(Create[=ClassName]Input [=ClassName?lower_case]);

    void Delete(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> id</#if>);

    Update[=ClassName]Output Update(@Positive(message ="Id should be a positive value") Long id,Update[=ClassName]Input [=ClassName?lower_case]);

    Find[=ClassName]ByIdOutput FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> id</#if>);

    List<Find[=ClassName]ByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;
	
   <#list Relationship as relationKey, relationValue>
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   //[=relationValue.eName]
   Get[=relationValue.eName]Output Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> [=InstanceName]id</#if>);
  
   </#if>
  
  </#list>
}
