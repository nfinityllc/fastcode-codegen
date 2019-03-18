package com.nfinity.fastcode.application.Authorization.${PackageName};

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
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


}