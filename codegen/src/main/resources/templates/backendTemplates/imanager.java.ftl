package com.nfinity.fastcode.domain.Authorization.${PackageName};

import java.util.Set;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import com.nfinity.fastcode.domain.Authorization.${relationValue.eName}s.${relationValue.eName}Entity;
</#if>
</#list>

public interface I${ClassName}Manager {
    // CRUD Operations
    ${EntityClassName} Create(${EntityClassName} ${InstanceName});

    void Delete(${EntityClassName} ${InstanceName});

    ${EntityClassName} Update(${EntityClassName} ${InstanceName});

    ${EntityClassName} FindById(@Positive(message ="Id should be a positive value")Long ${InstanceName}Id);

    Page<${EntityClassName}> FindAll(Predicate predicate, Pageable pageable);

    //Internal operation
   ${EntityClassName} FindByName(String name);
   
  <#list Relationship as relationKey, relationValue>

  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   //${relationValue.eName}
   public void Add${relationValue.eName}(${EntityClassName} ${InstanceName}, ${relationValue.eName}Entity ${relationValue.eName?lower_case});

   public void Remove${relationValue.eName}(${EntityClassName} ${InstanceName});

   public ${relationValue.eName}Entity Get${relationValue.eName}(@Positive(message ="${InstanceName}Id should be a positive value") Long ${InstanceName}Id);
  
  <#elseif relationValue.relation == "ManyToMany">
    //${relationValue.eName}
    public Boolean Add${relationValue.eName}(${EntityClassName} ${InstanceName}, ${relationValue.eName}Entity ${relationValue.eName?lower_case});

    public void Remove${relationValue.eName}(${EntityClassName} ${InstanceName}, ${relationValue.eName}Entity ${relationValue.eName?lower_case});

    public ${relationValue.eName}Entity Get${relationValue.eName}(@Positive(message ="${InstanceName}Id should be a positive value") Long ${InstanceName}Id,@Positive(message ="${relationValue.eName}Id should be a positive value") Long ${relationValue.eName?lower_case}Id);

    public Set<${relationValue.eName}Entity> Get${relationValue.eName}s(${EntityClassName} ${InstanceName});
    
   </#if>
  
  </#list>
}