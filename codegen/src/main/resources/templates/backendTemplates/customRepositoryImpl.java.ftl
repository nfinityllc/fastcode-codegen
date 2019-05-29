package [=PackageName].domain.IRepository;

import java.util.Date;
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

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import [=PackageName].Search.*;
import [=PackageName].domain.model.[=ClassName]Entity;
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if parent?keep_after("-") == relationValue.eName>
import [=PackageName].domain.model.[=relationValue.eName]Entity;

@Repository
public class [=ClassName]CustomRepositoryImpl implements [=ClassName]CustomRepository{

	@PersistenceContext
	private EntityManager entityManager;

	public Page<[=relationValue.eName]Entity> getAll[=relationValue.eName](Long [=ClassName?uncap_first]Id, List<SearchFields> search,String operator, Pageable pageable)  {

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<[=relationValue.eName]Entity> criteriaQuery = criteriaBuilder
				.createQuery([=relationValue.eName]Entity.class);

		Root<[=relationValue.eName]Entity> from[=relationValue.eName] = criteriaQuery.from([=relationValue.eName]Entity.class);
		Join<[=relationValue.eName]Entity, [=ClassName]Entity> join = from[=relationValue.eName].join("[=relationValue.eName]");
		List<Predicate> conditions = new ArrayList();
		if(operator.equalsIgnoreCase("notEqual"))
		conditions.add(criteriaBuilder.notEqual(join.get("id"), [=ClassName?uncap_first]Id));
		else
		conditions.add(criteriaBuilder.equal(join.get("id"), [=ClassName?uncap_first]Id));
		
		for(SearchFields s: search)
		{
		<#list relationValue.fDetails as fValue>
		<#if fValue.fieldType?lower_case == "string">
			if(s.getFieldName().equals("[=fValue.fieldName]")) {
				if(s.getOperator().equals("contains"))
					conditions.add(criteriaBuilder.like(criteriaBuilder.upper(from[=relationValue.eName].get("[=fValue.fieldName]")),"%"+ s.getSearchValue().toUpperCase() + "%"));
				else if(s.getOperator().equals("equals"))
					conditions.add(criteriaBuilder.equal(criteriaBuilder.upper(from[=relationValue.eName].get("[=fValue.fieldName]")),s.getSearchValue().toUpperCase()));
				else if(s.getOperator().equals("notEqual"))
					conditions.add(criteriaBuilder.notEqual(criteriaBuilder.upper(from[=relationValue.eName].get("[=fValue.fieldName]")),s.getSearchValue().toUpperCase()));
			}
		<#elseif fValue.fieldType?lower_case == "long" || fValue.fieldType?lower_case == "int">
		<#if fValue.fieldName?lower_case !="id">
			if(s.getFieldName().equals("[=fValue.fieldName]")) {
				if(s.getOperator().equals("equals") && StringUtils.isNumeric(s.getSearchValue()))
					conditions.add(criteriaBuilder.equal(from[=relationValue.eName].get("[=fValue.fieldName]"),Long.valueOf(s.getSearchValue())));
				else if(s.getOperator().equals("notEqual") && StringUtils.isNumeric(s.getSearchValue()))
					conditions.add(criteriaBuilder.notEqual(from[=relationValue.eName].get("[=fValue.fieldName]"),Long.valueOf(s.getSearchValue())));
				else if(s.getOperator().equals("range"))
				{
					if(StringUtils.isNumeric(s.getStartingValue()) && StringUtils.isNumeric(s.getEndingValue()))
				       conditions.add(criteriaBuilder.between(from[=relationValue.eName].get("[=fValue.fieldName]"),Long.valueOf(s.getStartingValue()), Long.valueOf(s.getEndingValue())));
                   else if(StringUtils.isNumeric(s.getStartingValue()))
                	   conditions.add(criteriaBuilder.greaterThanOrEqualTo(from[=relationValue.eName].get("[=fValue.fieldName]"),Long.valueOf(s.getStartingValue())));
                   else if(StringUtils.isNumeric(s.getEndingValue()))
                	  conditions.add(criteriaBuilder.lessThanOrEqualTo(from[=relationValue.eName].get("[=fValue.fieldName]"),Long.valueOf(s.getStartingValue())));
				}
			}
		</#if>
        <#elseif fValue.fieldType?lower_case == "boolean">
			if(s.getFieldName().equals("[=fValue.fieldName]")) {
				if(s.getOperator().equals("equals") && (s.getSearchValue().equalsIgnoreCase("true") || s.getSearchValue().equalsIgnoreCase("false")))
					conditions.add(criteriaBuilder.equal(from[=relationValue.eName].get("[=fValue.fieldName]"),Boolean.parseBoolean(s.getSearchValue())));
				else if(s.getOperator().equals("notEqual") && (s.getSearchValue().equalsIgnoreCase("true") || s.getSearchValue().equalsIgnoreCase("false")))
					conditions.add(criteriaBuilder.notEqual(from[=relationValue.eName].get("[=fValue.fieldName]"),Boolean.parseBoolean(s.getSearchValue())));
			}
		<#elseif fValue.fieldType?lower_case == "date">
			if(s.getFieldName().equals("[=fValue.fieldName]")) {
				if(s.getOperator().equals("equals") && SearchUtils.stringToDate(s.getSearchValue()) !=null)
				    conditions.add(criteriaBuilder.equal(from[=relationValue.eName].get("[=fValue.fieldName]"),SearchUtils.stringToDate(s.getSearchValue())));
				else if(s.getOperator().equals("notEqual") && SearchUtils.stringToDate(s.getSearchValue()) !=null)
					conditions.add(criteriaBuilder.notEqual(from[=relationValue.eName].get("[=fValue.fieldName]"),SearchUtils.stringToDate(s.getSearchValue())));
				else if(s.getOperator().equals("range"))
				{
				   Date startDate= SearchUtils.stringToDate(s.getStartingValue());
				   Date endDate= SearchUtils.stringToDate(s.getEndingValue());
				   if(startDate!=null && endDate!=null)	 
				       conditions.add(criteriaBuilder.between(from[=relationValue.eName].get("[=fValue.fieldName]"),startDate,endDate));
				   else if(endDate!=null)
					  conditions.add(criteriaBuilder.lessThanOrEqualTo(from[=relationValue.eName].get("[=fValue.fieldName]"),endDate));
                   else if(startDate!=null)
                	  conditions.add(criteriaBuilder.greaterThanOrEqualTo(from[=relationValue.eName].get("[=fValue.fieldName]"),startDate));
                 }
			}
		</#if>
        </#list>
			
		}

		TypedQuery<[=relationValue.eName]Entity> typedQuery = entityManager.createQuery(criteriaQuery
				.select(from[=relationValue.eName])
				.where(conditions.toArray(new Predicate[] {}))
				.distinct(true))
				.setFirstResult(pageable.getPageNumber() * pageable.getPageSize())
				.setMaxResults(pageable.getPageSize());

		int totalRows = typedQuery.getResultList().size();

		Page<[=relationValue.eName]Entity> result = new PageImpl<[=relationValue.eName]Entity>(typedQuery.getResultList(), pageable, totalRows);
		return result;
	}
	

}
</#if>
</#list>
</#if>
</#list>



