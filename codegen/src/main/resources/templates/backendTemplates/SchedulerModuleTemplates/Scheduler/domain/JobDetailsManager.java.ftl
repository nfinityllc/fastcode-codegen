package [=PackageName].domain;

import [=PackageName].domain.IRepository.IJobDetailsRepository;
import [=PackageName].domain.model.JobDetailsEntity;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public class JobDetailsManager {

	 @Autowired
	    private IJobDetailsRepository _jobRepository;

	 @Transactional
	    public Page<JobDetailsEntity> FindAll(Predicate predicate,Pageable pageable) {
	        return _jobRepository.findAll(predicate, pageable);
	    }


}
