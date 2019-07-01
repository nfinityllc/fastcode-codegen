package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.RolesEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "roles", path = "roles")
public interface IRolesRepository extends JpaRepository<RolesEntity, Long>,   
	 RolesCustomRepository,  QuerydslPredicateExecutor<RolesEntity> {

    @Query("select u from RolesEntity u where u.id = ?1")
    RolesEntity findById(long id);

    @Query("select u from RolesEntity u where u.name = ?1")
    RolesEntity findByRoleName(String value);
}