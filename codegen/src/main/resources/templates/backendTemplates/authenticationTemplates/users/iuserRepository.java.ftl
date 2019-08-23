package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.UserEntity;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "user", path = "user")
public interface IUserRepository extends JpaRepository<UserEntity, Long>,     
	 UserCustomRepository,QuerydslPredicateExecutor<UserEntity> {

    @Query("select u from UsersEntity u where u.userName = ?1")
    UsersEntity findByUserName(String value);
}