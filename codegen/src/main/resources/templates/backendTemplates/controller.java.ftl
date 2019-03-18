package com.nfinity.fastcode.ReSTControllers;

import javax.persistence.EntityExistsException;
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

import com.nfinity.fastcode.application.OffsetBasedPageRequest;
import com.nfinity.fastcode.application.Authorization.${PackageName}.${ClassName}AppService;
import com.nfinity.fastcode.application.Authorization.${PackageName}.${ClassName}Mapper;
import com.nfinity.fastcode.application.Authorization.${PackageName}.Dto.*;
import com.nfinity.fastcode.logging.LoggingHelper;

@RestController
@RequestMapping("/${ApiPath}")
public class ${ClassName}Controller {

	@Autowired
	private ${ClassName}AppService _appService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;

	@Autowired
	private ${ClassName}Mapper _mapper;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create${ClassName}Output> Create(@RequestBody @Valid Create${ClassName}Input ${ClassName?lower_case}) {
		Find${ClassName}ByNameOutput found${ClassName} = _appService.FindByName(${ClassName?lower_case}.getName());
		if (found${ClassName} != null) {
			logHelper.getLogger().error("There already exists a ${ClassName?lower_case} with a name=%s", ${ClassName?lower_case}.getName());
			throw new EntityExistsException(
					String.format("There already exists a ${ClassName?lower_case} with name=%s", ${ClassName?lower_case}.getName()));
		}
		return new ResponseEntity(_appService.Create(${ClassName?lower_case}), HttpStatus.OK);
	}

	// ------------ Delete ${ClassName?lower_case} ------------
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
		Find${ClassName}ByIdOutput output = _appService.FindById(Long.valueOf(id));

		if (output == null) {
			logHelper.getLogger().error("There does not exist a ${ClassName?lower_case} with a id=%s", id);
			throw new EntityNotFoundException(
					String.format("There does not exist a ${ClassName?lower_case} with a id=%s", id));
		}
		_appService.Delete(Long.valueOf(id));
	}
	// ------------ Update ${ClassName?lower_case} ------------

	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update${ClassName}Output> Update(@PathVariable String id, @RequestBody @Valid Update${ClassName}Input ${ClassName?lower_case}) {
		Find${ClassName}ByIdOutput current${ClassName} = _appService.FindById(Long.valueOf(id));
		if (current${ClassName} == null) {
			logHelper.getLogger().error("Unable to update. ${ClassName} with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(_appService.Update(Long.valueOf(id),${ClassName?lower_case}), HttpStatus.OK);
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find${ClassName}ByIdOutput> FindById(@PathVariable String id) {

		Find${ClassName}ByIdOutput output = _appService.FindById(Long.valueOf(id));

		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value = "search", required=false) String search,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);

		return ResponseEntity.ok(_appService.Find(search,Pageable));
	}



}

