package [=PackageName].application.[=ClassName];

import org.mapstruct.Mapper;
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation =="OneToOne">
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#if>
</#list>
import [=PackageName].application.[=ClassName].Dto.*;
import [=PackageName].domain.model.[=ClassName]Entity;


@Mapper(componentModel = "spring")
public interface [=ClassName]Mapper {

    [=ClassName]Entity Create[=ClassName]InputTo[=ClassName]Entity(Create[=ClassName]Input [=ClassName?lower_case]Dto);
   
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=DescriptiveField[relationValue.eName].fieldName]", target = "[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]"),                   
   </#if> 
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=joinDetails.referenceColumn]", target = "[=joinDetails.joinColumn]"),                   
   </#if>
   </#if>
   </#list>
   </#if>
   </#list>
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
    Create[=ClassName]Output [=ClassName]EntityToCreate[=ClassName]Output([=ClassName]Entity entity);

    [=ClassName]Entity Update[=ClassName]InputTo[=ClassName]Entity(Update[=ClassName]Input [=ClassName?lower_case]Dto);

  <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=DescriptiveField[relationValue.eName].fieldName]", target = "[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]"),                   
   </#if> 
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=joinDetails.referenceColumn]", target = "[=joinDetails.joinColumn]"),                   
   </#if>
   </#if>
   </#list>
   </#if>
   </#list>
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
    Update[=ClassName]Output [=ClassName]EntityToUpdate[=ClassName]Output([=ClassName]Entity entity);

   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=DescriptiveField[relationValue.eName].fieldName]", target = "[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]"),                   
   </#if> 
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=joinDetails.referenceColumn]", target = "[=joinDetails.joinColumn]"),                   
   </#if>
   </#if>
   </#list>
   </#if>
   </#list>
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne"> 
   <#if DescriptiveField[relationValue.eName]?? || relationValue.joinDetails?has_content>  
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   Find[=ClassName]ByIdOutput [=ClassName]EntityToFind[=ClassName]ByIdOutput([=ClassName]Entity entity);

   <#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   @Mappings({
   <#list relationValue.fDetails as fValue>
   <#list Fields as key,value> 
   <#if fValue.fieldName == value.fieldName>
   @Mapping(source = "[=relationValue.eName?lower_case].[=fValue.fieldName]", target = "[=fValue.fieldName]"),                  
   </#if>
   </#list>
   </#list> 
   <#list relationValue.joinDetails as joinDetails>
   <#if joinDetails.joinEntityName == relationValue.eName>
   <#if joinDetails.joinColumn??> 
    @Mapping(source = "[=InstanceName].[=joinDetails.joinColumn]", target = "[=InstanceName][=joinDetails.joinColumn?cap_first]")
    </#if>
    </#if>
    </#list>
    })
    Get[=relationValue.eName]Output [=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?lower_case], [=EntityClassName] [=InstanceName]);
 
   </#if>
   </#list>

}
