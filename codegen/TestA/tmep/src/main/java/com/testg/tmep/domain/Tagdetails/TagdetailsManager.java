package com.testg.tmep.domain.Tagdetails;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.IRepository.ITagRepository;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.IRepository.ITagdetailsRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class TagdetailsManager implements ITagdetailsManager {

    @Autowired
    ITagdetailsRepository  _tagdetailsRepository;
    
    @Autowired
	ITagRepository  _tagRepository;
    
	public TagdetailsEntity Create(TagdetailsEntity tagdetails) {

		return _tagdetailsRepository.save(tagdetails);
	}

	public void Delete(TagdetailsEntity tagdetails) {

		_tagdetailsRepository.delete(tagdetails);	
	}

	public TagdetailsEntity Update(TagdetailsEntity tagdetails) {

		return _tagdetailsRepository.save(tagdetails);
	}

	public TagdetailsEntity FindById(TagId tagId) {
    	Optional<TagdetailsEntity> dbTagdetails= _tagdetailsRepository.findById(tagId);
		if(dbTagdetails.isPresent()) {
			TagdetailsEntity existingTagdetails = dbTagdetails.get();
		    return existingTagdetails;
		} else {
		    return null;
		}

	}

	public Page<TagdetailsEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _tagdetailsRepository.findAll(predicate,pageable);
	}
  
   //Tag
	public TagEntity GetTag(TagId tagId) {
		
		Optional<TagdetailsEntity> dbTagdetails= _tagdetailsRepository.findById(tagId);
		if(dbTagdetails.isPresent()) {
			TagdetailsEntity existingTagdetails = dbTagdetails.get();
		    return existingTagdetails.getTag();
		} else {
		    return null;
		}
	}
}
