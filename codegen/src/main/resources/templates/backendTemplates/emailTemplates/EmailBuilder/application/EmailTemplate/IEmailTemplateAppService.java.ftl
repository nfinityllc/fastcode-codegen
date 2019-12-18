package [=PackageName].application.EmailTemplate;

import java.util.List;

import javax.validation.constraints.Positive;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.EmailTemplate.Dto.*;

@Service
public interface IEmailTemplateAppService {

	CreateEmailTemplateOutput Create(CreateEmailTemplateInput email);

    void Delete(@Positive(message ="EmailId should be a positive value")Long eid);

    UpdateEmailTemplateOutput Update(@Positive(message ="EmailId should be a positive value") Long eid,UpdateEmailTemplateInput email);

    FindEmailTemplateByIdOutput FindById(@Positive(message ="EmailId should be a positive value")Long eid);

    FindEmailTemplateByNameOutput FindByName(String name);
    
    List<FindEmailTemplateByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	
}
