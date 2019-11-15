package com.testg.tmep.application.Postdetails;

import com.testg.tmep.application.Postdetails.Dto.*;
import com.testg.tmep.domain.Postdetails.IPostdetailsManager;
import com.testg.tmep.domain.model.QPostdetailsEntity;
import com.testg.tmep.domain.model.PostdetailsEntity;
import com.testg.tmep.domain.model.PostdetailsId;
import com.testg.tmep.domain.Post.PostManager;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.model.PostId;
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
public class PostdetailsAppService implements IPostdetailsAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private IPostdetailsManager _postdetailsManager;
	
    @Autowired
	private PostManager _postManager;
    
	@Autowired
	private PostdetailsMapper mapper;
	
	@Autowired
	private LoggingHelper logHelper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreatePostdetailsOutput Create(CreatePostdetailsInput input) {

		PostdetailsEntity postdetails = mapper.CreatePostdetailsInputToPostdetailsEntity(input);
        if(input.getPid()!=null && input.getTitle()!=null) {
			PostEntity foundPost = _postManager.FindById(new PostId(input.getPid(), input.getTitle()));
			if(foundPost!=null) {
				postdetails.setPost(foundPost);
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
		PostdetailsEntity createdPostdetails = _postdetailsManager.Create(postdetails);
		return mapper.PostdetailsEntityToCreatePostdetailsOutput(createdPostdetails);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Postdetails", key = "#postdetailsId")
	public UpdatePostdetailsOutput Update(PostdetailsId postdetailsId , UpdatePostdetailsInput input) {

		PostdetailsEntity postdetails = mapper.UpdatePostdetailsInputToPostdetailsEntity(input);
        if(input.getPid()!=null && input.getTitle()!=null) {
			PostEntity foundPost = _postManager.FindById(new PostId(input.getPid(), input.getTitle()));
			if(foundPost!=null){
				postdetails.setPost(foundPost);
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
		PostdetailsEntity updatedPostdetails = _postdetailsManager.Update(postdetails);
		
		return mapper.PostdetailsEntityToUpdatePostdetailsOutput(updatedPostdetails);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Postdetails", key = "#postdetailsId")
	public void Delete(PostdetailsId postdetailsId) {

		PostdetailsEntity existing = _postdetailsManager.FindById(postdetailsId) ; 
		_postdetailsManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Postdetails", key = "#postdetailsId")
	public FindPostdetailsByIdOutput FindById(PostdetailsId postdetailsId) {

		PostdetailsEntity foundPostdetails = _postdetailsManager.FindById(postdetailsId);
		if (foundPostdetails == null)  
			return null ; 
 	   
 	    FindPostdetailsByIdOutput output=mapper.PostdetailsEntityToFindPostdetailsByIdOutput(foundPostdetails); 
		return output;
	}
    //Post
	// ReST API Call - GET /postdetails/1/post
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    @Cacheable (value = "Postdetails", key="#postdetailsId")
	public GetPostOutput GetPost(PostdetailsId postdetailsId) {

		PostdetailsEntity foundPostdetails = _postdetailsManager.FindById(postdetailsId);
		if (foundPostdetails == null) {
			logHelper.getLogger().error("There does not exist a postdetails wth a id=%s", postdetailsId);
			return null;
		}
		PostEntity re = _postdetailsManager.GetPost(postdetailsId);
		return mapper.PostEntityToGetPostOutput(re, foundPostdetails);
	}
	
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Postdetails")
	public List<FindPostdetailsByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<PostdetailsEntity> foundPostdetails = _postdetailsManager.FindAll(Search(search), pageable);
		List<PostdetailsEntity> postdetailsList = foundPostdetails.getContent();
		Iterator<PostdetailsEntity> postdetailsIterator = postdetailsList.iterator(); 
		List<FindPostdetailsByIdOutput> output = new ArrayList<>();

		while (postdetailsIterator.hasNext()) {
			output.add(mapper.PostdetailsEntityToFindPostdetailsByIdOutput(postdetailsIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QPostdetailsEntity postdetails= QPostdetailsEntity.postdetailsEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(postdetails, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(postdetails,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(postdetails, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QPostdetailsEntity postdetails,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
        	builder.or(postdetails.country.eq(value));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(postdetails.country.eq(value));
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
		list.get(i).replace("%20","").trim().equals("title") ||
		list.get(i).replace("%20","").trim().equals("country") ||
		list.get(i).replace("%20","").trim().equals("pdid") ||
		list.get(i).replace("%20","").trim().equals("pid") ||
		list.get(i).replace("%20","").trim().equals("post")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QPostdetailsEntity postdetails,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("country")) {
				if(operator.equals("contains"))
					builder.or(postdetails.country.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(postdetails.country.eq(value));
			}
		  if(list.get(i).replace("%20","").trim().equals("pid")) {
			builder.or(postdetails.post.postid.eq(value));
			}
		  if(list.get(i).replace("%20","").trim().equals("title")) {
			builder.or(postdetails.post.title.eq(value));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QPostdetailsEntity postdetails, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("country")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(postdetails.country.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(postdetails.country.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(postdetails.country.ne(details.getValue().getSearchValue()));
			}
		}
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("pid")) {
		    builder.and(postdetails.post.postid.eq(joinCol.getValue()));
		}
        if(joinCol != null && joinCol.getKey().equals("title")) {
		    builder.and(postdetails.post.title.eq(joinCol.getValue()));
		}
        }
		return builder;
	}
	
	public PostdetailsId parsePostdetailsKey(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		PostdetailsId postdetailsId = new PostdetailsId();
		
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
		
		postdetailsId.setPdid(keyMap.get("pdid"));
		postdetailsId.setPid(keyMap.get("pid"));
		return postdetailsId;
		
	}	
	
    
	
}


