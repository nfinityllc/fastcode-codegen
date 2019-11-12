package com.testg.tmep.application.Postdetails;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import com.testg.tmep.domain.model.PostEntity;
import com.testg.tmep.application.Postdetails.Dto.*;
import com.testg.tmep.domain.model.PostdetailsEntity;

@Mapper(componentModel = "spring")
public interface PostdetailsMapper {

   PostdetailsEntity CreatePostdetailsInputToPostdetailsEntity(CreatePostdetailsInput postdetailsDto);
   
   @Mappings({ 
   @Mapping(source = "post.title", target = "title"),                   
   @Mapping(source = "post.title", target = "postDescriptiveField"),                    
   }) 
   CreatePostdetailsOutput PostdetailsEntityToCreatePostdetailsOutput(PostdetailsEntity entity);

   PostdetailsEntity UpdatePostdetailsInputToPostdetailsEntity(UpdatePostdetailsInput postdetailsDto);

   @Mappings({ 
   @Mapping(source = "post.title", target = "title"),                   
   @Mapping(source = "post.title", target = "postDescriptiveField"),                    
   }) 
   UpdatePostdetailsOutput PostdetailsEntityToUpdatePostdetailsOutput(PostdetailsEntity entity);

   @Mappings({ 
   @Mapping(source = "post.title", target = "title"),                   
   @Mapping(source = "post.title", target = "postDescriptiveField"),                    
   }) 
   FindPostdetailsByIdOutput PostdetailsEntityToFindPostdetailsByIdOutput(PostdetailsEntity entity);


   @Mappings({
   @Mapping(source = "postdetails.pdid", target = "postdetailsPdid"),
   @Mapping(source = "postdetails.pid", target = "postdetailsPid"),
   })
   GetPostOutput PostEntityToGetPostOutput(PostEntity post, PostdetailsEntity postdetails);
 
}
