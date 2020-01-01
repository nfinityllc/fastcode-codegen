package [=PackageName].domain;

import [=PackageName].domain.IRepository.ITriggerDetailsRepository;
import [=PackageName].domain.model.TriggerDetailsEntity;
import com.querydsl.core.types.Predicate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository
public class TriggerDetailsManager {

	 @Autowired
	    private ITriggerDetailsRepository _triggerRepository;

	 @Transactional
	    public Page<TriggerDetailsEntity> FindAll(Predicate predicate,Pageable pageable) {
	        return _triggerRepository.findAll(predicate,pageable);
	    }


}