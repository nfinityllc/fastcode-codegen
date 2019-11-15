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
import com.testg.tmep.domain.model.PostdetailsId;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.CommonModule.Search.SearchUtils;
import com.testg.tmep.CommonModule.application.OffsetBasedPageRequest;
import com.testg.tmep.CommonModule.domain.EmptyJsonResponse;
import com.testg.tmep.application.Postdetails.PostdetailsAppService;
import com.testg.tmep.application.Postdetails.Dto.*;
import com.testg.tmep.application.Post.PostAppService;
import java.util.List;
import java.util.Map;
import com.testg.tmep.CommonModule.logging.LoggingHelper;

@RestController
@RequestMapping("/postdetails")
public class PostdetailsController {

	@Autowired
	private PostdetailsAppService _postdetailsAppService;
    
    @Autowired
	private PostAppService  _postAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreatePostdetailsOutput> Create(@RequestBody @Valid CreatePostdetailsInput postdetails) {
		CreatePostdetailsOutput output=_postdetailsAppService.Create(postdetails);
		
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete postdetails ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	PostdetailsId postdetailsid =_postdetailsAppService.parsePostdetailsKey(id);
	if(postdetailsid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindPostdetailsByIdOutput output = _postdetailsAppService.FindById(postdetailsid);
	if (output == null) {
		logHelper.getLogger().error("There does not exist a postdetails with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a postdetails with a id=%s", id));
	}
	 _postdetailsAppService.Delete(postdetailsid);
    }
	
	// ------------ Update postdetails ------------
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdatePostdetailsOutput> Update(@PathVariable String id, @RequestBody @Valid UpdatePostdetailsInput postdetails) {
		PostdetailsId postdetailsid =_postdetailsAppService.parsePostdetailsKey(id);
		if(postdetailsid == null)
		{
			logHelper.getLogger().error("Invalid id=%s", id);
			throw new EntityNotFoundException(
					String.format("Invalid id=%s", id));
		}
		FindPostdetailsByIdOutput currentPostdetails = _postdetailsAppService.FindById(postdetailsid);
			
		if (currentPostdetails == null) {
			logHelper.getLogger().error("Unable to update. Postdetails with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_postdetailsAppService.Update(postdetailsid,postdetails), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindPostdetailsByIdOutput> FindById(@PathVariable String id) {
	PostdetailsId postdetailsid =_postdetailsAppService.parsePostdetailsKey(id);
	if(postdetailsid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindPostdetailsByIdOutput output = _postdetailsAppService.FindById(postdetailsid);
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
		
		return ResponseEntity.ok(_postdetailsAppService.Find(searchCriteria,Pageable));
	}
	@RequestMapping(value = "/{id}/post", method = RequestMethod.GET)
	public ResponseEntity<GetPostOutput> GetPost(@PathVariable String id) {
	PostdetailsId postdetailsid =_postdetailsAppService.parsePostdetailsKey(id);
	if(postdetailsid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	GetPostOutput output= _postdetailsAppService.GetPost(postdetailsid);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}


}

