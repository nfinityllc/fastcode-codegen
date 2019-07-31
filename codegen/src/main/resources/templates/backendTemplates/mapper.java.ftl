package [=PackageName].application.[=ClassName];

import org.mapstruct.Mapper;
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation =="ManyToMany">
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
<#if relationValue.relation == "ManyToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
<#if relationValue.relation =="ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if relationKey == parent>
<#if parent?keep_after("-") == relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
import [=PackageName].application.[=relationValue.eName].Dto.Find[=relationValue.eName]ByIdOutput;
</#if>
</#if>
</#list>
</#if>
</#if>
</#list>
import [=PackageName].application.[=ClassName].Dto.*;
import [=PackageName].domain.model.[=ClassName]Entity;


@Mapper(componentModel = "spring")
public interface [=ClassName]Mapper {

    [=ClassName]Entity Create[=ClassName]InputTo[=ClassName]Entity(Create[=ClassName]Input [=ClassName?lower_case]Dto);
   
      <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField?? || relationValue.joinColumn??> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=relationValue.entityDescriptionField.fieldName]", target = "[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]"),                   
   </#if> 
   <#if relationValue.joinColumn??> 
   <#list relationValue.fDetails as fvalue> 
   <#if fvalue.isPrimaryKey?string('true','false') == "true" > 
   @Mapping(source = "[=relationValue.eName?lower_case].[=fvalue.fieldName]", target = "[=relationValue.joinColumn]"),                   
   </#if> 
   </#list> 
   </#if> 
   </#if> 
   </#list> 
    <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField?? || relationValue.joinColumn??> 
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
    Create[=ClassName]Output [=ClassName]EntityToCreate[=ClassName]Output([=ClassName]Entity entity);

    [=ClassName]Entity Update[=ClassName]InputTo[=ClassName]Entity(Update[=ClassName]Input [=ClassName?lower_case]Dto);

    <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField?? || relationValue.joinColumn??> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=relationValue.entityDescriptionField.fieldName]", target = "[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]"),                   
   </#if> 
   <#if relationValue.joinColumn??> 
   <#list relationValue.fDetails as fvalue> 
   <#if fvalue.isPrimaryKey?string('true','false') == "true" > 
   @Mapping(source = "[=relationValue.eName?lower_case].[=fvalue.fieldName]", target = "[=relationValue.joinColumn]"),                   
   </#if> 
   </#list> 
   </#if> 
   </#if> 
   </#list> 
    <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField?? || relationValue.joinColumn??> 
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
    Update[=ClassName]Output [=ClassName]EntityToUpdate[=ClassName]Output([=ClassName]Entity entity);

      <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField?? || relationValue.joinColumn??> 
   @Mappings({ 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
   <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField??> 
   @Mapping(source = "[=relationValue.eName?lower_case].[=relationValue.entityDescriptionField.fieldName]", target = "[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]"),                   
   </#if> 
   <#if relationValue.joinColumn??> 
   <#list relationValue.fDetails as fvalue> 
   <#if fvalue.isPrimaryKey?string('true','false') == "true" > 
   @Mapping(source = "[=relationValue.eName?lower_case].[=fvalue.fieldName]", target = "[=relationValue.joinColumn]"),                   
   </#if> 
   </#list> 
   </#if> 
   </#if> 
   </#list> 
    <#list Relationship as relationKey, relationValue> 
   <#if relationValue.relation == "ManyToOne"> 
   <#if relationValue.entityDescriptionField?? || relationValue.joinColumn??> 
   }) 
   <#break> 
   </#if> 
   </#if> 
   </#list> 
    Find[=ClassName]ByIdOutput [=ClassName]EntityToFind[=ClassName]ByIdOutput([=ClassName]Entity entity);

  <#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">
  @Mappings({
  <#list relationValue.fDetails as fValue>
  <#list Fields as key,value> 
   <#if fValue.fieldName == value.fieldName>
    @Mapping(source = "[=relationValue.eName?lower_case].[=fValue.fieldName]", target = "[=fValue.fieldName]"),                  
   </#if>
   </#list>
   </#list> 
    @Mapping(source = "[=InstanceName].id", target = "[=InstanceName]Id")
    })
    Get[=relationValue.eName]Output [=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?lower_case], [=EntityClassName] [=InstanceName]);
  
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if relationKey == parent>
  <#if parent?keep_after("-") == relationValue.eName>
    @Mappings({
  <#list relationValue.fDetails as fValue>
  <#list Fields as key,value> 
  <#if fValue.fieldName == value.fieldName>
    @Mapping(source = "[=relationValue.eName?lower_case].[=fValue.fieldName]", target = "[=fValue.fieldName]"),                  
  </#if>
  </#list>
  </#list>
   <#if parent?keep_before("-") == ClassName && relationValue.entityDescriptionField??>
    @Mapping(source = "[=InstanceName].[=relationValue.entityDescriptionField.fieldName]", target = "[=InstanceName][=relationValue.entityDescriptionField.fieldName?cap_first]"),
   </#if> 
    @Mapping(source = "[=InstanceName].[=relationValue.referenceColumn]", target = "[=InstanceName][=relationValue.referenceColumn?cap_first]")
    })
    Get[=relationValue.eName]Output [=relationValue.eName]EntityToGet[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?lower_case],[=EntityClassName] [=InstanceName]);
    Find[=relationValue.eName]ByIdOutput [=relationValue.eName]EntityToGetAvailable[=relationValue.eName]Output([=relationValue.eName]Entity [=relationValue.eName?lower_case]);
    </#if>
</#if>
    </#list>
   </#if>
  </#list>
}
