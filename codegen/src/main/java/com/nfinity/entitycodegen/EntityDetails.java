package com.nfinity.entitycodegen;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class EntityDetails {

	Map<String,FieldDetails> fieldsMap= new HashMap<>();
	Map<String,RelationDetails> relationsMap = new HashMap<>();
	List<String> relationInput = new ArrayList<>();
	
	public EntityDetails(Map<String, FieldDetails> fieldsMap, Map<String, RelationDetails> relationsMap) {
		super();
		this.fieldsMap = fieldsMap;
		this.relationsMap = relationsMap;
	}
	public Map<String, FieldDetails> getFieldsMap() {
		return fieldsMap;
	}
	public void setFieldsMap(Map<String, FieldDetails> fieldsMap) {
		this.fieldsMap = fieldsMap;
	}
	public Map<String, RelationDetails> getRelationsMap() {
		return relationsMap;
	}
	public void setRelationsMap(Map<String, RelationDetails> relationsMap) {
		this.relationsMap = relationsMap;
	}
	public List<String> getRelationInput() {
		return relationInput;
	}
	public void setRelationInput(List<String> relationInput) {
		this.relationInput = relationInput;
	}
	
	
}
