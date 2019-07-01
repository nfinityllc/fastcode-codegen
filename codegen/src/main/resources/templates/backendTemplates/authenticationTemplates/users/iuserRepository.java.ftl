package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.UsersEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "users", path = "users")
public interface IUsersRepository extends JpaRepository<UsersEntity, Long>,     
	 UsersCustomRepository,QuerydslPredicateExecutor<UsersEntity> {
    @Query("select u from UsersEntity u where u.id = ?1")
    UsersEntity findById(long id);

    @Query("select u from UsersEntity u where u.userName = ?1")
    UsersEntity findByUserName(String value);
}