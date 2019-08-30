package [=PackageName].domain<#if AuthenticationType== "database" && ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName];

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.[=EntityClassName];
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=ClassName]Id;
</#if>
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>

import [=PackageName].domain.IRepository.I[=ClassName]Repository;
import com.querydsl.core.types.Predicate;

@Repository
public class [=ClassName]Manager implements I[=ClassName]Manager {

    @Autowired
    I[=ClassName]Repository  _[=InstanceName]Repository;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName>
    
    @Autowired
	I[=relationValue.eName]Repository  _[=relationValue.eName?lower_case]Repository;
    </#if>
    </#list>
    
	public [=EntityClassName] Create([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	public void Delete([=EntityClassName] [=InstanceName]) {

		_[=InstanceName]Repository.delete([=InstanceName]);	
	}

	public [=EntityClassName] Update([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	public [=EntityClassName] FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> [=ClassName?uncap_first]Id</#if>)
    {
    Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=ClassName?uncap_first]Id);
		if(db[=ClassName].isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName];
		} else {
		    return null;
		}
        <#if CompositeKeyClasses?seq_contains(ClassName)>
     //   return _[=InstanceName]Repository.findById(<#list PrimaryKeys?keys as key><#if key_has_next>
     //   [=ClassName?uncap_first]Id.get[=key?cap_first](),<#else>[=ClassName?uncap_first]Id.get[=key?cap_first]()</#if></#list>);
        <#else>
     //  return _[=InstanceName]Repository.findById(<#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">[=ClassName?uncap_first]Id.longValue());<#elseif value.fieldType?lower_case == "integer">[=ClassName?uncap_first]Id );<#elseif value.fieldType?lower_case == "short">[=ClassName?uncap_first]Id );<#elseif value.fieldType?lower_case == "double">[=ClassName?uncap_first]Id );<#elseif value.fieldType?lower_case == "string">[=ClassName?uncap_first]Id);</#if></#if></#list></#if>

	}
	<#if AuthenticationType== "database" && ClassName == AuthenticationTable>
	
	public [=EntityClassName] FindBy[=ClassName]Name(String [=ClassName?uncap_first]Name) {
		return  _[=InstanceName]Repository.findBy[=ClassName]Name([=ClassName?uncap_first]Name);
	}
    </#if>

	public Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable) {

		return _[=InstanceName]Repository.findAll(predicate,pageable);
	}
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne"|| relationValue.relation == "OneToOne">
  <#if relationValue.isParent == false>
  
   //[=relationValue.eName]
	public [=relationValue.eName]Entity Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=ClassName]Id [=ClassName?uncap_first]Id<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=ClassName?uncap_first]Id</#if>) {
		
		Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=ClassName?uncap_first]Id);
		if(db[=ClassName].isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName].get[=relationValue.eName]();
		} else {
		    return null;
		}
	}
   </#if>	
   </#if>
  </#list>
}
