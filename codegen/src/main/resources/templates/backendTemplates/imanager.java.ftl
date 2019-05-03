package [=PackageName].domain.[=ClassName];

import java.util.Set;
import com.querydsl.core.types.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import javax.validation.constraints.Positive;
import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
</#list>

public interface I[=ClassName]Manager {
    // CRUD Operations
    [=EntityClassName] Create([=EntityClassName] [=InstanceName]);

    void Delete([=EntityClassName] [=InstanceName]);

    [=EntityClassName] Update([=EntityClassName] [=InstanceName]);

    [=EntityClassName] FindById(@Positive(message ="Id should be a positive value")Long [=InstanceName]Id);

    Page<[=EntityClassName]> FindAll(Predicate predicate, Pageable pageable);
   
  <#list Relationship as relationKey, relationValue>

  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
   //[=relationValue.eName]
   public [=relationValue.eName]Entity Get[=relationValue.eName](@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]Id);
  
   <#elseif relationValue.relation == "ManyToMany">
    <#list RelationInput as relationInput>
    <#assign parent = relationInput>
    <#if parent?keep_after("-") == relationValue.eName>
    //[=relationValue.eName]
    public Boolean Add[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]);

    public void Remove[=relationValue.eName]([=EntityClassName] [=InstanceName], [=relationValue.eName]Entity [=relationValue.eName?lower_case]);

    public [=relationValue.eName]Entity Get[=relationValue.eName](@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]Id,@Positive(message ="[=relationValue.eName]Id should be a positive value") Long [=relationValue.eName?lower_case]Id);

    public Set<[=relationValue.eName]Entity> Get[=relationValue.eName]s([=EntityClassName] [=InstanceName]);
    </#if>
    </#list>
   </#if>
  
  </#list>
}
