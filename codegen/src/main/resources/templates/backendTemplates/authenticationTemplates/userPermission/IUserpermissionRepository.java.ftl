package [=PackageName].domain.IRepository;

<#if History!false>
import org.javers.spring.annotation.JaversSpringDataAuditable;
</#if>
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;

<#if History!false>
@JaversSpringDataAuditable
</#if>
@RepositoryRestResource(collectionResourceRel = "[=AuthenticationTable?uncap_first]permission", path = "[=AuthenticationTable?uncap_first]permission")
public interface I[=AuthenticationTable]permissionRepository extends JpaRepository<[=AuthenticationTable]permissionEntity, [=AuthenticationTable]permissionId>,QuerydslPredicateExecutor<[=AuthenticationTable]permissionEntity> {
   
}
