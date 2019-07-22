package [=PackageName].ReSTControllers;

import java.io.IOException;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.nfinity.fastcode.application.Email.EmailAppService;

@RestController
@RequestMapping("/htmlEmail")
public class HtmlEmailController {

	 @Autowired
	 private EmailAppService emailAppService;

	 @RequestMapping(method = RequestMethod.POST)
	 public ResponseEntity<String> JsonToHtml(@RequestBody @Valid String json) throws IOException
	 {
		 if(json != null)
			 return new ResponseEntity(emailAppService.convertJsonToHtml(json), HttpStatus.OK);
		 else
			 return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
			 
	 }
}
