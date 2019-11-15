package com.testg.tmep.domain.Postdetails;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.PostdetailsEntity;
import com.testg.tmep.domain.model.PostdetailsId;
import com.testg.tmep.domain.model.PostEntity;

public interface IPostdetailsManager {
    // CRUD Operations
    PostdetailsEntity Create(PostdetailsEntity postdetails);

    void Delete(PostdetailsEntity postdetails);

    PostdetailsEntity Update(PostdetailsEntity postdetails);

    PostdetailsEntity FindById(PostdetailsId postdetailsId);
	
    Page<PostdetailsEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //Post
    public PostEntity GetPost(PostdetailsId postdetailsId);
}
