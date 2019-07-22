package [=PackageName].ReSTControllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.*;
import javax.validation.Valid;

import [=PackageName].application.Email.Dto.CreateEmailOutput;
import [=PackageName].application.EmailVariable.Dto.FindEmailVariableByIdOutput;
import [=PackageName].application.EmailVariable.EmailVariableAppService;
import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import [=PackageName].application.Email.EmailAppService;
import [=PackageName].application.Email.Dto.CreateEmailInput;
import [=PackageName].mail.EmailService;

@RestController
@RequestMapping("/mail")
public class MailController {

	@Autowired
	private Environment env;
	@Autowired
	private EmailService emailService;

	@Autowired
	private EmailAppService emailAppService;
	@Autowired
	private EmailVariableAppService emailVariableAppService;

	private String replaceVariable(String input){
		Sort sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")});

		Pageable pageable = new OffsetBasedPageRequest(0, 100, sort);
		HashMap<String, String> map = new HashMap<>();

	List<FindEmailVariableByIdOutput> tags ;
	try
	{
		SearchCriteria searchCriteria = new SearchCriteria();
		tags = emailVariableAppService.Find(searchCriteria, pageable);
		for (FindEmailVariableByIdOutput tag: tags) {
			map.put("{{" + tag.getPropertyName() + "}}",tag.getDefaultValue());
		}
	}
	catch(Exception ex ){
		map.put("tag1","tag one");
		map.put("{{tag2}}","tag two");
	}

		final String regex ="\\{\\{\\w+\\}\\}";// "\\{\\{\\w+}}"; //"{{\\w+}}";

		final Matcher m = Pattern.compile(regex).matcher(input);

		final List<String> matches = new ArrayList<>();
		while (m.find()) {
			matches.add(m.group(0));
			input = input.replaceAll(Pattern.quote(m.group(0)),map.get(m.group(0)));
		}
		return input;
	}
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreateEmailOutput> sendEmail(@RequestBody @Valid CreateEmailInput email) throws IOException {
		if(email.getActive()!=null && email.getActive()) {
			String html = emailAppService.convertJsonToHtml(replaceVariable(email.getContentJson()));
			email.setContentHtml(html);
			if (email.getAttachmentpath() != null && !email.getAttachmentpath().isEmpty() )
				emailService.sendMessageWithAttachment(email.getTo(), email.getSubject(), email.getContentHtml(), email.getAttachmentpath());
			else
				emailService.sendSimpleMessage(email.getTo(), email.getSubject(), email.getContentHtml());
		}
		//return "Email sent successfully";
		//return new ResponseEntity(emailAppService.Create(email), HttpStatus.OK);
		return new ResponseEntity(email, HttpStatus.OK);
	} 


}
