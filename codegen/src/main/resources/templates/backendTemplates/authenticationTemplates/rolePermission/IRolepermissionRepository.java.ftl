package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import [=PackageName].domain.model.RolepermissionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import [=PackageName].domain.model.RolepermissionEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "rolepermission", path = "rolepermission")
public interface IRolepermissionRepository extends JpaRepository<RolepermissionEntity, RolepermissionId>,QuerydslPredicateExecutor<RolepermissionEntity> {

	   
}
