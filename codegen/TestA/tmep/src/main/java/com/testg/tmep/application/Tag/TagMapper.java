package com.testg.tmep.application.Tag;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import com.testg.tmep.domain.model.TagdetailsEntity;
import com.testg.tmep.application.Tag.Dto.*;
import com.testg.tmep.domain.model.TagEntity;

@Mapper(componentModel = "spring")
public interface TagMapper {

   TagEntity CreateTagInputToTagEntity(CreateTagInput tagDto);
   
   CreateTagOutput TagEntityToCreateTagOutput(TagEntity entity);

   TagEntity UpdateTagInputToTagEntity(UpdateTagInput tagDto);

   UpdateTagOutput TagEntityToUpdateTagOutput(TagEntity entity);

   FindTagByIdOutput TagEntityToFindTagByIdOutput(TagEntity entity);


   @Mappings({
   @Mapping(source = "tagdetails.title", target = "title"),                  
   @Mapping(source = "tag.tagid", target = "tagTagid"),
   @Mapping(source = "tag.title", target = "tagTitle"),
   })
   GetTagdetailsOutput TagdetailsEntityToGetTagdetailsOutput(TagdetailsEntity tagdetails, TagEntity tag);
 
}
