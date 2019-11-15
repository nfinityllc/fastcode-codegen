package com.testg.tmep.domain.Post;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.model.PostId;
import com.testg.tmep.domain.model.PostdetailsEntity;

public interface IPostManager {
    // CRUD Operations
    PostEntity Create(PostEntity post);

    void Delete(PostEntity post);

    PostEntity Update(PostEntity post);

    PostEntity FindById(PostId postId);
	
    Page<PostEntity> FindAll(Predicate predicate, Pageable pageable);
}
