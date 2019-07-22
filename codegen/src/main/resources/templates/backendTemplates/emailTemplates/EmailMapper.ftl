package [=PackageName].application.Email;

import org.mapstruct.Mapper;

import [=PackageName].application.Email.Dto.*;
import [=PackageName].domain.model.EmailEntity;

@Mapper(componentModel = "spring")
public interface EmailMapper {

    EmailEntity CreateEmailInputToEmailEntity(CreateEmailInput emailDto);

    CreateEmailOutput EmailEntityToCreateEmailOutput(EmailEntity entity);

    EmailEntity UpdateEmailInputToEmailEntity(UpdateEmailInput emailDto);

    UpdateEmailOutput EmailEntityToUpdateEmailOutput(EmailEntity entity);

    FindEmailByIdOutput EmailEntityToFindEmailByIdOutput(EmailEntity entity);

    FindEmailByNameOutput EmailEntityToFindEmailByNameOutput(EmailEntity entity);
}
