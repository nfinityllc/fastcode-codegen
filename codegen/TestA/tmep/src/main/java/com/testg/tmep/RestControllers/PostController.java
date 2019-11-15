package com.testg.tmep.RestControllers;

import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import com.testg.tmep.domain.model.PostId;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.CommonModule.Search.SearchUtils;
import com.testg.tmep.CommonModule.application.OffsetBasedPageRequest;
import com.testg.tmep.CommonModule.domain.EmptyJsonResponse;
import com.testg.tmep.application.Post.PostAppService;
import com.testg.tmep.application.Post.Dto.*;
import com.testg.tmep.application.Postdetails.PostdetailsAppService;
import com.testg.tmep.application.Postdetails.Dto.FindPostdetailsByIdOutput;
import java.util.List;
import java.util.Map;
import com.testg.tmep.CommonModule.logging.LoggingHelper;

@RestController
@RequestMapping("/post")
public class PostController {

	@Autowired
	private PostAppService _postAppService;
    
    @Autowired
	private PostdetailsAppService  _postdetailsAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreatePostOutput> Create(@RequestBody @Valid CreatePostInput post) {
		CreatePostOutput output=_postAppService.Create(post);
		
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete post ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	PostId postid =_postAppService.parsePostKey(id);
	if(postid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindPostByIdOutput output = _postAppService.FindById(postid);
	if (output == null) {
		logHelper.getLogger().error("There does not exist a post with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a post with a id=%s", id));
	}
	 _postAppService.Delete(postid);
    }
	
	// ------------ Update post ------------
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdatePostOutput> Update(@PathVariable String id, @RequestBody @Valid UpdatePostInput post) {
		PostId postid =_postAppService.parsePostKey(id);
		if(postid == null)
		{
			logHelper.getLogger().error("Invalid id=%s", id);
			throw new EntityNotFoundException(
					String.format("Invalid id=%s", id));
		}
		FindPostByIdOutput currentPost = _postAppService.FindById(postid);
			
		if (currentPost == null) {
			logHelper.getLogger().error("Unable to update. Post with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_postAppService.Update(postid,post), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindPostByIdOutput> FindById(@PathVariable String id) {
	PostId postid =_postAppService.parsePostKey(id);
	if(postid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindPostByIdOutput output = _postAppService.FindById(postid);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
    
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_postAppService.Find(searchCriteria,Pageable));
	}
    
	@RequestMapping(value = "/{id}/postdetails", method = RequestMethod.GET)
	public ResponseEntity GetPostdetails(@PathVariable String id, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_postAppService.parsePostdetailsJoinColumn(id);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<FindPostdetailsByIdOutput> output = _postdetailsAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
 


}

