package com.testg.tmep.application.Post;

import org.mapstruct.Mapper;
import com.testg.tmep.application.Post.Dto.*;
import com.testg.tmep.domain.model.PostEntity;

@Mapper(componentModel = "spring")
public interface PostMapper {

   PostEntity CreatePostInputToPostEntity(CreatePostInput postDto);
   
   CreatePostOutput PostEntityToCreatePostOutput(PostEntity entity);

   PostEntity UpdatePostInputToPostEntity(UpdatePostInput postDto);

   UpdatePostOutput PostEntityToUpdatePostOutput(PostEntity entity);

   FindPostByIdOutput PostEntityToFindPostByIdOutput(PostEntity entity);


}
