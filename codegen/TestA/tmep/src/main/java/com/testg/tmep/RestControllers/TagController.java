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
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.CommonModule.Search.SearchUtils;
import com.testg.tmep.CommonModule.application.OffsetBasedPageRequest;
import com.testg.tmep.CommonModule.domain.EmptyJsonResponse;
import com.testg.tmep.application.Tag.TagAppService;
import com.testg.tmep.application.Tag.Dto.*;
import com.testg.tmep.application.Tagdetails.TagdetailsAppService;
import java.util.List;
import java.util.Map;
import com.testg.tmep.CommonModule.logging.LoggingHelper;

@RestController
@RequestMapping("/tag")
public class TagController {

	@Autowired
	private TagAppService _tagAppService;
    
    @Autowired
	private TagdetailsAppService  _tagdetailsAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreateTagOutput> Create(@RequestBody @Valid CreateTagInput tag) {
		CreateTagOutput output=_tagAppService.Create(tag);
		
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete tag ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	TagId tagid =_tagAppService.parseTagKey(id);
	if(tagid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindTagByIdOutput output = _tagAppService.FindById(tagid);
	if (output == null) {
		logHelper.getLogger().error("There does not exist a tag with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a tag with a id=%s", id));
	}
	 _tagAppService.Delete(tagid);
    }
	
	// ------------ Update tag ------------
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdateTagOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateTagInput tag) {
		TagId tagid =_tagAppService.parseTagKey(id);
		if(tagid == null)
		{
			logHelper.getLogger().error("Invalid id=%s", id);
			throw new EntityNotFoundException(
					String.format("Invalid id=%s", id));
		}
		FindTagByIdOutput currentTag = _tagAppService.FindById(tagid);
			
		if (currentTag == null) {
			logHelper.getLogger().error("Unable to update. Tag with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_tagAppService.Update(tagid,tag), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindTagByIdOutput> FindById(@PathVariable String id) {
	TagId tagid =_tagAppService.parseTagKey(id);
	if(tagid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindTagByIdOutput output = _tagAppService.FindById(tagid);
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
		
		return ResponseEntity.ok(_tagAppService.Find(searchCriteria,Pageable));
	}
	@RequestMapping(value = "/{id}/tagdetails", method = RequestMethod.GET)
	public ResponseEntity<GetTagdetailsOutput> GetTagdetails(@PathVariable String id) {
	TagId tagid =_tagAppService.parseTagKey(id);
	if(tagid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	GetTagdetailsOutput output= _tagAppService.GetTagdetails(tagid);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}


}

