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
<#if relationValue.relation == "ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if parent?keep_after("-") == relationValue.eName>
import java.util.TreeMap;
import [=PackageName].application.[=relationValue.eName].[=relationValue.eName]AppService;
</#if>
</#list>
</#if>
</#list>
import [=PackageName].Utils.LoggingHelper;
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
	private I[=ClassName]Manager _[=ClassName?uncap_first]Manager;
  
    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.relation !="OneToMany">
    
    @Autowired
	private [=relationValue.eName]Manager  _[=relationValue.eName?uncap_first]Manager;
    <#elseif relationValue.relation == "OneToMany">
    @Autowired
    private I[=ClassName]Repository  _[=ClassName?uncap_first]Repository;
    </#if>
    <#if relationValue.relation == "ManyToMany">
    <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_after("-") == relationValue.eName>
    @Autowired 
	private [=relationValue.eName]AppService _[=relationValue.eName?uncap_first]AppService;
	</#if>
	</#list>
    </#if>
    </#list>
    
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private [=ClassName]Mapper mapper;


	public Create[=ClassName]Output Create(Create[=ClassName]Input input) {

		[=EntityClassName] [=ClassName?uncap_first] = mapper.Create[=ClassName]InputTo[=EntityClassName](input);
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
	  	if(input.get[=relationValue.joinColumn?cap_first]()!=null)
		{
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(input.get[=relationValue.joinColumn?cap_first]());
		if(found[=relationValue.eName]!=null)
		[=ClassName?uncap_first].set[=relationValue.eName](found[=relationValue.eName]);
		<#if relationValue.isJoinColumnOptional==false>
		else
		return null;
		</#if>
		}
		<#if relationValue.isJoinColumnOptional==false>
		else
		return null;
		</#if>
		
		</#if>
		</#list>
		
		[=EntityClassName] created[=ClassName] = _[=ClassName?uncap_first]Manager.Create([=ClassName?uncap_first]);
		return mapper.[=EntityClassName]ToCreate[=ClassName]Output(created[=ClassName]);
	}
	public Update[=ClassName]Output Update(Long id , Update[=ClassName]Input input) {

		[=EntityClassName] [=ClassName?uncap_first] = mapper.Update[=ClassName]InputTo[=EntityClassName](input);
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
	  	if(input.get[=relationValue.joinColumn?cap_first]()!=null)
		{
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(input.get[=relationValue.joinColumn?cap_first]());
		if(found[=relationValue.eName]!=null)
		[=ClassName?uncap_first].set[=relationValue.eName](found[=relationValue.eName]);
		<#if relationValue.isJoinColumnOptional==false>
		else
		return null;
		</#if>
		}
		<#if relationValue.isJoinColumnOptional==false>
		else
		return null;
		</#if>

		</#if>
		</#list>
		
		[=EntityClassName] updated[=ClassName] = _[=ClassName?uncap_first]Manager.Update([=ClassName?uncap_first]);
		return mapper.[=EntityClassName]ToUpdate[=ClassName]Output(updated[=ClassName]);
	}
	public void Delete(Long id) {

		[=EntityClassName] existing = _[=ClassName?uncap_first]Manager.FindById(id) ; 

		_[=ClassName?uncap_first]Manager.Delete(existing);

	}
	public Find[=ClassName]ByIdOutput FindById(Long id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById(id);

		if (found[=ClassName] == null)  
			return null ; 
 	   
 	   Find[=ClassName]ByIdOutput output=mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput(found[=ClassName]); 
		return output;

	}
	<#list Relationship as relationKey,relationValue>
	<#if relationValue.relation == "ManyToOne">
    //[=relationValue.eName]
	// ReST API Call - GET /[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]

	public Get[=relationValue.eName]Output Get[=relationValue.eName](Long [=ClassName?uncap_first]Id) {
		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?uncap_first] wth a id=%s", [=ClassName?uncap_first]Id);
			return null;
		}
		[=relationValue.eName]Entity re = _[=ClassName?uncap_first]Manager.Get[=relationValue.eName]([=ClassName?uncap_first]Id);
		return mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output(re, found[=ClassName]);
	}
    <#elseif relationValue.relation == "ManyToMany">
    //[=relationValue.eName]
    <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_after("-") == relationValue.eName>
    public Boolean Add[=relationValue.eName](Long [=ClassName?uncap_first]Id, Long [=relationValue.eName?uncap_first]Id) {
		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById([=relationValue.eName?uncap_first]Id);

		return _[=ClassName?uncap_first]Manager.Add[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);
	}

	public void Remove[=relationValue.eName](Long [=ClassName?uncap_first]Id, Long [=relationValue.eName?uncap_first]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById([=relationValue.eName?uncap_first]Id);

		_[=ClassName?uncap_first]Manager.Remove[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);
	}

	// ReST API Call => GET /[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]/3

	public Get[=relationValue.eName]Output Get[=relationValue.eName](Long [=ClassName?uncap_first]Id, Long [=relationValue.eName?uncap_first]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist [=ClassName?uncap_first] with a id=%s", [=ClassName?uncap_first]Id);
			return null;
		}
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById([=relationValue.eName?uncap_first]Id);
		if (found[=relationValue.eName] == null) {
			logHelper.getLogger().error("There does not exist [=relationValue.eName?uncap_first] with a name=%s", found[=relationValue.eName]);
			return null;
		}

		[=relationValue.eName]Entity pe = _[=ClassName?uncap_first]Manager.Get[=relationValue.eName]([=ClassName?uncap_first]Id, [=relationValue.eName?uncap_first]Id);
		return mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output(pe, found[=ClassName]);
	}


	// ReST API Call => GET /[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]

	public List<Get[=relationValue.eName]Output> Get[=relationValue.eName]List(Long [=ClassName?uncap_first]Id,String search,Pageable pageable) throws Exception{

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName] with a id=%s", [=ClassName?uncap_first]Id);
			return null;
		}

        Map<String,String> sortedSearchMap= sortMapAndSet[=relationValue.eName]Values(buildSearchMap(search));

		Page<[=relationValue.eName]Entity> found[=relationValue.eName] = _[=ClassName?uncap_first]Manager.Find[=relationValue.eName]([=ClassName?uncap_first]Id,<#list relationValue.fDetails as fValue><#if fValue.fieldType?lower_case == "string">sortedSearchMap.get("[=fValue.fieldName]"),</#if></#list>pageable);
		List<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]List = found[=relationValue.eName].getContent();
		Iterator<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]Iterator = [=relationValue.eName?uncap_first]List.iterator();
		List<Get[=relationValue.eName]Output> output = new ArrayList<>();

		while ([=relationValue.eName?uncap_first]Iterator.hasNext()) {
			output.add(mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName?uncap_first]Iterator.next(), found[=ClassName]));
		}
		return output;

	}
	
	public Map<String,String> sortMapAndSet[=relationValue.eName]Values(Map<String,String> map) throws Exception
	{
		List<String> keysList = new ArrayList<String> (map.keySet());
		_[=relationValue.eName?uncap_first]AppService.checkProperties(keysList);
		
		Map<String,String> sortedMap = new TreeMap<>(map); 
		Map<String,String> fieldsMap=new HashMap<>();
		<#list relationValue.fDetails as fValue>
		<#if fValue.fieldType?lower_case == "string">
		fieldsMap.put("[=fValue.fieldName]", null);
		</#if>
		</#list>
		for (Map.Entry<String,String> sortedEntry : sortedMap.entrySet()) {
			for (Map.Entry<String,String> fieldEntry : sortedMap.entrySet()) {
				if(sortedEntry.getKey()==fieldEntry.getKey())
				{
					fieldsMap.put(sortedEntry.getKey().toString(),"%"+ sortedEntry.getValue().toUpperCase() + "%");
				}
			}
		}
		return fieldsMap;
	}
	
  </#if>
  </#list>
  </#if>
 </#list>
 <#list Relationship as relationKey,relationValue>
    <#if relationValue.relation == "ManyToMany">
    public Map<String,String> buildSearchMap(String search) throws Exception
	{
		String[] values = null;
		String[] words = null;
		Map<String, String> map = new HashMap<>();
		if(search != null) {
			if((search.contains(";"))) {
				if(search.contains(","))
				{
				words = search.split(",");
				if(words[0].contains(";")) {
					for (String s: words) {
						values = s.replace("%20","").trim().split(";");
						map.put(values[0], values[1]);
					}
				}
				}
				else
				{
					words = search.split(";");
					map.put(words[0], words[1]);
				}
			}

		}
		return map;
	}
	<#break>
    </#if>
</#list>
 
	public List<Find[=ClassName]ByIdOutput> Find(String search, Pageable pageable) throws Exception  {

		Page<[=EntityClassName]> found[=ClassName] = _[=ClassName?uncap_first]Manager.FindAll(Search(search), pageable);
		List<[=EntityClassName]> [=ClassName?uncap_first]List = found[=ClassName].getContent();
		Iterator<[=EntityClassName]> [=ClassName?uncap_first]Iterator = [=ClassName?uncap_first]List.iterator(); 
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();

		while ([=ClassName?uncap_first]Iterator.hasNext()) {
			output.add(mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?uncap_first]Iterator.next()));
		}
		return output;
	}

	public BooleanBuilder Search(String search) throws Exception {
		String[] values = null;
		String[] words = null;
		Map map = new HashMap<>();
		BooleanBuilder builder = new BooleanBuilder();
		Q[=EntityClassName] [=ClassName?uncap_first]= Q[=EntityClassName].[=EntityClassName?uncap_first];
		if(search != null) {
			if(!(search.contains(",")) && !(search.contains(";"))) {
				return searchAllProperties([=ClassName?uncap_first],search);
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
					return searchKeyValuePair([=ClassName?uncap_first], map);
				}
				else {
				String value= words[0];
				List<String> list =new ArrayList(Arrays.asList(words));
				list.remove(0);
				checkProperties(list);
				return searchSpecificProperty([=ClassName?uncap_first], list,value);
			}
		}
	}
	return null;
	}

	public BooleanBuilder searchAllProperties(Q[=EntityClassName] [=ClassName?uncap_first],String search) {
		BooleanBuilder builder = new BooleanBuilder();
		<#list SearchFields as fields>
		builder.or([=ClassName?uncap_first].[=fields].likeIgnoreCase("%"+ search + "%"));
		</#list>
	
		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
		 list.get(i).replace("%20","").trim().equals("[=relationValue.joinColumn]") ||
		</#if>
		</#list>	
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

	public BooleanBuilder searchSpecificProperty(Q[=EntityClassName] [=ClassName?uncap_first],List<String> list,String value)  {
		BooleanBuilder builder = new BooleanBuilder();
		for (int i = 0; i < list.size(); i++) {
		
		<#list SearchFields as fields>
        if(list.get(i).replace("%20","").trim().equals("[=fields]")) {
		builder.or([=ClassName?uncap_first].[=fields].likeIgnoreCase("%"+ value + "%"));
		 }
		 
		</#list>
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
		  if(list.get(i).replace("%20","").trim().equals("[=relationValue.joinColumn]")) {
			builder.or([=ClassName?uncap_first].[=relationValue.eName?uncap_first].id.eq(Long.parseLong(value.toString())));
			}
		</#if>
		</#list>	
			
		}
		return builder;
	}
	public BooleanBuilder searchKeyValuePair(Q[=EntityClassName] [=ClassName?uncap_first], Map map) {
		BooleanBuilder builder = new BooleanBuilder();
		Iterator iterator = map.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry pair2 = (Map.Entry) iterator.next();
		 <#list SearchFields as fields>
            if(pair2.getKey().toString().replace("%20","").trim().equals("[=fields]")) {
			builder.and([=ClassName?uncap_first].[=fields].likeIgnoreCase("%"+ pair2.getValue() + "%"));
			}
      
		</#list>
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
			if(pair2.getKey().toString().replace("%20","").trim().equals("[=relationValue.joinColumn]")) {
			builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].id.eq(Long.parseLong(pair2.getValue().toString())));
			}
		</#if>
		</#list>		
		}
		return builder;
	}

}


