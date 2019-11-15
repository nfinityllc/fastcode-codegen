package com.testg.tmep.application.Post;

import java.util.List;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.PostId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import com.testg.tmep.CommonModule.Search.SearchCriteria;
import com.testg.tmep.application.Post.Dto.*;

@Service
public interface IPostAppService {

	CreatePostOutput Create(CreatePostInput post);

    void Delete(PostId postId);

    UpdatePostOutput Update(PostId postId, UpdatePostInput input);

    FindPostByIdOutput FindById(PostId postId);

    List<FindPostByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

	public PostId parsePostKey(String keysString);
}
