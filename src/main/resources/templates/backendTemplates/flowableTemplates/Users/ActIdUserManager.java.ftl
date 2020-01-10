package [=PackageName].domain.Flowable.Users;

import [=PackageName].domain.Flowable.Groups.ActIdGroupEntity;
import [=PackageName].domain.IRepository.IActIdGroupRepository;
import [=PackageName].domain.IRepository.IActIdUserRepository;
import [=PackageName].CommonModule.logging.LoggingHelper;
import org.apache.commons.lang3.StringUtils;
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


}
