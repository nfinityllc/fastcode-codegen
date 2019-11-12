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
import com.testg.tmep.application.Tagdetails.TagdetailsAppService;
import com.testg.tmep.application.Tagdetails.Dto.*;
import com.testg.tmep.application.Tag.TagAppService;
import java.util.List;
import java.util.Map;
import com.testg.tmep.CommonModule.logging.LoggingHelper;

@RestController
@RequestMapping("/tagdetails")
public class TagdetailsController {

	@Autowired
	private TagdetailsAppService _tagdetailsAppService;
    
    @Autowired
	private TagAppService  _tagAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreateTagdetailsOutput> Create(@RequestBody @Valid CreateTagdetailsInput tagdetails) {
		CreateTagdetailsOutput output=_tagdetailsAppService.Create(tagdetails);
		
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete tagdetails ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	TagId tagid =_tagdetailsAppService.parseTagdetailsKey(id);
	if(tagid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindTagdetailsByIdOutput output = _tagdetailsAppService.FindById(tagid);
	if (output == null) {
		logHelper.getLogger().error("There does not exist a tagdetails with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a tagdetails with a id=%s", id));
	}
	 _tagdetailsAppService.Delete(tagid);
    }
	
	// ------------ Update tagdetails ------------
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdateTagdetailsOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateTagdetailsInput tagdetails) {
		TagId tagid =_tagdetailsAppService.parseTagdetailsKey(id);
		if(tagid == null)
		{
			logHelper.getLogger().error("Invalid id=%s", id);
			throw new EntityNotFoundException(
					String.format("Invalid id=%s", id));
		}
		FindTagdetailsByIdOutput currentTagdetails = _tagdetailsAppService.FindById(tagid);
			
		if (currentTagdetails == null) {
			logHelper.getLogger().error("Unable to update. Tagdetails with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_tagdetailsAppService.Update(tagid,tagdetails), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindTagdetailsByIdOutput> FindById(@PathVariable String id) {
	TagId tagid =_tagdetailsAppService.parseTagdetailsKey(id);
	if(tagid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	FindTagdetailsByIdOutput output = _tagdetailsAppService.FindById(tagid);
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
		
		return ResponseEntity.ok(_tagdetailsAppService.Find(searchCriteria,Pageable));
	}
	@RequestMapping(value = "/{id}/tag", method = RequestMethod.GET)
	public ResponseEntity<GetTagOutput> GetTag(@PathVariable String id) {
	TagId tagid =_tagdetailsAppService.parseTagdetailsKey(id);
	if(tagid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	GetTagOutput output= _tagdetailsAppService.GetTag(tagid);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}


}

