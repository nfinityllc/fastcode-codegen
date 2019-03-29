package com.nfinity.fastcode.application.Authorization.${PackageName};

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import com.nfinity.fastcode.domain.Authorization.${relationValue.eName}s.${relationValue.eName}Entity;
</#if>
</#list>
import com.nfinity.fastcode.application.Authorization.${PackageName}.Dto.*;
import com.nfinity.fastcode.domain.Authorization.${PackageName}.${ClassName}Entity;


@Mapper(componentModel = "spring")
public interface ${ClassName}Mapper {

    ${ClassName}Entity Create${ClassName}InputTo${ClassName}Entity(Create${ClassName}Input ${ClassName?lower_case}Dto);

    Create${ClassName}Output ${ClassName}EntityToCreate${ClassName}Output(${ClassName}Entity entity);

    ${ClassName}Entity Update${ClassName}InputTo${ClassName}Entity(Update${ClassName}Input ${ClassName?lower_case}Dto);

    Update${ClassName}Output ${ClassName}EntityToUpdate${ClassName}Output(${ClassName}Entity entity);

    Find${ClassName}ByIdOutput ${ClassName}EntityToFind${ClassName}ByIdOutput(${ClassName}Entity entity);

    Find${ClassName}ByNameOutput ${ClassName}EntityToFind${ClassName}ByNameOutput(${ClassName}Entity entity);

  <#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">

   @Mappings({
            @Mapping(source = "${relationValue.eName?lower_case}.id", target = "id"),
            @Mapping(source = "${relationValue.eName?lower_case}.creationTime", target = "creationTime"),
            @Mapping(source = "${relationValue.eName?lower_case}.creatorUserId", target = "creatorUserId"),
            @Mapping(source = "${relationValue.eName?lower_case}.lastModifierUserId", target = "lastModifierUserId"),
            @Mapping(source = "${relationValue.eName?lower_case}.lastModificationTime", target = "lastModificationTime"),
            @Mapping(source = "${InstanceName}.id", target = "${InstanceName}Id")
    })
    Get${relationValue.eName}Output ${relationValue.eName}EntityToGet${relationValue.eName}Output(${relationValue.eName}Entity ${relationValue.eName?lower_case}, ${EntityClassName} ${InstanceName});
   
    
  <#elseif relationValue.relation == "ManyToMany">
  
  @Mappings({
            @Mapping(source = "${relationValue.eName?lower_case}.${relationValue.inverseReferenceColumn}", target = "${relationValue.inverseReferenceColumn}"),
            @Mapping(source = "${relationValue.eName?lower_case}.creationTime", target = "creationTime"),
            @Mapping(source = "${relationValue.eName?lower_case}.creatorUserId", target = "creatorUserId"),
            @Mapping(source = "${relationValue.eName?lower_case}.lastModifierUserId", target = "lastModifierUserId"),
            @Mapping(source = "${relationValue.eName?lower_case}.lastModificationTime", target = "lastModificationTime"),
            @Mapping(source = "${InstanceName}.${relationValue.referenceColumn}", target = "${InstanceName}${relationValue.referenceColumn?cap_first}")
    })
    Get${relationValue.eName}Output ${relationValue.eName}EntityToGet${relationValue.eName}Output(${relationValue.eName}Entity ${relationValue.eName?lower_case},${EntityClassName} ${InstanceName});
  
   </#if>
  
  </#list>

}