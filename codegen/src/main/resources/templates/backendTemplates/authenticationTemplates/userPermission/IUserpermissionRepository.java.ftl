package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.testing.demoTemp.domain.model.UserpermissionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import [=PackageName].domain.model.UserpermissionEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "userpermission", path = "userpermission")
public interface IUserpermissionRepository extends JpaRepository<UserpermissionEntity, UserpermissionId>,QuerydslPredicateExecutor<UserpermissionEntity> {
   
}
