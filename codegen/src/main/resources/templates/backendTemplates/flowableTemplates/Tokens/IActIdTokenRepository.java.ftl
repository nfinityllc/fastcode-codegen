package [=PackageName].domain.IRepository;

import [=PackageName].domain.Flowable.Tokens.ActIdTokenEntity;
import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "tokens", path = "tokens")
public interface IActIdTokenRepository extends JpaRepository<ActIdTokenEntity, String>, QuerydslPredicateExecutor<ActIdTokenEntity> {

    }
