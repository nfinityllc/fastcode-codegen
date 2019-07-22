package [=PackageName].domain.[=ClassName];

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation == "ManyToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
<#if relationValue.relation =="ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if relationKey == parent>
<#if parent?keep_after("-") == relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import java.util.List;
import java.util.Iterator;
import java.util.Set;
import [=CommonModulePackage].Search.SearchFields;
</#if>
</#if>
</#list>
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

	public [=EntityClassName] FindById(Long id) {

		return _[=InstanceName]Repository.findById(id.longValue());
	}

	public Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable) {

		return _[=InstanceName]Repository.findAll(predicate,pageable);
	}

  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne">
   //[=relationValue.eName]
	public [=relationValue.eName]Entity Get[=relationValue.eName](Long [=InstanceName]Id) {
		
		[=EntityClassName] entity = _[=InstanceName]Repository.findById([=InstanceName]Id.longValue());
		return entity.get[=relationValue.eName]();
	}
	 <#elseif relationValue.relation == "ManyToMany">
    //[=relationValue.eName]
    <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if relationKey == parent>
    <#if parent?keep_after("-") == relationValue.eName>
    //[=relationValue.eName]
	public Page<[=relationValue.eName]Entity> Find[=relationValue.eName](Long [=ClassName?lower_case]Id,List<SearchFields> search,String operator,Pageable pageable) {

		return _[=ClassName?lower_case]Repository.getAll[=relationValue.eName]([=ClassName?lower_case]Id,search,operator,pageable);
	}

	public Boolean Add[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {
		
		Set<[=relationValue.eName]Entity> entitySet = [=InstanceName].get[=relationValue.eName]();

		if (!entitySet.contains([=relationValue.eName?lower_case])) {
		    entitySet.add([=relationValue.eName?lower_case]);
			[=InstanceName].set[=relationValue.eName](entitySet);
		} else {
			return false;
		}
		_[=InstanceName]Repository.save([=InstanceName]);
		return true;
	}

	public void Remove[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {

		 Set<[=relationValue.eName]Entity> entitySet = [=InstanceName].get[=relationValue.eName]();

	        if (entitySet.contains([=relationValue.eName?lower_case])) {
	            entitySet.remove([=relationValue.eName?lower_case]);
	            [=InstanceName].set[=relationValue.eName](entitySet);
	        }
	        _[=InstanceName]Repository.save([=InstanceName]);
	}

	public [=relationValue.eName]Entity Get[=relationValue.eName](Long [=InstanceName]Id, Long [=relationValue.eName?lower_case]Id) {

		[=EntityClassName] foundRecord = _[=InstanceName]Repository.findById([=InstanceName]Id.longValue());
		
		Set<[=relationValue.eName]Entity> [=relationValue.eName?lower_case] = foundRecord.get[=relationValue.eName]();
		Iterator iterator = [=relationValue.eName?lower_case].iterator();
		while (iterator.hasNext()) { 
			[=relationValue.eName]Entity pe = ([=relationValue.eName]Entity) iterator.next();
			if (pe.getId() == [=relationValue.eName?lower_case]Id) {
				return pe;
			}
		}
		return null;
	}

	</#if>
    </#if>
    </#list>
   </#if>
  </#list>
}
