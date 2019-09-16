package [=PackageName].application.Flowable;

import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.Flowable.Users.ActIdUserEntity;
import org.springframework.stereotype.Component;

@Component
public class ActIdUserMapper {
public ActIdUserEntity createUsersEntityToActIdUserEntity(UserEntity user) {
    if ( user == null ) {
        return null;
    }

    ActIdUserEntity actIdUser = new ActIdUserEntity();
    actIdUser.setId(user.getUserName());
    actIdUser.setRev(0L);
    actIdUser.setFirst(user.getFirstName());
    actIdUser.setLast(user.getLastName());
    actIdUser.setDisplayName(null);
    actIdUser.setEmail(user.getEmailAddress());
    actIdUser.setPwd(user.getPassword());
    actIdUser.setPictureId(null);
    actIdUser.setTenantId(null);

    return actIdUser;
    }
}
