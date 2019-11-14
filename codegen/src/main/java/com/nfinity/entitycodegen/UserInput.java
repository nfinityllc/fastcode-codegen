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
	Boolean cache=false;
//	Boolean audit=false;
	Boolean email;
	Boolean scheduler;
	Boolean history=false;
	Boolean flowable;
	String authenticationType=null;
	String authenticationSchema=null;
	Boolean doUpgrade;

	
	public Boolean getCache() {
		return cache;
	}
	public void setCache(Boolean cache) {
		this.cache = cache;
	}
	public String getAuthenticationSchema() {
		return authenticationSchema;
	}
	public void setAuthenticationSchema(String authenticationSchema) {
		this.authenticationSchema = authenticationSchema;
	}
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
//	public Boolean getAudit() {
//		return audit;
//	}
//	public void setAudit(Boolean audit) {
//		this.audit = audit;
//	}
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
	public Boolean getEmail() {
		return email;
	}
	public void setEmail(Boolean email) {
		this.email = email;
	}
	
	public Boolean getFlowable() {
		return flowable;
	}
	public void setFlowable(Boolean flowable) {
		this.flowable = flowable;
	}
	public Boolean getScheduler() {
		return scheduler;
	}
	public void setScheduler(Boolean scheduler) {
		this.scheduler = scheduler;
	}
	public String getAuthenticationType() {
		return authenticationType;
	}
	public void setAuthenticationType(String authenticationType) {
		this.authenticationType = authenticationType;
	}
	public Boolean getUpgrade() { return doUpgrade; }
	public void setUpgrade(Boolean doUpgrade) { this.doUpgrade = doUpgrade; }
}

