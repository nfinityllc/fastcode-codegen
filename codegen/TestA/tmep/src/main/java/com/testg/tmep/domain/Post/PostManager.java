package com.testg.tmep.domain.Post;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.domain.model.PostId;
import com.testg.tmep.domain.IRepository.IPostdetailsRepository;
import com.testg.tmep.domain.IRepository.IPostRepository;
import com.querydsl.core.types.Predicate;

@Repository
public class PostManager implements IPostManager {

    @Autowired
    IPostRepository  _postRepository;
    
    @Autowired
	IPostdetailsRepository  _postdetailsRepository;
    
	public PostEntity Create(PostEntity post) {

		return _postRepository.save(post);
	}

	public void Delete(PostEntity post) {

		_postRepository.delete(post);	
	}

	public PostEntity Update(PostEntity post) {

		return _postRepository.save(post);
	}

	public PostEntity FindById(PostId postId) {
    	Optional<PostEntity> dbPost= _postRepository.findById(postId);
		if(dbPost.isPresent()) {
			PostEntity existingPost = dbPost.get();
		    return existingPost;
		} else {
		    return null;
		}

	}

	public Page<PostEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _postRepository.findAll(predicate,pageable);
	}
}
