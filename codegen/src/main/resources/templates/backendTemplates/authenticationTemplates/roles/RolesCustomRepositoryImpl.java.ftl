package [=PackageName].domain.IRepository;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import [=CommonModulePackage].Search.*;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.model.PermissionsEntity;

@Repository
public class RolesCustomRepositoryImpl implements RolesCustomRepository{

	@PersistenceContext
	private EntityManager entityManager;

	public Page<PermissionsEntity> getAllPermissions(Long rolesId, List<SearchFields> search,String operator, Pageable pageable)  {

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<PermissionsEntity> criteriaQuery = criteriaBuilder
				.createQuery(PermissionsEntity.class);

		Root<PermissionsEntity> fromPermissions = criteriaQuery.from(PermissionsEntity.class);
		Join<PermissionsEntity, RolesEntity> join = fromPermissions.join("roles");
		List<Predicate> conditions = new ArrayList();
		if(operator.equalsIgnoreCase("notEqual"))
		conditions.add(criteriaBuilder.notEqual(join.get("id"), rolesId));
		else
		conditions.add(criteriaBuilder.equal(join.get("id"), rolesId));
		
		for(SearchFields s: search)
		{
			if(s.getFieldName().equals("displayName")) {
				if(s.getOperator().equals("contains"))
					conditions.add(criteriaBuilder.like(criteriaBuilder.upper(fromPermissions.get("displayName")),"%"+ s.getSearchValue().toUpperCase() + "%"));
				else if(s.getOperator().equals("equals"))
					conditions.add(criteriaBuilder.equal(criteriaBuilder.upper(fromPermissions.get("displayName")),s.getSearchValue().toUpperCase()));
				else if(s.getOperator().equals("notEqual"))
					conditions.add(criteriaBuilder.notEqual(criteriaBuilder.upper(fromPermissions.get("displayName")),s.getSearchValue().toUpperCase()));
			}
			if(s.getFieldName().equals("name")) {
				if(s.getOperator().equals("contains"))
					conditions.add(criteriaBuilder.like(criteriaBuilder.upper(fromPermissions.get("name")),"%"+ s.getSearchValue().toUpperCase() + "%"));
				else if(s.getOperator().equals("equals"))
					conditions.add(criteriaBuilder.equal(criteriaBuilder.upper(fromPermissions.get("name")),s.getSearchValue().toUpperCase()));
				else if(s.getOperator().equals("notEqual"))
					conditions.add(criteriaBuilder.notEqual(criteriaBuilder.upper(fromPermissions.get("name")),s.getSearchValue().toUpperCase()));
			}
			
		}

		TypedQuery<PermissionsEntity> typedQuery = entityManager.createQuery(criteriaQuery
				.select(fromPermissions)
				.where(conditions.toArray(new Predicate[] {}))
				.distinct(true))
				.setFirstResult(pageable.getPageNumber() * pageable.getPageSize())
				.setMaxResults(pageable.getPageSize());

		int totalRows = typedQuery.getResultList().size();

		Page<PermissionsEntity> result = new PageImpl<PermissionsEntity>(typedQuery.getResultList(), pageable, totalRows);
		return result;
	}
	

}



