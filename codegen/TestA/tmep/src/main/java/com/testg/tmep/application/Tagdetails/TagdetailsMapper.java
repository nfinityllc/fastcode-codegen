package com.testg.tmep.application.Tagdetails;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import com.testg.tmep.domain.model.TagEntity;
import com.testg.tmep.application.Tagdetails.Dto.*;
import com.testg.tmep.domain.model.TagdetailsEntity;

@Mapper(componentModel = "spring")
public interface TagdetailsMapper {

   TagdetailsEntity CreateTagdetailsInputToTagdetailsEntity(CreateTagdetailsInput tagdetailsDto);
   
   @Mappings({ 
   @Mapping(source = "tag.description", target = "tagDescriptiveField"),                    
   }) 
   CreateTagdetailsOutput TagdetailsEntityToCreateTagdetailsOutput(TagdetailsEntity entity);

   TagdetailsEntity UpdateTagdetailsInputToTagdetailsEntity(UpdateTagdetailsInput tagdetailsDto);

   @Mappings({ 
   @Mapping(source = "tag.description", target = "tagDescriptiveField"),                    
   }) 
   UpdateTagdetailsOutput TagdetailsEntityToUpdateTagdetailsOutput(TagdetailsEntity entity);

   @Mappings({ 
   @Mapping(source = "tag.description", target = "tagDescriptiveField"),                    
   }) 
   FindTagdetailsByIdOutput TagdetailsEntityToFindTagdetailsByIdOutput(TagdetailsEntity entity);


   @Mappings({
   @Mapping(source = "tag.title", target = "title"),                  
   @Mapping(source = "tagdetails.tid", target = "tagdetailsTid"),
   @Mapping(source = "tagdetails.title", target = "tagdetailsTitle"),
   })
   GetTagOutput TagEntityToGetTagOutput(TagEntity tag, TagdetailsEntity tagdetails);
 
}
