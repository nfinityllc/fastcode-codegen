package [=PackageName].domain<#if AuthenticationType != "none" && ClassName == AuthenticationTable>.Authorization</#if>.[=ClassName];

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.[=EntityClassName];
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>
<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
import [=PackageName].domain.model.RoleEntity;
</#if>
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

	public [=EntityClassName] FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=ClassName?uncap_first]Id</#if>) {
    	Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=IdClass?uncap_first]);
		if(db[=ClassName].isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName];
		} else {
		    return null;
		}

	}
	<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
	<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
	public [=EntityClassName] FindBy[=authValue.fieldName?cap_first](String [=authValue.fieldName?uncap_first]) {
		return  _[=InstanceName]Repository.findBy[=authValue.fieldName?cap_first]([=authValue.fieldName?uncap_first]);
	}
	</#if>
    </#list>
    </#if>
    //Role
	public RoleEntity GetRole(Long [=ClassName?uncap_first]Id) {
		
		Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=ClassName?uncap_first]Id);
		if(dbUser.isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName].getRole();
		} else {
		    return null;
		}

	}
    </#if>

	public Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable) {

		return _[=InstanceName]Repository.findAll(predicate,pageable);
	}
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne"|| relationValue.relation == "OneToOne">
  
   //[=relationValue.eName]
	public [=relationValue.eName]Entity Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=ClassName?uncap_first]Id</#if>) {
		
		Optional<[=EntityClassName]> db[=ClassName]= _[=InstanceName]Repository.findById([=IdClass?uncap_first]);
		if(db[=ClassName].isPresent()) {
			[=EntityClassName] existing[=ClassName] = db[=ClassName].get();
		    return existing[=ClassName].get[=relationValue.eName]();
		} else {
		    return null;
		}
	}
   </#if>
  </#list>
}
