package com.testg.tmep.domain.Tagdetails;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.model.TagEntity;

public interface ITagdetailsManager {
    // CRUD Operations
    TagdetailsEntity Create(TagdetailsEntity tagdetails);

    void Delete(TagdetailsEntity tagdetails);

    TagdetailsEntity Update(TagdetailsEntity tagdetails);

    TagdetailsEntity FindById(TagId tagId);
	
    Page<TagdetailsEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //Tag
    public TagEntity GetTag(TagId tagId);
}
