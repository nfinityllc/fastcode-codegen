package [=PackageName].domain.[=ClassName];

import java.util.Iterator;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].domain.IRepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation =="ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if parent?keep_after("-") == relationValue.eName>
import java.util.List;
import [=PackageName].Search.SearchFields;
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
    
	@Transactional
	public [=EntityClassName] Create([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	@Transactional
	public void Delete([=EntityClassName] [=InstanceName]) {

		_[=InstanceName]Repository.delete([=InstanceName]);	
	}

	@Transactional
	public [=EntityClassName] Update([=EntityClassName] [=InstanceName]) {

		return _[=InstanceName]Repository.save([=InstanceName]);
	}

	@Transactional
	public [=EntityClassName] FindById(Long id) {

		return _[=InstanceName]Repository.findById(id.longValue());
	}

	@Transactional
	public Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable) {

		return _[=InstanceName]Repository.findAll(predicate,pageable);
	}

  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne">
   //[=relationValue.eName]
	@Transactional
	public [=relationValue.eName]Entity Get[=relationValue.eName](Long [=InstanceName]Id) {
		
		[=EntityClassName] entity = _[=InstanceName]Repository.findById([=InstanceName]Id.longValue());
		return entity.get[=relationValue.eName]();
	}
  <#elseif relationValue.relation == "ManyToMany">
   <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_after("-") == relationValue.eName>
    //[=relationValue.eName]
    @Transactional
	public Page<[=relationValue.eName]Entity> Find[=relationValue.eName](Long [=ClassName?lower_case]Id,List<SearchFields> search,String operator,Pageable pageable) {

		return _[=ClassName?lower_case]Repository.getAll[=relationValue.eName]([=ClassName?lower_case]Id,search,operator,pageable);
	}
    @Transactional
	public Boolean Add[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {
		
		Set<[=EntityClassName]> entitySet = [=relationValue.eName?lower_case].get[=ClassName]();

		if (!entitySet.contains([=InstanceName])) {
			[=relationValue.eName?lower_case].add[=ClassName]([=InstanceName]);
		} else {
			return false;
		//	throw new EntityExistsException("The [=ClassName?lower_case] already has the [=relationValue.eName?lower_case]");
		}
		_[=relationValue.eName?lower_case]Repository.save([=relationValue.eName?lower_case]);
		return true;
	}

	@Transactional
	public void Remove[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]) {

		[=relationValue.eName?lower_case].remove[=ClassName]([=InstanceName]);
		_[=relationValue.eName?lower_case]Repository.save([=relationValue.eName?lower_case]);
	}

	@Transactional
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
    </#list>
   </#if>
  </#list>
}
