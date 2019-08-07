package com.nfinity.entitycodegen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class RelationDetails {

	String cName;
	String relation;
	String joinColumn;
	String joinColumnType;
	Boolean isJoinColumnOptional;
	String referenceColumn;
	String joinTable;
	String inverseJoinColumn;
	String inverseReferenceColumn;
	String eName;
	String mappedBy;
	String fName;
	Boolean isParent;
	List<FieldDetails> fDetails = new ArrayList<>();
//	FieldDetails entityDescriptionField;

//	public FieldDetails getEntityDescriptionField() {
//		return entityDescriptionField;
//	}
//
//	public void setEntityDescriptionField(FieldDetails descFieldName) {
//		this.entityDescriptionField = descFieldName;
//	}

	public String getRelation() {
		return relation;
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}

	public String getJoinColumn() {
		return joinColumn;
	}

	public void setJoinColumn(String joinColumn) {
		this.joinColumn = joinColumn;
	}

	public String getcName() {
		return cName;
	}

	public void setcName(String cName) {
		this.cName = cName;
	}

	public String geteName() {
		return eName;
	}

	public void seteName(String eName) {
		this.eName = eName;
	}

	public String getfName() {
		return fName;
	}

	public void setfName(String fName) {
		this.fName = fName;
	}

	public String getMappedBy() {
		return mappedBy;
	}

	public void setMappedBy(String mappedBy) {
		this.mappedBy = mappedBy;
	}

	public String getReferenceColumn() {
		return referenceColumn;
	}

	public void setReferenceColumn(String referenceColumn) {
		this.referenceColumn = referenceColumn;
	}

	public String getJoinTable() {
		return joinTable;
	}

	public void setJoinTable(String joinTable) {
		this.joinTable = joinTable;
	}

	public String getInverseJoinColumn() {
		return inverseJoinColumn;
	}

	public void setInverseJoinColumn(String inverseJoinColumn) {
		this.inverseJoinColumn = inverseJoinColumn;
	}

	public String getInverseReferenceColumn() {
		return inverseReferenceColumn;
	}

	public void setInverseReferenceColumn(String inverseReferenceColumn) {
		this.inverseReferenceColumn = inverseReferenceColumn;
	}

	public Boolean getIsParent() {
		return isParent;
	}

	public void setIsParent(Boolean isParent) {
		this.isParent = isParent;
	}

	public List<FieldDetails> getfDetails() {
		return fDetails;
	}

	public void setfDetails(List<FieldDetails> fDetails) {
		this.fDetails = fDetails;
	}

	public String getJoinColumnType() {
		return joinColumnType;
	}

	public void setJoinColumnType(String joinColumnType) {
		this.joinColumnType = joinColumnType;
	}

	public Boolean getIsJoinColumnOptional() {
		return isJoinColumnOptional;
	}

	public void setIsJoinColumnOptional(Boolean isJoinColumnOptional) {
		this.isJoinColumnOptional = isJoinColumnOptional;
	}

	public Map<String,FieldDetails> FindAndSetDescriptiveField(Map<String,FieldDetails> descriptiveFieldEntities) {
		FieldDetails descriptiveField = null;
		
		if (this.getRelation() == "ManyToOne" || this.getRelation() == "ManyToMany") {

//			if (this.getRelation() == "ManyToMany") {
//				for (String str : manyToManyRshp) {
//					int indexOfDash = str.indexOf('-');
//					String before = str.substring(0, indexOfDash);
//					String after = str.substring(indexOfDash+1);
//					if (before.equals(this.geteName())) {
//						if(!descriptiveFieldEntities.containsKey(this.geteName()))
//						{
//						descriptiveField = GetUserInput.getEntityDescriptionField(this.geteName(), this.getfDetails());
//						descriptiveFieldEntities.put(this.geteName(),descriptiveField);
//						}
//					}
//					if(after.equals(this.getcName()))
//					{
//						if(!descriptiveFieldEntities.containsKey(this.getcName()))
//						{
//						descriptiveField = GetUserInput.getEntityDescriptionField(this.getcName(), this.getfDetails());
//						descriptiveFieldEntities.put(this.getcName(),descriptiveField);
//						}
//					}
//				}
//			} else {
				descriptiveField = GetUserInput.getEntityDescriptionField(this.geteName(), this.getfDetails());
				descriptiveFieldEntities.put(this.geteName(),descriptiveField);
//			}
//			if (descriptiveField != null) {
//				this.setEntityDescriptionField(descriptiveField);
//				// descriptiveMap.put(entry.getKey(),
//				// entry.getValue().getEntityDescriptionField());
//			}
		}
		return descriptiveFieldEntities;
	}
}
