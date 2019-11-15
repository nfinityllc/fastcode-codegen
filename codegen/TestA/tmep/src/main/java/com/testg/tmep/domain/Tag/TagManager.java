package com.testg.tmep.domain.Tag;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.domain.model.TagId;
import com.testg.tmep.domain.IRepository.ITagdetailsRepository;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.domain.IRepository.ITagRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class TagManager implements ITagManager {

    @Autowired
    ITagRepository  _tagRepository;
    
    @Autowired
	ITagdetailsRepository  _tagdetailsRepository;
    
	public TagEntity Create(TagEntity tag) {

		return _tagRepository.save(tag);
	}

	public void Delete(TagEntity tag) {

		_tagRepository.delete(tag);	
	}

	public TagEntity Update(TagEntity tag) {

		return _tagRepository.save(tag);
	}

	public TagEntity FindById(TagId tagId) {
    	Optional<TagEntity> dbTag= _tagRepository.findById(tagId);
		if(dbTag.isPresent()) {
			TagEntity existingTag = dbTag.get();
		    return existingTag;
		} else {
		    return null;
		}

	}

	public Page<TagEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _tagRepository.findAll(predicate,pageable);
	}
  
   //Tagdetails
	public TagdetailsEntity GetTagdetails(TagId tagId) {
		
		Optional<TagEntity> dbTag= _tagRepository.findById(tagId);
		if(dbTag.isPresent()) {
			TagEntity existingTag = dbTag.get();
		    return existingTag.getTagdetails();
		} else {
		    return null;
		}
	}
}
