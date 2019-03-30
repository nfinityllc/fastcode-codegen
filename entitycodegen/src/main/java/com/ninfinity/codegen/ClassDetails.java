package com.ninfinity.codegen;

import java.util.ArrayList;
import java.util.List;

public class ClassDetails {
	
	List<String> classesList = new ArrayList<>();
	List<String> relationClassesList = new ArrayList<>();
	
	public ClassDetails(List<String> classesList, List<String> relationClassesList) {
		super();
		this.classesList = classesList;
		this.relationClassesList = relationClassesList;
	}
	public List<String> getClassesList() {
		return classesList;
	}
	public void setClassesList(List<String> classesList) {
		this.classesList = classesList;
	}
	public List<String> getRelationClassesList() {
		return relationClassesList;
	}
	public void setRelationClassesList(List<String> relationClassesList) {
		this.relationClassesList = relationClassesList;
	}
	
}
