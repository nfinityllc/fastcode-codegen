package [=PackageName].application.[=ClassName];

import [=PackageName].application.[=ClassName].Dto.*;
import [=PackageName].domain.[=ClassName].I[=ClassName]Manager;
import [=PackageName].domain.model.Q[=EntityClassName];
import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToMany" || relationValue.relation == "ManyToOne">
import [=PackageName].domain.[=relationValue.eName].[=relationValue.eName]Manager;
</#if>
<#if relationValue.relation == "ManyToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>

<#if relationValue.relation == "ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if relationKey == parent>
<#if parent?keep_after("-") == relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].application.[=relationValue.eName].[=relationValue.eName]AppService;
import [=PackageName].application.[=relationValue.eName].Dto.Find[=relationValue.eName]ByIdOutput;
</#if>
</#if>
</#list>
</#if>
</#list>
import [=CommonModulePackage].Search.*;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

import java.util.Date;
import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Validated
public class [=ClassName]AppService implements I[=ClassName]AppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private I[=ClassName]Manager _[=ClassName?uncap_first]Manager;
  
    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.relation !="OneToMany">
    @Autowired
	private [=relationValue.eName]Manager  _[=relationValue.eName?uncap_first]Manager;
    
    </#if>
    <#if relationValue.relation == "ManyToMany">
    <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if relationKey == parent>
    <#if parent?keep_after("-") == relationValue.eName>
    @Autowired 
	private [=relationValue.eName]AppService _[=relationValue.eName?uncap_first]AppService;
	
	</#if>
    </#if>
	</#list>
    </#if>
    </#list>
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private [=ClassName]Mapper mapper;

    @Transactional(propagation = Propagation.REQUIRED)
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
	
	@Transactional(propagation = Propagation.REQUIRED)
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
	
	@Transactional(propagation = Propagation.REQUIRED)
	public void Delete(Long id) {

		[=EntityClassName] existing = _[=ClassName?uncap_first]Manager.FindById(id) ; 

		_[=ClassName?uncap_first]Manager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
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
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
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
    <#if relationKey == parent>
    <#if parent?keep_after("-") == relationValue.eName>
    @Transactional(propagation = Propagation.REQUIRED)
    public Boolean Add[=relationValue.eName](Long [=ClassName?uncap_first]Id, Long [=relationValue.eName?uncap_first]Id) {
		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById([=relationValue.eName?uncap_first]Id);

		return _[=ClassName?uncap_first]Manager.Add[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);
	}
	
    @Transactional(propagation = Propagation.REQUIRED)
	public void Remove[=relationValue.eName](Long [=ClassName?uncap_first]Id, Long [=relationValue.eName?uncap_first]Id) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById([=relationValue.eName?uncap_first]Id);

		_[=ClassName?uncap_first]Manager.Remove[=relationValue.eName](found[=ClassName], found[=relationValue.eName]);
	}

	// ReST API Call => GET /[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]/3
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
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
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	public List<Get[=relationValue.eName]Output> Get[=relationValue.eName]List(Long [=ClassName?uncap_first]Id,SearchCriteria search,String operator,Pageable pageable) throws Exception{

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=ClassName?uncap_first]Id);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName] with a id=%s", [=ClassName?uncap_first]Id);
			return null;
		}
        check[=relationValue.eName]Properties(search.getFields());
        
		Page<[=relationValue.eName]Entity> found[=relationValue.eName] = _[=ClassName?uncap_first]Manager.Find[=relationValue.eName]([=ClassName?uncap_first]Id,search.getFields(),operator,pageable);
		List<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]List = found[=relationValue.eName].getContent();
		Iterator<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]Iterator = [=relationValue.eName?uncap_first]List.iterator();
		List<Get[=relationValue.eName]Output> output = new ArrayList<>();

		while ([=relationValue.eName?uncap_first]Iterator.hasNext()) {
			output.add(mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName?uncap_first]Iterator.next(), found[=ClassName]));
		}
		return output;
	}
	
	// ReST API Call => GET /[=ClassName?uncap_first]/1/available[=relationValue.eName]
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	public List<Find[=relationValue.eName]ByIdOutput> GetAvailable[=relationValue.eName]List(Long [=relationValue.joinColumn], String search, Pageable pageable) throws Exception{

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=relationValue.joinColumn]);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName] with a id=%s", [=relationValue.joinColumn]);
			return null;
		}
        
		Page<[=relationValue.eName]Entity> found[=relationValue.eName] = _[=ClassName?uncap_first]Manager.GetAvailable[=relationValue.eName]List([=relationValue.joinColumn],search,pageable);
		List<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]List = found[=relationValue.eName].getContent();
		Iterator<[=relationValue.eName]Entity> [=relationValue.eName?uncap_first]Iterator = [=relationValue.eName?uncap_first]List.iterator();
		List<Find[=relationValue.eName]ByIdOutput> output = new ArrayList<>();

		while ([=relationValue.eName?uncap_first]Iterator.hasNext()) {
			output.add(mapper.[=relationValue.eName]EntityToGetAvailable[=relationValue.eName]Output([=relationValue.eName?uncap_first]Iterator.next()));
		}
		return output;
	}
	
	public void check[=relationValue.eName]Properties(List<SearchFields> search) throws Exception
	{
		List<String> keysList = new ArrayList<String>();
		for (SearchFields obj : search) {
            keysList.add(obj.getFieldName());
        }
		_[=relationValue.eName?uncap_first]AppService.checkProperties(keysList);
	}
  </#if>
  </#if>
  </#list>
  </#if>
 </#list>

	public List<Find[=ClassName]ByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<[=EntityClassName]> found[=ClassName] = _[=ClassName?uncap_first]Manager.FindAll(Search(search), pageable);
		List<[=EntityClassName]> [=ClassName?uncap_first]List = found[=ClassName].getContent();
		Iterator<[=EntityClassName]> [=ClassName?uncap_first]Iterator = [=ClassName?uncap_first]List.iterator(); 
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();

		while ([=ClassName?uncap_first]Iterator.hasNext()) {
			output.add(mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?uncap_first]Iterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		Q[=EntityClassName] [=ClassName?uncap_first]= Q[=EntityClassName].[=EntityClassName?uncap_first];
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties([=ClassName?uncap_first], search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty([=ClassName?uncap_first],keysList,search.getValue(),search.getOperator());
			}
			else if(search.getType()==case3)
			{
				Map<String,SearchFields> map = new HashMap<>();
				for(SearchFields fieldDetails: search.getFields())
				{
					map.put(fieldDetails.getFieldName(),fieldDetails);
				}
				List<String> keysList = new ArrayList<String>(map.keySet());
				checkProperties(keysList);
				return searchKeyValuePair([=ClassName?uncap_first], map,search.getJoinColumn(),search.getJoinColumnValue());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(Q[=EntityClassName] [=ClassName?uncap_first],String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
		<#list SearchFields as fields>
			builder.or([=ClassName?uncap_first].[=fields].likeIgnoreCase("%"+ value + "%"));
		</#list>
		}
		else if(operator.equals("equals"))
		{
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(value));
		</#if> 
        </#list>
        	if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
        <#list Fields as key,value>
        <#if value.fieldType?lower_case == "boolean">
		    	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Boolean.parseBoolean(value)));
		</#if> 
        </#list>
       	 	}
			else if(StringUtils.isNumeric(value)){
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
        <#if value.isPrimaryKey==false>
				builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Long.valueOf(value)));
	    </#if>
		</#if> 
        </#list>
        	}
        	else if(SearchUtils.stringToDate(value)!=null) {
        <#list Fields as key,value>
        <#if value.fieldType?lower_case == "date">
	        	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(SearchUtils.stringToDate(value)));
        </#if> 
        </#list>
			}
		}

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
		
        <#list Fields?keys as key>
        <#if Fields[key].isPrimaryKey==false>
        <#if key_has_next>
		 list.get(i).replace("%20","").trim().equals("[=Fields[key].fieldName]") ||
		<#else>
		 list.get(i).replace("%20","").trim().equals("[=Fields[key].fieldName]")
		</#if>
        </#if> 
        </#list>
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(Q[=EntityClassName] [=ClassName?uncap_first],List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
            if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("contains"))
					builder.or([=ClassName?uncap_first].[=value.fieldName].likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(value));
			}
		<#elseif value.fieldType?lower_case == "boolean">
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Boolean.parseBoolean(value)));
			}
		<#elseif value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
        <#if value.isPrimaryKey==false>
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Long.valueOf(value)));
			}
		</#if>
		<#elseif value.fieldType?lower_case == "date">
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && SearchUtils.stringToDate(value)!=null)
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(SearchUtils.stringToDate(value)));
			}
        </#if>
        </#list>
        <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
		  if(list.get(i).replace("%20","").trim().equals("[=relationValue.joinColumn]")) {
			builder.or([=ClassName?uncap_first].[=relationValue.eName?uncap_first].id.eq(Long.parseLong(value)));
			}
		</#if>
		</#list>
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(Q[=EntityClassName] [=ClassName?uncap_first], Map<String,SearchFields> map,String joinColumn,Long joinColumnValue) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
            if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and([=ClassName?uncap_first].[=value.fieldName].likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(details.getValue().getSearchValue()));
			}
		<#elseif value.fieldType?lower_case == "boolean">
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Boolean.parseBoolean(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Boolean.parseBoolean(details.getValue().getSearchValue())));
			}
		<#elseif value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
        <#if value.isPrimaryKey==false>
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Long.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Long.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].between(Long.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(Long.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(Long.valueOf(details.getValue().getEndingValue())));
				}
			}
		</#if>
		<#elseif value.fieldType?lower_case == "date">
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   Date startDate= SearchUtils.stringToDate(details.getValue().getStartingValue());
				   Date endDate= SearchUtils.stringToDate(details.getValue().getEndingValue());
				   if(startDate!=null && endDate!=null)	 
					   builder.and([=ClassName?uncap_first].[=value.fieldName].between(startDate,endDate));
				   else if(endDate!=null)
					   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(endDate));
                   else if(startDate!=null)
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(startDate));  
                 }
                   
			}
	    </#if>
	    </#list>	
		}
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
		if(joinColumn != null && joinColumn.equals("[=relationValue.joinColumn]")) {
			builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].id.eq(joinColumnValue));
		}
		</#if>
		</#list>

		return builder;
	}
	
}


