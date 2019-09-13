package [=PackageName].domain.Flowable.Users;


import [=PackageName].domain.Flowable.Groups.ActIdGroupEntity;
import [=PackageName].domain.IRepository.IActIdGroupRepository;
import [=PackageName].domain.IRepository.IActIdUserRepository;
import [=PackageName].logging.LoggingHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
public class ActIdUserManager implements IActIdUserManager {
@Autowired
private IActIdUserRepository _actIdUsersRepository;
@Autowired
private IActIdGroupRepository _groupRepository;
@Autowired
private LoggingHelper logHelper;

@Override
public void create(ActIdUserEntity actIdUser) {
_actIdUsersRepository.save(actIdUser);
}

@Override
public void delete(ActIdUserEntity actIdUser) {
_actIdUsersRepository.delete(actIdUser);
}

@Override
public void update(ActIdUserEntity actIdUser) {
_actIdUsersRepository.save(actIdUser);
}

@Override
public void deleteAll() {
_actIdUsersRepository.deleteAll();
}

@Override
public ActIdUserEntity findByUserId(String userId) {
return  _actIdUsersRepository.findByUserId(userId);
}

@Override
public ActIdUserEntity findByUserEmail(String email) {
return  _actIdUsersRepository.findByUserEmail(email);
}

public void AddGroup(ActIdUserEntity actIdUser, ActIdGroupEntity actIdGroup) {
Set<ActIdUserEntity> su = actIdGroup.getActIdUser();

    if (!su.contains(actIdUser)) {
    actIdGroup.addActIdUser(actIdUser);
    }
    _groupRepository.save(actIdGroup);
    }

    public void RemoveGroup(ActIdUserEntity actIdUser, ActIdGroupEntity actIdGroup) {
    // We should only remove the group if it exists individually (not a part of the group privilege set).

    actIdGroup.removeActIdUser(actIdUser);
    _groupRepository.save(actIdGroup);
    }


    }
