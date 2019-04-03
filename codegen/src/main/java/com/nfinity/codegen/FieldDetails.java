package com.nfinity.codegen;

public class FieldDetails {

	String fieldName;
	String fieldType;
	boolean isNullable;
	boolean isPrimaryKey;
	int length;
	// EntityRelationship eRelation = new EntityRelationship();

	public String getFieldName() {
		return fieldName;
	}

	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	public String getFieldType() {
		return fieldType;
	}

	public void setFieldType(String fieldType) {
		this.fieldType = fieldType;
	}

	public boolean getIsNullable() {
		return isNullable;
	}

	public void setIsNullable(boolean isNullable) {
		this.isNullable = isNullable;
	}

	public boolean getIsPrimaryKey() {
		return isPrimaryKey;
	}

	public void setIsPrimaryKey(boolean isPrimaryKey) {
		this.isPrimaryKey = isPrimaryKey;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}
	// public EntityRelationship getERelation() {
	// return eRelation;
	// }
	// public void setERelation(EntityRelationship eRelation) {
	// this.eRelation = eRelation;
	// }

}
