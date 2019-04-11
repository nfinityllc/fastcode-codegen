package com.nfinity.entitycodegen;

public class RelationDetails {
	
	String relation;
	String joinColumn;
	String referenceColumn;
	String joinTable;
	String inverseJoinColumn;
	String inverseReferenceColumn;
	String eName;
	String mappedBy;
	String fName;
	Boolean isParent;
	
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
	
	
}
