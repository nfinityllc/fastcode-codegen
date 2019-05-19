package com.nfinity.entitycodegen;

import java.util.ArrayList;
import java.util.List;

public class ClassDetails {

	List<Class<?>> classesList = new ArrayList<Class<?>>();
	List<String> relationClassesList = new ArrayList<String>();

	public ClassDetails(List<Class<?>> classesList, List<String> relationClassesList) {
		super();
		this.classesList = classesList;
		this.relationClassesList = relationClassesList;
	}

	public List<Class<?>> getClassesList() {
		return classesList;
	}

	public void setClassesList(List<Class<?>> classesList) {
		this.classesList = classesList;
	}

	public List<String> getRelationClassesList() {
		return relationClassesList;
	}

	public void setRelationClassesList(List<String> relationClassesList) {
		this.relationClassesList = relationClassesList;
	}

}
