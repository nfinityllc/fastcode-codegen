package [=PackageName].domain.IRepository;

import org.javers.spring.annotation.JaversSpringDataAuditable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.[=EntityClassName];

@JaversSpringDataAuditable
@RepositoryRestResource(collectionResourceRel = "[=ApiPath]s", path = "[=ApiPath]s")
public interface I[=ClassName]Repository extends JpaRepository<[=EntityClassName], Long>, QuerydslPredicateExecutor<[=EntityClassName]> {

	   @Query("select e from [=EntityClassName] e where e.id = ?1")
	   [=EntityClassName] findById(long id);
	   
}
