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
	   <#if AuthenticationTable?? && AuthenticationFields??>
		actIdUser.setId(user.get[=AuthenticationFields.UserName.fieldName?cap_first]());
		actIdUser.setFirst(user.get[=AuthenticationFields.FirstName.fieldName?cap_first]());
		actIdUser.setLast(user.get[=AuthenticationFields.LastName.fieldName?cap_first]());
		actIdUser.setEmail(user.get[=AuthenticationFields.EmailAddress.fieldName?cap_first]());
		actIdUser.setPwd(user.get[=AuthenticationFields.Password.fieldName?cap_first]());
	   <#else>
		actIdUser.setId(user.getUsername());
		actIdUser.setFirst(user.getFirstName());
		actIdUser.setLast(user.getLastName());
		actIdUser.setEmail(user.getEmailAddress());
		actIdUser.setPwd(user.getPassword());
	   </#if>
		actIdUser.setRev(0L);
		actIdUser.setDisplayName(null);
		actIdUser.setPictureId(null);
		actIdUser.setTenantId(null);
		
		return actIdUser;
	}
}
