package com.nfinity.fastcode.application.Authorization.${PackageName};

import java.util.List;

import javax.validation.constraints.Positive;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.nfinity.fastcode.application.Authorization.${PackageName}.Dto.*;

@Service
public interface I${ClassName}AppService {

	Create${ClassName}Output Create(Create${ClassName}Input ${ClassName?lower_case});

    void Delete(@Positive(message ="Id should be a positive value")Long id);

    Update${ClassName}Output Update(@Positive(message ="Id should be a positive value") Long id,Update${ClassName}Input ${ClassName?lower_case});

    Find${ClassName}ByIdOutput FindById(@Positive(message ="Id should be a positive value")Long id);

    Find${ClassName}ByNameOutput FindByName(String name);
    
    List<Find${ClassName}ByIdOutput> Find(String search, Pageable pageable) throws Exception;
	
	
}