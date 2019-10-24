package [=PackageName].RestControllers;

import java.io.IOException;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import [=PackageName].application.EmailTemplate.Dto.CreateEmailTemplateOutput;
import [=PackageName].application.EmailTemplate.Dto.CreateEmailTemplateInput;
import [=PackageName].application.mail.EmailService;

@RestController
@RequestMapping("/mail")
public class MailController {

    @Autowired
	private EmailService emailService;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreateEmailTemplateOutput> sendEmail(@RequestBody @Valid CreateEmailTemplateInput email) throws IOException {
		
		emailService.sendEmail(email);
		//return "Email sent successfully";
		//return new ResponseEntity(emailTemplateAppService.Create(email), HttpStatus.OK);
		return new ResponseEntity(email, HttpStatus.OK);
	} 
}
