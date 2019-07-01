package [=PackageName].domain.IRepository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import [=CommonModulePackage].Search.SearchFields;
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if relationKey == parent>
<#if parent?keep_after("-") == relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;

public interface [=ClassName]CustomRepository {

 Page<[=relationValue.eName]Entity> getAll[=relationValue.eName](Long [=ClassName?uncap_first]Id,List<SearchFields> search,String operator,Pageable pageable);
</#if>
</#if>
</#list>
</#if>
</#list>
	
}
