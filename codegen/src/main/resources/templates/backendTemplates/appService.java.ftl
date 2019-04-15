package [=PackageName].application.[=ClassName];

import [=PackageName].application.[=ClassName].Dto.*;
import [=PackageName].domain.[=ClassName].I[=ClassName]Manager;
import [=PackageName].domain.model.Q[=EntityClassName];
import [=PackageName].domain.model.[=EntityClassName];
import [=PackageName].domain.IRepository.I[=ClassName]Repository;
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].domain.[=relationValue.eName].[=relationValue.eName]Manager;
</#if>
</#list>
import [=PackageName].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

import java.util.Set;
import java.util.Map;
import java.util.List;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;

@Service
@Validated
public class [=ClassName]AppService implements I[=ClassName]AppService {

	@Autowired
	private I[=ClassName]Manager _[=ClassName?lower_case]Manager;
  
    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    
    @Autowired
	private [=relationValue.eName]Manager  _[=relationValue.eName?lower_case]Manager;
    </#if>
    </#list>
    
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private [=ClassName]Mapper mapper;


	public Create[=ClassName]Output Create(Create[=ClassName]Input input) {

		[=EntityClassName] [=ClassName?lower_case] = mapper.Create[=ClassName]InputTo[=EntityClassName](input);
		[=EntityClassName] created[=ClassName] = _[=ClassName?lower_case]Manager.Create([=ClassName?lower_case]);
		return mapper.[=EntityClassName]ToCreate[=ClassName]Output(created[=ClassName]);
	}
	public Update[=ClassName]Output Update(Long id , Update[=ClassName]Input input) {

		[=EntityClassName] [=ClassName?lower_case] = mapper.Update[=ClassName]InputTo[=EntityClassName](input);
		[=EntityClassName] updated[=ClassName] = _[=ClassName?lower_case]Manager.Update([=ClassName?lower_case]);
		return mapper.[=EntityClassName]ToUpdate[=ClassName]Output(updated[=ClassName]);
	}
	public void Delete(Long id) {

		[=EntityClassName] existing = _[=ClassName?lower_case]Manager.FindById(id) ; 

		_[=ClassName?lower_case]Manager.Delete(existing);

	}
	public Find[=ClassName]ByIdOutput FindById(Long id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById(id);

		if (found[=ClassName] == null)  
			return null ; 
 			
		return mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput(found[=ClassName]);

	}
	public Find[=ClassName]ByNameOutput FindByName(String name) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindByName(name);

		if (found[=ClassName] == null) 
			return null ; 
 			
		return mapper.[=EntityClassName]ToFind[=ClassName]ByNameOutput(found[=ClassName]);

	}
	<#list Relationship as relationKey,relationValue>
	<#if relationValue.relation == "ManyToOne">
   //[=relationValue.eName]
   // ReST API Call - POST /[=ClassName?lower_case]/1/roles/4

	public void Add[=relationValue.eName](Long [=ClassName?lower_case]Id,Long [=relationValue.eName?lower_case]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?lower_case]Manager.FindById([=relationValue.eName?lower_case]Id);
		_[=ClassName?lower_case]Manager.Add[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);

	}

	// ReST API Call - DELETE /[=ClassName?lower_case]/1/[=relationValue.eName?lower_case]
	public void Remove[=relationValue.eName](Long [=ClassName?lower_case]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		_[=ClassName?lower_case]Manager.Remove[=relationValue.eName](found[=ClassName]);

	}

	// ReST API Call - GET /[=ClassName?lower_case]/1/[=relationValue.eName?lower_case]

	public Get[=relationValue.eName]Output Get[=relationValue.eName](Long [=ClassName?lower_case]Id) {
		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?lower_case]r wth a id=%s", [=ClassName?lower_case]Id);
			return null;
		}
		[=relationValue.eName]Entity re = _[=ClassName?lower_case]Manager.Get[=relationValue.eName]([=ClassName?lower_case]Id);
		return mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output(re, found[=ClassName]);
	}
  <#elseif relationValue.relation == "ManyToMany">
    //[=relationValue.eName]
    <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_before("-") == relationValue.eName>
    public Boolean Add[=relationValue.eName](Long [=ClassName?lower_case]Id, Long [=relationValue.eName?lower_case]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?lower_case]Manager.FindById([=relationValue.eName?lower_case]Id);

		return _[=ClassName?lower_case]Manager.Add[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);

	}

	public void Remove[=relationValue.eName](Long [=ClassName?lower_case]Id, Long [=relationValue.eName?lower_case]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?lower_case]Manager.FindById([=relationValue.eName?lower_case]Id);

		_[=ClassName?lower_case]Manager.Remove[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);

	}

	// ReST API Call => GET /[=ClassName?lower_case]/1/[=relationValue.eName?lower_case]/3

	public Get[=relationValue.eName]Output Get[=relationValue.eName](Long [=ClassName?lower_case]Id, Long [=relationValue.eName?lower_case]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist [=ClassName?lower_case] with a id=%s", [=ClassName?lower_case]Id);
			return null;

		}
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?lower_case]Manager.FindById([=relationValue.eName?lower_case]Id);
		if (found[=relationValue.eName] == null) {
			logHelper.getLogger().error("There does not exist [=relationValue.eName?lower_case] with a name=%s", found[=relationValue.eName]);
			return null;
		}

		[=relationValue.eName]Entity pe = _[=ClassName?lower_case]Manager.Get[=relationValue.eName]([=ClassName?lower_case]Id, [=relationValue.eName?lower_case]Id);
		return mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output(pe, found[=ClassName]);
	}


	// ReST API Call => GET /[=ClassName?lower_case]/1/[=relationValue.eName?lower_case]

	public List<Get[=relationValue.eName]Output> Get[=relationValue.eName]s(Long [=ClassName?lower_case]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?lower_case]Manager.FindById([=ClassName?lower_case]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName] with a id=%s", [=ClassName?lower_case]Id);
			return null;
		}

		Set<[=relationValue.eName]Entity> pe = _[=ClassName?lower_case]Manager.Get[=relationValue.eName]s(found[=ClassName]);
		Iterator<[=relationValue.eName]Entity> [=relationValue.eName?lower_case]Iterator = pe.iterator();
		List<Get[=relationValue.eName]Output> output = new ArrayList<>();

		while ([=relationValue.eName?lower_case]Iterator.hasNext()) {
			output.add(mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName?lower_case]Iterator.next(), found[=ClassName]));
		}
		return output;
	}
    
     </#if>
  </#list>
     </#if>
  
  </#list>
	
	
	public List<Find[=ClassName]ByIdOutput> Find(String search, Pageable pageable) throws Exception  {

		Page<[=EntityClassName]> found[=ClassName] = _[=ClassName?lower_case]Manager.FindAll(Search(search), pageable);
		List<[=EntityClassName]> [=ClassName?lower_case]List = found[=ClassName].getContent();
		Iterator<[=EntityClassName]> [=ClassName?lower_case]Iterator = [=ClassName?lower_case]List.iterator(); 
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();

		while ([=ClassName?lower_case]Iterator.hasNext()) {
			output.add(mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?lower_case]Iterator.next()));
		}
		return output;

	}

	public BooleanBuilder Search(String search) throws Exception {
		String[] values = null;
		String[] words = null;
		Map map = new HashMap<>();
		BooleanBuilder builder = new BooleanBuilder();
		Q[=EntityClassName] [=ClassName?lower_case]= Q[=EntityClassName].[=ClassName?lower_case]Entity;
		if(search != null) {
			if(!(search.contains(",")) && !(search.contains(";"))) {
				return searchAllProperties([=ClassName?lower_case],search);
			} 
			else {
				words = search.split(",");
				if(words[0].contains(";")) {
					for (String s: words) {
						values = s.replace("%20","").trim().split(";");
						map.put(values[0], values[1]);
					}
					List<String> keysList = new ArrayList<String> (map.keySet());
					checkProperties(keysList);
					return searchKeyValuePair([=ClassName?lower_case], map);
				}
				else {
				String value= words[0];
				List<String> list =new ArrayList(Arrays.asList(words));
				list.remove(0);
				checkProperties(list);
				return searchSpecificProperty([=ClassName?lower_case], list,value);
			}
		}
	}
	return null;
	}

	public BooleanBuilder searchAllProperties(Q[=EntityClassName] [=ClassName?lower_case],String search) {
		BooleanBuilder builder = new BooleanBuilder();
		<#list SearchFields as fields>
		builder.or([=ClassName?lower_case].[=fields].likeIgnoreCase("%"+ search + "%"));
		</#list>
		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(
		<#list SearchFields as fields>
		<#if fields_has_next>
         list.get(i).replace("%20","").trim().equals("[=fields]") ||
		<#else>
		 list.get(i).replace("%20","").trim().equals("[=fields]")
		</#if>
		</#list>
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}

	public BooleanBuilder searchSpecificProperty(Q[=EntityClassName] [=ClassName?lower_case],List<String> list,String value)  {
		BooleanBuilder builder = new BooleanBuilder();
		for (int i = 0; i < list.size(); i++) {
		
		<#list SearchFields as fields>
        if(list.get(i).replace("%20","").trim().equals("[=fields]")) {
		builder.or([=ClassName?lower_case].[=fields].likeIgnoreCase("%"+ value + "%"));
		 }
		 		
		</#list>
			
		}
		return builder;
	}
	public BooleanBuilder searchKeyValuePair(Q[=EntityClassName] [=ClassName?lower_case], Map map) {
		BooleanBuilder builder = new BooleanBuilder();
		Iterator iterator = map.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry pair2 = (Map.Entry) iterator.next();
			
		 <#list SearchFields as fields>
          if(pair2.getKey().toString().replace("%20","").trim().equals("[=fields]")) {
			builder.and([=ClassName?lower_case].[=fields].likeIgnoreCase("%"+ pair2.getValue() + "%"));
			}
      
		</#list>
		
		}
		return builder;
	}

}


