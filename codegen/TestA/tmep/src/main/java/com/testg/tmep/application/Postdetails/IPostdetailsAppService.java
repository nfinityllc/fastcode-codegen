package com.testg.tmep.application.Postdetails;

import java.util.List;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.PostdetailsId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.application.Postdetails.Dto.*;

@Service
public interface IPostdetailsAppService {

	CreatePostdetailsOutput Create(CreatePostdetailsInput postdetails);

    void Delete(PostdetailsId postdetailsId);

    UpdatePostdetailsOutput Update(PostdetailsId postdetailsId, UpdatePostdetailsInput input);

    FindPostdetailsByIdOutput FindById(PostdetailsId postdetailsId);

    List<FindPostdetailsByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	public PostdetailsId parsePostdetailsKey(String keysString);
    
    //Post
    GetPostOutput GetPost(PostdetailsId postdetailsId);
}
