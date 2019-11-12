package com.testg.tmep.application.Tagdetails;

import com.testg.tmep.application.Tagdetails.Dto.*;
import com.testg.tmep.domain.Tagdetails.ITagdetailsManager;
import com.testg.tmep.domain.model.QTagdetailsEntity;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.Tag.TagManager;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.CommonModule.Search.*;
import com.testg.tmep.CommonModule.logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

import java.util.Date;
import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;

import org.apache.commons.lang3.StringUtils;
import org.springframework.cache.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Validated
public class TagdetailsAppService implements ITagdetailsAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private ITagdetailsManager _tagdetailsManager;
	
    @Autowired
	private TagManager _tagManager;
    
	@Autowired
	private TagdetailsMapper mapper;
	
	@Autowired
	private LoggingHelper logHelper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreateTagdetailsOutput Create(CreateTagdetailsInput input) {

		TagdetailsEntity tagdetails = mapper.CreateTagdetailsInputToTagdetailsEntity(input);
        if(input.getTid()!=null && input.getTitle()!=null) {
			TagEntity foundTag = _tagManager.FindById(new TagId(input.getTid(), input.getTitle()));
			if(foundTag!=null) {
				tagdetails.setTag(foundTag);
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
		TagdetailsEntity createdTagdetails = _tagdetailsManager.Create(tagdetails);
		return mapper.TagdetailsEntityToCreateTagdetailsOutput(createdTagdetails);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Tagdetails", key = "#tagId")
	public UpdateTagdetailsOutput Update(TagId tagId , UpdateTagdetailsInput input) {

		TagdetailsEntity tagdetails = mapper.UpdateTagdetailsInputToTagdetailsEntity(input);
        if(input.getTid()!=null && input.getTitle()!=null) {
			TagEntity foundTag = _tagManager.FindById(new TagId(input.getTid(), input.getTitle()));
			if(foundTag!=null){
				tagdetails.setTag(foundTag);
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
		TagdetailsEntity updatedTagdetails = _tagdetailsManager.Update(tagdetails);
		
		return mapper.TagdetailsEntityToUpdateTagdetailsOutput(updatedTagdetails);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Tagdetails", key = "#tagId")
	public void Delete(TagId tagId) {

		TagdetailsEntity existing = _tagdetailsManager.FindById(tagId) ; 
		_tagdetailsManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Tagdetails", key = "#tagId")
	public FindTagdetailsByIdOutput FindById(TagId tagId) {

		TagdetailsEntity foundTagdetails = _tagdetailsManager.FindById(tagId);
		if (foundTagdetails == null)  
			return null ; 
 	   
 	    FindTagdetailsByIdOutput output=mapper.TagdetailsEntityToFindTagdetailsByIdOutput(foundTagdetails); 
		return output;
	}
    //Tag
	// ReST API Call - GET /tagdetails/1/tag
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    @Cacheable (value = "Tagdetails", key="#tagdetailsId")
	public GetTagOutput GetTag(TagId tagId) {

		TagdetailsEntity foundTagdetails = _tagdetailsManager.FindById(tagId);
		if (foundTagdetails == null) {
			logHelper.getLogger().error("There does not exist a tagdetails wth a id=%s", tagId);
			return null;
		}
		TagEntity re = _tagdetailsManager.GetTag(tagId);
		return mapper.TagEntityToGetTagOutput(re, foundTagdetails);
	}
	
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Tagdetails")
	public List<FindTagdetailsByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<TagdetailsEntity> foundTagdetails = _tagdetailsManager.FindAll(Search(search), pageable);
		List<TagdetailsEntity> tagdetailsList = foundTagdetails.getContent();
		Iterator<TagdetailsEntity> tagdetailsIterator = tagdetailsList.iterator(); 
		List<FindTagdetailsByIdOutput> output = new ArrayList<>();

		while (tagdetailsIterator.hasNext()) {
			output.add(mapper.TagdetailsEntityToFindTagdetailsByIdOutput(tagdetailsIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QTagdetailsEntity tagdetails= QTagdetailsEntity.tagdetailsEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(tagdetails, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(tagdetails,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(tagdetails, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QTagdetailsEntity tagdetails,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
        	builder.or(tagdetails.country.eq(value));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(tagdetails.country.eq(value));
        	if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
       	 	}
			else if(StringUtils.isNumeric(value)){
        	}
        	else if(SearchUtils.stringToDate(value)!=null) {
			}
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(
		list.get(i).replace("%20","").trim().equals("country") ||
		list.get(i).replace("%20","").trim().equals("tag") ||
		list.get(i).replace("%20","").trim().equals("tid") ||
		list.get(i).replace("%20","").trim().equals("title")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QTagdetailsEntity tagdetails,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("country")) {
				if(operator.equals("contains"))
					builder.or(tagdetails.country.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(tagdetails.country.eq(value));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QTagdetailsEntity tagdetails, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("country")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(tagdetails.country.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(tagdetails.country.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(tagdetails.country.ne(details.getValue().getSearchValue()));
			}
		}
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("tid")) {
		    builder.and(tagdetails.tag.tagid.eq(joinCol.getValue()));
		}
        if(joinCol != null && joinCol.getKey().equals("title")) {
		    builder.and(tagdetails.tag.title.eq(joinCol.getValue()));
		}
        }
		return builder;
	}
	
	public TagId parseTagdetailsKey(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		TagId tagId = new TagId();
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					//error
				}
			}
		}
		else {
			//error
		}
		
		tagId.setTid(keyMap.get("tid"));
		tagId.setTitle(keyMap.get("title"));
		return tagId;
		
	}	
	
    
	
}


