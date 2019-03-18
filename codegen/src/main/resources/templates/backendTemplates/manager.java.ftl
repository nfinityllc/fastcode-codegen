package com.nfinity.fastcode.domain.Authorization.${PackageName};

import java.util.Iterator;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.nfinity.fastcode.domain.IRepository.I${ClassName}Repository;
import com.querydsl.core.types.Predicate;

@Repository
public class ${ClassName}Manager implements I${ClassName}Manager {

    @Autowired
    I${ClassName}Repository  _${ClassName?lower_case}Repository;
    
	@Transactional
	public ${EntityClassName} Create(${EntityClassName} ${InstanceName}) {

		return _${ClassName?lower_case}Repository.save(${InstanceName});
	}

	@Transactional
	public void Delete(${EntityClassName} ${InstanceName}) {

		_${ClassName?lower_case}Repository.delete(${InstanceName});	
	}

	@Transactional
	public ${EntityClassName} Update(${EntityClassName} ${InstanceName}) {

		return _${ClassName?lower_case}Repository.save(${InstanceName});
	}

	@Transactional
	public ${EntityClassName} FindById(Long id) {

		return _${ClassName?lower_case}Repository.findById(id.longValue());
	}

	@Transactional
	public Page<${EntityClassName}> FindAll(Predicate predicate, Pageable pageable) {

		return _${ClassName?lower_case}Repository.findAll(predicate,pageable);
	}

	@Transactional
	public ${EntityClassName} FindByName(String name) {

		return _${ClassName?lower_case}Repository.findByName(name);
	}
	

}
