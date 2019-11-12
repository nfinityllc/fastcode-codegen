package com.testg.tmep.application.Post;

import com.testg.tmep.application.Post.Dto.*;
import com.testg.tmep.domain.Post.IPostManager;
import com.testg.tmep.domain.model.QPostEntity;
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
public class PostAppService implements IPostAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private IPostManager _postManager;
	
	@Autowired
	private PostMapper mapper;
	
	@Autowired
	private LoggingHelper logHelper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreatePostOutput Create(CreatePostInput input) {

		PostEntity post = mapper.CreatePostInputToPostEntity(input);
		PostEntity createdPost = _postManager.Create(post);
		return mapper.PostEntityToCreatePostOutput(createdPost);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Post", key = "#postId")
	public UpdatePostOutput Update(PostId postId , UpdatePostInput input) {

		PostEntity post = mapper.UpdatePostInputToPostEntity(input);
		PostEntity updatedPost = _postManager.Update(post);
		
		return mapper.PostEntityToUpdatePostOutput(updatedPost);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Post", key = "#postId")
	public void Delete(PostId postId) {

		PostEntity existing = _postManager.FindById(postId) ; 
		_postManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Post", key = "#postId")
	public FindPostByIdOutput FindById(PostId postId) {

		PostEntity foundPost = _postManager.FindById(postId);
		if (foundPost == null)  
			return null ; 
 	   
 	    FindPostByIdOutput output=mapper.PostEntityToFindPostByIdOutput(foundPost); 
		return output;
	}
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Post")
	public List<FindPostByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<PostEntity> foundPost = _postManager.FindAll(Search(search), pageable);
		List<PostEntity> postList = foundPost.getContent();
		Iterator<PostEntity> postIterator = postList.iterator(); 
		List<FindPostByIdOutput> output = new ArrayList<>();

		while (postIterator.hasNext()) {
			output.add(mapper.PostEntityToFindPostByIdOutput(postIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QPostEntity post= QPostEntity.postEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(post, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(post,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(post, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QPostEntity post,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
        	builder.or(post.description.eq(value));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(post.description.eq(value));
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
		list.get(i).replace("%20","").trim().equals("postdetails") ||
		list.get(i).replace("%20","").trim().equals("postid") ||
		list.get(i).replace("%20","").trim().equals("title")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QPostEntity post,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("description")) {
				if(operator.equals("contains"))
					builder.or(post.description.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(post.description.eq(value));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QPostEntity post, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("description")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(post.description.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(post.description.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(post.description.ne(details.getValue().getSearchValue()));
			}
		}
		return builder;
	}
	
	public PostId parsePostKey(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		PostId postId = new PostId();
		
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
		
		postId.setPostid(keyMap.get("postid"));
		postId.setTitle(keyMap.get("title"));
		return postId;
		
	}	
	
	
	public Map<String,String> parsePostdetailsJoinColumn(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					return null;
				}
			}
		}
		else {
			return null;
		}
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("pid", keyMap.get("postid"));
		joinColumnMap.put("title", keyMap.get("title"));
		return joinColumnMap;
		
	}
	
    
	
}


