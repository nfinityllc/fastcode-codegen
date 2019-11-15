package com.testg.tmep.application.Tagdetails;

import java.util.List;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.TagId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.application.Tagdetails.Dto.*;

@Service
public interface ITagdetailsAppService {

	CreateTagdetailsOutput Create(CreateTagdetailsInput tagdetails);

    void Delete(TagId tagId);

    UpdateTagdetailsOutput Update(TagId tagId, UpdateTagdetailsInput input);

    FindTagdetailsByIdOutput FindById(TagId tagId);

    List<FindTagdetailsByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	public TagId parseTagdetailsKey(String keysString);
    
    //Tag
    GetTagOutput GetTag(TagId tagId);
}
