package com.nfinity.fastcode.application.EmailVariable;

import org.mapstruct.Mapper;

import [=PackageName].application.EmailVariable.Dto.*;
import [=PackageName].domain.model.EmailVariableEntity;


@Mapper(componentModel = "spring")
public interface EmailVariableMapper {

    EmailVariableEntity CreateEmailVariableInputToEmailVariableEntity(CreateEmailVariableInput emailDto);

    CreateEmailVariableOutput EmailVariableEntityToCreateEmailVariableOutput(EmailVariableEntity entity);

    EmailVariableEntity UpdateEmailVariableInputToEmailVariableEntity(UpdateEmailVariableInput emailDto);

    UpdateEmailVariableOutput EmailVariableEntityToUpdateEmailVariableOutput(EmailVariableEntity entity);

    FindEmailVariableByIdOutput EmailVariableEntityToFindEmailVariableByIdOutput(EmailVariableEntity entity);

    FindEmailVariableByNameOutput EmailVariableEntityToFindEmailVariableByNameOutput(EmailVariableEntity entity);
}