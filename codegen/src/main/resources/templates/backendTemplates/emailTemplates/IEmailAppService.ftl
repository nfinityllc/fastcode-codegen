package [=PackageName].application.Email;

import java.util.List;

import javax.validation.constraints.Positive;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Email.Dto.*;

@Service
public interface IEmailAppService {

	CreateEmailOutput Create(CreateEmailInput email);

    void Delete(@Positive(message ="EmailId should be a positive value")Long eid);

    UpdateEmailOutput Update(@Positive(message ="EmailId should be a positive value") Long eid,UpdateEmailInput email);

    FindEmailByIdOutput FindById(@Positive(message ="EmailId should be a positive value")Long eid);

    FindEmailByNameOutput FindByName(String name);
    
    List<FindEmailByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	
}
