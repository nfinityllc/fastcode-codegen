package [=PackageName].application.EmailTemplate;

import org.mapstruct.Mapper;

import [=PackageName].application.EmailTemplate.Dto.*;
import [=PackageName].domain.model.EmailTemplateEntity;

@Mapper(componentModel = "spring")
public interface EmailTemplateMapper {

    EmailTemplateEntity CreateEmailTemplateInputToEmailTemplateEntity(CreateEmailTemplateInput emailDto);

    CreateEmailTemplateOutput EmailTemplateEntityToCreateEmailTemplateOutput(EmailTemplateEntity entity);

    EmailTemplateEntity UpdateEmailTemplateInputToEmailTemplateEntity(UpdateEmailTemplateInput emailDto);

    UpdateEmailTemplateOutput EmailTemplateEntityToUpdateEmailTemplateOutput(EmailTemplateEntity entity);

    FindEmailTemplateByIdOutput EmailTemplateEntityToFindEmailTemplateByIdOutput(EmailTemplateEntity entity);

    FindEmailTemplateByNameOutput EmailTemplateEntityToFindEmailTemplateByNameOutput(EmailTemplateEntity entity);
}