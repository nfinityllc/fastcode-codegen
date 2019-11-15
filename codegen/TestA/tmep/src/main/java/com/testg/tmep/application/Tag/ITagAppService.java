package com.testg.tmep.application.Tag;

import java.util.List;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.TagId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.application.Tag.Dto.*;

@Service
public interface ITagAppService {

	CreateTagOutput Create(CreateTagInput tag);

    void Delete(TagId tagId);

    UpdateTagOutput Update(TagId tagId, UpdateTagInput input);

    FindTagByIdOutput FindById(TagId tagId);

    List<FindTagByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	public TagId parseTagKey(String keysString);
    
    //Tagdetails
    GetTagdetailsOutput GetTagdetails(TagId tagId);
}
