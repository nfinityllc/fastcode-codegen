package [=PackageName].ReSTControllers;

import java.io.IOException;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=PackageName].application.Email.EmailAppService;
import [=PackageName].application.Email.Dto.*;
import [=PackageName].mail.EmailService;
import [=CommonModulePackage].logging.LoggingHelper;

@RestController
@RequestMapping("/email")
public class EmailController {

	    @Autowired
	    private EmailAppService emailAppService;

	    @Autowired
	    private LoggingHelper logHelper;

	    @Autowired
	    private Environment env;
	    
	    @Autowired
		private EmailService emailService;

	//@PreAuthorize("hasAnyAuthority('EMAILSENTITY_CREATE')")
	@RequestMapping(method = RequestMethod.POST)
	    public ResponseEntity<CreateEmailOutput> Create(@RequestBody @Valid CreateEmailInput email) throws IOException {
	    	FindEmailByNameOutput foundEmail = emailAppService.FindByName(email.getTemplateName());

			if (foundEmail != null) {
				logHelper.getLogger().error("There already exists a email with a name=%s", email.getTemplateName());
				throw new EntityExistsException(
						String.format("There already exists a user with email address=%s", email.getTemplateName()));
			}
			if(email.getContentJson() != null)
			{
	        String html= emailAppService.convertJsonToHtml(email.getContentJson());
			email.setContentHtml(html);
			//emailService.sendSimpleMessage(email.getTo(), email.getSubject(),html);
			
			}
	        return new ResponseEntity(emailAppService.Create(email), HttpStatus.CREATED);
	    }

	    // ------------ Delete an email ------------
	//	@PreAuthorize("hasAnyAuthority('EMAILSENTITY_DELETE')")
	    @ResponseStatus(value = HttpStatus.NO_CONTENT)
	    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	    public void Delete(@PathVariable String id) {
	    	  FindEmailByIdOutput eo = emailAppService.FindById(Long.valueOf(id));

		        if (eo == null) {
		        	logHelper.getLogger().error("There does not exist a email wth a id=%s", id);
				throw new EntityNotFoundException(
						String.format("There does not exist a email wth a id=%s", id));
			}
	        emailAppService.Delete(Long.valueOf(id));
	    }
	    // ------------ Update an email ------------

	//	@PreAuthorize("hasAnyAuthority('EMAILSENTITY_UPDATE')")
	    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	    public ResponseEntity<UpdateEmailOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateEmailInput email) {
	        FindEmailByIdOutput currentEmail = emailAppService.FindById(Long.valueOf(id));
	        if (currentEmail == null) {
	            logHelper.getLogger().error("Unable to update. Email with id {} not found.", id);
	            return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	        }
	        return new ResponseEntity(emailAppService.Update(Long.valueOf(id), email), HttpStatus.OK);
	    }

		//@PreAuthorize("hasAnyAuthority('EMAILSENTITY_READ')")
	    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
	    public ResponseEntity<FindEmailByIdOutput> FindById(@PathVariable String id) {

	        FindEmailByIdOutput eo = emailAppService.FindById(Long.valueOf(id));

	        if (eo == null) {
	            return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	        }
	        return new ResponseEntity(eo, HttpStatus.OK);
	    }

		//@PreAuthorize("hasAnyAuthority('EMAILSENTITY_READ')")
	    @RequestMapping(method = RequestMethod.GET)
	    public ResponseEntity Find(@RequestParam(value = "search", required=false) String search,@RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
	        if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
	        if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
	        if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

	        Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
	        SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
	      
	        return ResponseEntity.ok(emailAppService.Find(searchCriteria,Pageable));
	    }
	
}
