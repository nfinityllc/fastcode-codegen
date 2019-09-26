package [=PackageName].application.Flowable;

import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.Flowable.Users.ActIdUserEntity;
import org.springframework.stereotype.Component;

@Component
public class ActIdUserMapper {
public ActIdUserEntity createUsersEntityToActIdUserEntity([=AuthenticationTable]Entity user) {
    if ( user == null ) {
        return null;
    }

    ActIdUserEntity actIdUser = new ActIdUserEntity();
    <#if UserInput??>
        <#if AuthenticationFields?? >
            <#list AuthenticationFields as authKey,authValue>
                <#if authKey == "User Name">
                    <#assign foundUserNameField = true>
                    actIdUser.setId(user.get[=authValue.fieldName?cap_first]());
                </#if>
            </#list>
        </#if>
    <#else>
        actIdUser.setId(user.getUserName());
    </#if>

    actIdUser.setRev(0L);
    actIdUser.setFirst(user.getFirstName());
    actIdUser.setLast(user.getLastName());
    actIdUser.setDisplayName(null);
    actIdUser.setEmail(user.getEmailAddress());
    <#if UserInput??>
        <#if AuthenticationFields??>
            <#list AuthenticationFields as authKey,authValue>
                <#if authKey == "Password">
                    <#assign foundPasswordField = true>
                    actIdUser.setPwd(user.get[=authValue.fieldName?cap_first]());
                </#if>
            </#list>
        </#if>
    <#else>
        actIdUser.setPwd(user.getPassword());
    </#if>
    actIdUser.setPictureId(null);
    actIdUser.setTenantId(null);

    return actIdUser;
    }
}
