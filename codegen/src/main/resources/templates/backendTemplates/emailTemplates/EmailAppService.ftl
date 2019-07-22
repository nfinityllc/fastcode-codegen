package [=PackageName].application.Email;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import [=PackageName].domain.Email.IEmailManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import [=PackageName].application.Email.Dto.*;
import [=PackageName].domain.model.EmailEntity;
import [=PackageName].domain.Email.EmailManager;
import [=PackageName].domain.Email.QEmailEntity;
import [=CommonModulePackage].Search.*;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

@Service
public class EmailAppService implements IEmailAppService {

	@Autowired
	private IEmailManager _emailManager;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private EmailMapper emailMapper;

	@Transactional(propagation = Propagation.REQUIRED)
	public CreateEmailOutput Create(CreateEmailInput email) {

		EmailEntity re = emailMapper.CreateEmailInputToEmailEntity(email);
		EmailEntity createdEmail = _emailManager.Create(re);

		return emailMapper.EmailEntityToCreateEmailOutput(createdEmail);
	}

	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Email", key = "#eid")
	public void Delete(Long eid) {
		EmailEntity existing = _emailManager.FindById(eid);
		_emailManager.Delete(existing);
	}

	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="Email", key = "#eid")
	public UpdateEmailOutput Update(Long eid, UpdateEmailInput email) {

		EmailEntity ue = emailMapper.UpdateEmailInputToEmailEntity(email);
		EmailEntity updatedEmail = _emailManager.Update(ue);

		return emailMapper.EmailEntityToUpdateEmailOutput(updatedEmail);

	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Email", key = "#eid")
	public FindEmailByIdOutput FindById(Long eid) {
		EmailEntity foundEmail = _emailManager.FindById(eid);

		if (foundEmail == null) {
			logHelper.getLogger().error("There does not exist a email wth a id=%s", eid);
			return null;
		}

		return emailMapper.EmailEntityToFindEmailByIdOutput(foundEmail);
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Email", key = "#name")
	public FindEmailByNameOutput FindByName(String name) {
		EmailEntity foundEmail = _emailManager.FindByName(name);
		if (foundEmail == null) {
			logHelper.getLogger().error("There does not exist a email wth a name=%s", name);
			return null;
		}
		return emailMapper.EmailEntityToFindEmailByNameOutput(foundEmail);
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "Email")
	public List<FindEmailByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception {
		Page<EmailEntity> foundEmail = _emailManager.FindAll(Search(search),pageable);
		List<EmailEntity> emailList = foundEmail.getContent();

		Iterator<EmailEntity> emailIterator = emailList.iterator();
		List<FindEmailByIdOutput> output = new ArrayList<>();

		while (emailIterator.hasNext()) {
			output.add(emailMapper.EmailEntityToFindEmailByIdOutput(emailIterator.next()));    
		}

		return output;
	}

	BooleanBuilder searchAllProperties(QEmailEntity email,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
			builder.or(email.templateName.likeIgnoreCase("%"+ value + "%"));
			builder.or(email.category.likeIgnoreCase("%"+ value + "%"));
			builder.or(email.to.likeIgnoreCase("%"+ value + "%"));
			builder.or(email.cc.likeIgnoreCase("%"+ value + "%"));
			builder.or(email.bcc.likeIgnoreCase("%"+ value + "%"));
			builder.or(email.subject.likeIgnoreCase("%"+ value + "%"));
		}
		else if(operator.equals("equals")) {
			builder.or(email.templateName.eq(value));
			builder.or(email.category.eq(value));
			builder.or(email.to.eq(value));
			builder.or(email.cc.eq(value));
			builder.or(email.bcc.eq(value));
			builder.or(email.subject.eq(value));
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception {
		for (int i = 0; i < list.size(); i++) {
			if(!((list.get(i).replace("%20","").trim().equals("templateName")) 
					|| (list.get(i).replace("%20","").trim().equals("category"))
					|| (list.get(i).replace("%20","").trim().equals("to"))
					|| (list.get(i).replace("%20","").trim().equals("cc"))
					|| (list.get(i).replace("%20","").trim().equals("bcc"))
					|| (list.get(i).replace("%20","").trim().equals("subject")))) {

				// Throw an exception
				throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
			}
		}
	}

	BooleanBuilder searchSpecificProperty(QEmailEntity email,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();

		for (int i = 0; i < list.size(); i++) {

			if(list.get(i).replace("%20","").trim().equals("templateName")) {
				if(operator.equals("contains")) {
					builder.or(email.templateName.likeIgnoreCase("%"+ value + "%"));
				}
				else if(operator.equals("equals")) {
					builder.or(email.templateName.eq(value));
				}
			}
			if(list.get(i).replace("%20","").trim().equals("category")) {
				if(operator.equals("contains")) {
					builder.or(email.category.likeIgnoreCase("%"+ value + "%"));
				}
				else if(operator.equals("equals")) {
					builder.or(email.category.eq(value));
				}
			}
			if(list.get(i).replace("%20","").trim().equals("to")) {
				if(operator.equals("contains")) {
					builder.or(email.to.likeIgnoreCase("%"+ value + "%"));
				}
				else if(operator.equals("equals")) {
					builder.or(email.to.eq(value));
				}
			}
			if(list.get(i).replace("%20","").trim().equals("cc")) {
				if(operator.equals("contains")) {
					builder.or(email.cc.likeIgnoreCase("%"+ value + "%"));
				}
				else if(operator.equals("equals")) {
					builder.or(email.cc.eq(value));
				}
			}
			if(list.get(i).replace("%20","").trim().equals("bcc")) {
				if(operator.equals("contains")) {
					builder.or(email.bcc.likeIgnoreCase("%"+ value + "%"));
				}
				else if(operator.equals("equals")) {
					builder.or(email.bcc.eq(value));
				}
			}
			if(list.get(i).replace("%20","").trim().equals("subject")) {
				if(operator.equals("contains")) {
					builder.or(email.subject.likeIgnoreCase("%"+ value + "%"));
				}
				else if(operator.equals("equals")) {
					builder.or(email.subject.eq(value));
				}
			}
		}
		return builder;
	}

	BooleanBuilder searchKeyValuePair(QEmailEntity email, Map<String,SearchFields> map) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
			if(details.getKey().replace("%20","").trim().equals("templateName")) {
				if(details.getValue().getOperator().equals("contains")) {
					builder.and(email.templateName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				}
				else if(details.getValue().getOperator().equals("equals")) {
					builder.and(email.templateName.eq(details.getValue().getSearchValue()));
				}
				else if(details.getValue().getOperator().equals("notEqual")) {
					builder.and(email.templateName.ne(details.getValue().getSearchValue()));
				}
			}
			if(details.getKey().replace("%20","").trim().equals("category")) {
				if(details.getValue().getOperator().equals("contains")) {
					builder.and(email.category.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				}
				else if(details.getValue().getOperator().equals("equals")) {
					builder.and(email.category.eq(details.getValue().getSearchValue()));
				}
				else if(details.getValue().getOperator().equals("notEqual")) {
					builder.and(email.category.ne(details.getValue().getSearchValue()));
				}
			}
			if(details.getKey().replace("%20","").trim().equals("to")) {
				if(details.getValue().getOperator().equals("contains")) {
					builder.and(email.to.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				}
				else if(details.getValue().getOperator().equals("equals")) {
					builder.and(email.to.eq(details.getValue().getSearchValue()));
				}
				else if(details.getValue().getOperator().equals("notEqual")) {
					builder.and(email.to.ne(details.getValue().getSearchValue()));
				}
			}
			if(details.getKey().replace("%20","").trim().equals("cc")) {
				if(details.getValue().getOperator().equals("contains")) {
					builder.and(email.cc.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				}
				else if(details.getValue().getOperator().equals("equals")) {
					builder.and(email.cc.eq(details.getValue().getSearchValue()));
				}
				else if(details.getValue().getOperator().equals("notEqual")) {
					builder.and(email.cc.ne(details.getValue().getSearchValue()));
				}
			}
			if(details.getKey().replace("%20","").trim().equals("bcc")) {
				if(details.getValue().getOperator().equals("contains")) {
					builder.and(email.bcc.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				}
				else if(details.getValue().getOperator().equals("equals")) {
					builder.and(email.bcc.eq(details.getValue().getSearchValue()));
				}
				else if(details.getValue().getOperator().equals("notEqual")) {
					builder.and(email.bcc.ne(details.getValue().getSearchValue()));
				}
			}
			if(details.getKey().replace("%20","").trim().equals("subject")) {
				if(details.getValue().getOperator().equals("contains")) {
					builder.and(email.subject.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				}
				else if(details.getValue().getOperator().equals("equals")) {
					builder.and(email.subject.eq(details.getValue().getSearchValue()));
				}
				else if(details.getValue().getOperator().equals("notEqual")) {
					builder.and(email.subject.ne(details.getValue().getSearchValue()));
				}
			}
			
		}
		return builder;
	}

	public ClientHttpRequestFactory getClientHttpRequestFactory() {
		int timeout = 5000;
		HttpComponentsClientHttpRequestFactory clientHttpRequestFactory
		= new HttpComponentsClientHttpRequestFactory();
		clientHttpRequestFactory.setConnectTimeout(timeout);
		return clientHttpRequestFactory;
	}

	public String convertJsonToHtml(String jsonString) throws IOException{
		String html= " ";
		ObjectMapper mapper = new ObjectMapper();
		JsonNode root = mapper.readTree(jsonString);
		ClientHttpRequestFactory requestFactory = getClientHttpRequestFactory();
		RestTemplate restTemplate = new RestTemplate(requestFactory);

		HttpHeaders headers = new HttpHeaders();
		headers.set("Content-Type", "application/json");
		headers.set("X-Api-Key", "t7HdQfZjGp6R96fOV4P8v18ggf6LLTQZ1puUI2tz");
		String emailServerUrl ="http://localhost:3001/" ;// "https://ngb-api.wlocalhost.org/v1"
		HttpEntity<JsonNode> request = new HttpEntity<>(root,headers);
		html = restTemplate.postForObject(emailServerUrl, request, String.class);
		JsonNode output = mapper.readTree(html);
		logHelper.getLogger().error("Error",output.get("errors").asText());
		html=output.get("html").asText();
		
		return html;
	}

}
