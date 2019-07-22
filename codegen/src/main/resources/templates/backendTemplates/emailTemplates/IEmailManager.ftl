package [=PackageName].domain.Email;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import [=PackageName].domain.model.EmailEntity;

import com.querydsl.core.types.Predicate;

public interface IEmailManager {

	 // CRUD Operations
    public EmailEntity Create(EmailEntity email);

    public void Delete(EmailEntity email);

    public EmailEntity Update(EmailEntity email);

    public EmailEntity FindById(Long emailId);
    
    public EmailEntity FindByName (String name);

    public Page<EmailEntity> FindAll(Predicate predicate,Pageable pageable);
	
}
