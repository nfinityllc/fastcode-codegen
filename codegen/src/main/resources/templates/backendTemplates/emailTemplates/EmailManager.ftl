package [=PackageName].domain.Email;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import [=PackageName].domain.IRepository.IEmailRepository;
import [=PackageName].domain.model.EmailEntity;
import com.querydsl.core.types.Predicate;

@Repository
public class EmailManager implements IEmailManager {

	@Autowired
	IEmailRepository  _emailRepository;

	public EmailEntity Create(EmailEntity email) {

		return _emailRepository.save(email);
	}

	public void Delete(EmailEntity email) {

		_emailRepository.delete(email);	
	}

	public EmailEntity Update(EmailEntity email) {

		return _emailRepository.save(email);
	}

	public EmailEntity FindById(Long emailId) {

		return _emailRepository.findById(emailId.longValue());
	}

	public Page<EmailEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _emailRepository.findAll(predicate,pageable);
	}

	public EmailEntity FindByName(String name) {

		return _emailRepository.findByEmailName(name);
	}

}
