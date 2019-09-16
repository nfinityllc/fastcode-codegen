package [=PackageName].application.Flowable;

import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.Flowable.Groups.ActIdGroupEntity;
import org.springframework.stereotype.Component;

@Component
public class ActIdGroupMapper {
public ActIdGroupEntity createRolesEntityToActIdGroupEntity(RoleEntity role) {
    if ( role == null ) {
        return null;
    }

    ActIdGroupEntity actIdGroup = new ActIdGroupEntity();
    actIdGroup.setId(role.getName());
    actIdGroup.setName(role.getName());
    actIdGroup.setRev(0L);
    actIdGroup.setType(null);

    return actIdGroup;
    }
}
