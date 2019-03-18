package com.nfinity.fastcode.domain.Authorization.${PackageName};

import java.util.Set;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;

public interface I${ClassName}Manager {
    // CRUD Operations
    ${EntityClassName} Create(${EntityClassName} ${InstanceName});

    void Delete(${EntityClassName} ${InstanceName});

    ${EntityClassName} Update(${EntityClassName} ${InstanceName});

    ${EntityClassName} FindById(@Positive(message ="Id should be a positive value")Long ${InstanceName}Id);

    Page<${EntityClassName}> FindAll(Predicate predicate, Pageable pageable);

    //Internal operation
   ${EntityClassName} FindByName(String name);
 
}