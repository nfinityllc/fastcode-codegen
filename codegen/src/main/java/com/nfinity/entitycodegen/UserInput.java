package com.nfinity.entitycodegen;

import java.util.List;

public class UserInput {
	String packageName;
	String groupArtifactId;
	String generationType;
	String destinationPath;
	String schemaName;
	String connectionStr;
	List<String> tablesList;
	Boolean audit;
	Boolean history;
	
	
	public String getGroupArtifactId() {
		return groupArtifactId;
	}
	public void setGroupArtifactId(String groupArtifactId) {
		this.groupArtifactId = groupArtifactId;
	}
	public String getGenerationType() {
		return generationType;
	}
	public void setGenerationType(String generationType) {
		this.generationType = generationType;
	}
	
	public String getPackageName() {
		return packageName;
	}
	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}
	public String getDestinationPath() {
		return destinationPath;
	}
	public void setDestinationPath(String destinationPath) {
		this.destinationPath = destinationPath;
	}
	public String getSchemaName() {
		return schemaName;
	}
	public void setSchemaName(String schemaName) {
		this.schemaName = schemaName;
	}
	public String getConnectionStr() {
		return connectionStr;
	}
	public void setConnectionStr(String connectionStr) {
		this.connectionStr = connectionStr;
	}
	public Boolean getAudit() {
		return audit;
	}
	public void setAudit(Boolean audit) {
		this.audit = audit;
	}
	public List<String> getTablesList() {
		return tablesList;
	}
	public void setTablesList(List<String> tablesList) {
		this.tablesList = tablesList;
	}
	public Boolean getHistory() {
		return history;
	}
	public void setHistory(Boolean history) {
		this.history = history;
	}	
	
}

