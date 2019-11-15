package com.testg.tmep.domain.Postdetails;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import com.testg.tmep.domain.model.PostdetailsEntity;
import com.testg.tmep.domain.model.PostdetailsId;
import com.testg.tmep.domain.IRepository.IPostRepository;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.IRepository.IPostdetailsRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class PostdetailsManager implements IPostdetailsManager {

    @Autowired
    IPostdetailsRepository  _postdetailsRepository;
    
    @Autowired
	IPostRepository  _postRepository;
    
	public PostdetailsEntity Create(PostdetailsEntity postdetails) {

		return _postdetailsRepository.save(postdetails);
	}

	public void Delete(PostdetailsEntity postdetails) {

		_postdetailsRepository.delete(postdetails);	
	}

	public PostdetailsEntity Update(PostdetailsEntity postdetails) {

		return _postdetailsRepository.save(postdetails);
	}

	public PostdetailsEntity FindById(PostdetailsId postdetailsId) {
    	Optional<PostdetailsEntity> dbPostdetails= _postdetailsRepository.findById(postdetailsId);
		if(dbPostdetails.isPresent()) {
			PostdetailsEntity existingPostdetails = dbPostdetails.get();
		    return existingPostdetails;
		} else {
		    return null;
		}

	}

	public Page<PostdetailsEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _postdetailsRepository.findAll(predicate,pageable);
	}
  
   //Post
	public PostEntity GetPost(PostdetailsId postdetailsId) {
		
		Optional<PostdetailsEntity> dbPostdetails= _postdetailsRepository.findById(postdetailsId);
		if(dbPostdetails.isPresent()) {
			PostdetailsEntity existingPostdetails = dbPostdetails.get();
		    return existingPostdetails.getPost();
		} else {
		    return null;
		}
	}
}
