package com.testg.tmep.application.Tag;

import com.testg.tmep.application.Tag.Dto.*;
import com.testg.tmep.domain.Tag.ITagManager;
import com.testg.tmep.domain.model.QTagEntity;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.Tagdetails.TagdetailsManager;
import com.testg.tmep.domain.model.TagdetailsEntity;
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
public class TagAppService implements ITagAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private ITagManager _tagManager;
	
    @Autowired
	private TagdetailsManager _tagdetailsManager;
    
	@Autowired
	private TagMapper mapper;
	
	@Autowired
	private LoggingHelper logHelper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreateTagOutput Create(CreateTagInput input) {

		TagEntity tag = mapper.CreateTagInputToTagEntity(input);
		TagEntity createdTag = _tagManager.Create(tag);
		return mapper.TagEntityToCreateTagOutput(createdTag);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Tag", key = "#tagId")
	public UpdateTagOutput Update(TagId tagId , UpdateTagInput input) {

		TagEntity tag = mapper.UpdateTagInputToTagEntity(input);
		TagEntity updatedTag = _tagManager.Update(tag);
		
		return mapper.TagEntityToUpdateTagOutput(updatedTag);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Tag", key = "#tagId")
	public void Delete(TagId tagId) {

		TagEntity existing = _tagManager.FindById(tagId) ; 
		_tagManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Tag", key = "#tagId")
	public FindTagByIdOutput FindById(TagId tagId) {

		TagEntity foundTag = _tagManager.FindById(tagId);
		if (foundTag == null)  
			return null ; 
 	   
 	    FindTagByIdOutput output=mapper.TagEntityToFindTagByIdOutput(foundTag); 
		return output;
	}
    //Tagdetails
	// ReST API Call - GET /tag/1/tagdetails
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    @Cacheable (value = "Tag", key="#tagId")
	public GetTagdetailsOutput GetTagdetails(TagId tagId) {

		TagEntity foundTag = _tagManager.FindById(tagId);
		if (foundTag == null) {
			logHelper.getLogger().error("There does not exist a tag wth a id=%s", tagId);
			return null;
		}
		TagdetailsEntity re = _tagManager.GetTagdetails(tagId);
		return mapper.TagdetailsEntityToGetTagdetailsOutput(re, foundTag);
	}
	
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Tag")
	public List<FindTagByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<TagEntity> foundTag = _tagManager.FindAll(Search(search), pageable);
		List<TagEntity> tagList = foundTag.getContent();
		Iterator<TagEntity> tagIterator = tagList.iterator(); 
		List<FindTagByIdOutput> output = new ArrayList<>();

		while (tagIterator.hasNext()) {
			output.add(mapper.TagEntityToFindTagByIdOutput(tagIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QTagEntity tag= QTagEntity.tagEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(tag, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(tag,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(tag, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QTagEntity tag,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
        	builder.or(tag.description.eq(value));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(tag.description.eq(value));
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
		list.get(i).replace("%20","").trim().equals("description") ||
		list.get(i).replace("%20","").trim().equals("tagdetails") ||
		list.get(i).replace("%20","").trim().equals("tagid") ||
		list.get(i).replace("%20","").trim().equals("title")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QTagEntity tag,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("description")) {
				if(operator.equals("contains"))
					builder.or(tag.description.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(tag.description.eq(value));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QTagEntity tag, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("description")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(tag.description.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(tag.description.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(tag.description.ne(details.getValue().getSearchValue()));
			}
		}
		return builder;
	}
	
	public TagId parseTagKey(String keysString) {
		
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
		
		tagId.setTagid(keyMap.get("tagid"));
		tagId.setTitle(keyMap.get("title"));
		return tagId;
		
	}	
	
    
	
}


