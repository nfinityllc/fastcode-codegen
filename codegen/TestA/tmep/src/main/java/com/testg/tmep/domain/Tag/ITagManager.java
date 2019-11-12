package com.testg.tmep.domain.Tag;

import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.model.TagdetailsEntity;

public interface ITagManager {
    // CRUD Operations
    TagEntity Create(TagEntity tag);

    void Delete(TagEntity tag);

    TagEntity Update(TagEntity tag);

    TagEntity FindById(TagId tagId);
	
    Page<TagEntity> FindAll(Predicate predicate, Pageable pageable);
   
    //Tagdetails
    public TagdetailsEntity GetTagdetails(TagId tagId);
}
