package com.nfinity.entitycodegen;

public class UserInput {

	String packageName;
	String destinationPath;
	String schemaName;
	Boolean audit;
	String auditPackage;
	
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
	public Boolean getAudit() {
		return audit;
	}
	public void setAudit(Boolean audit) {
		this.audit = audit;
	}
	public String getAuditPackage() {
		return auditPackage;
	}
	public void setAuditPackage(String auditPackage) {
		this.auditPackage = auditPackage;
	}	
	
	
}
