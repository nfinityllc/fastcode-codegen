package [=PackageName].application.[=ClassName];

import java.util.List;

import javax.validation.constraints.Positive;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=PackageName].application.[=ClassName].Dto.*;

@Service
public interface I[=ClassName]AppService {

	Create[=ClassName]Output Create(Create[=ClassName]Input [=ClassName?lower_case]);

    void Delete(@Positive(message ="Id should be a positive value")Long id);

    Update[=ClassName]Output Update(@Positive(message ="Id should be a positive value") Long id,Update[=ClassName]Input [=ClassName?lower_case]);

    Find[=ClassName]ByIdOutput FindById(@Positive(message ="Id should be a positive value")Long id);
    
    List<Find[=ClassName]ByIdOutput> Find(String search, Pageable pageable) throws Exception;
	
	<#list Relationship as relationKey, relationValue>

   <#if relationValue.relation == "ManyToOne">
   //[=relationValue.eName]
    Get[=relationValue.eName]Output Get[=relationValue.eName](@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]id);
  <#elseif relationValue.relation == "OneToMany">
    List<Get[=relationValue.eName]Output> Get[=ClassName]List(@Positive(message ="[=InstanceName]Id should be a positive value") Long [=ClassName?uncap_first]Id);
	 
  <#elseif relationValue.relation == "ManyToMany">
  <#list RelationInput as relationInput>
  <#assign parent = relationInput>
  <#if parent?keep_after("-") == relationValue.eName>
    // Operations With [=relationValue.eName]
    Boolean Add[=relationValue.eName](@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]id, @Positive(message ="[=relationValue.eName]Id should be a positive value") Long [=relationValue.eName?lower_case]id);

    void Remove[=relationValue.eName](@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]id, @Positive(message ="[=relationValue.eName]Id should be a positive value") Long [=relationValue.eName?lower_case]id);

    Get[=relationValue.eName]Output Get[=relationValue.eName](@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]id, @Positive(message ="[=relationValue.eName]Id should be a positive value") Long [=relationValue.eName?lower_case]id);

    List<Get[=relationValue.eName]Output> Get[=relationValue.eName]s(@Positive(message ="[=InstanceName]Id should be a positive value") Long [=InstanceName]id);
   </#if>
   </#list>
   </#if>
  
  </#list>
}
