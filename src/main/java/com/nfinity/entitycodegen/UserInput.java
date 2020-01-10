package com.nfinity.entitycodegen;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UserInput {
	
	@Autowired
	EntityDetails entityDetails;
	
	String packageName;
	String groupArtifactId;
	String generationType;
	String destinationPath;
	String schemaName;
	String connectionStr;
	List<String> tablesList;
	Boolean cache=false;
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
	
	public String getInput(Scanner inputReader, String inputType) {

		System.out.print("Please enter value for " + inputType + ":");
		String value = inputReader.nextLine();
		return value;
	}
	
	public List<FieldDetails> getFilteredFieldsList(List<FieldDetails> fields)
	{
		List<FieldDetails> fieldsList = new ArrayList<>();
		for (FieldDetails f : fields) {
			if (f.fieldType.equalsIgnoreCase("long") || f.fieldType.equalsIgnoreCase("integer") || f.fieldType.equalsIgnoreCase("double")
					|| f.fieldType.equalsIgnoreCase("short") || f.fieldType.equalsIgnoreCase("string") || f.fieldType.equalsIgnoreCase("boolean")
					|| f.fieldType.equalsIgnoreCase("timestamp") || f.fieldType.equalsIgnoreCase("date"))
				fieldsList.add(f);
		}
		return fieldsList;
	}
	
	public int getFieldsInput(int size)
	{
		System.out.print("\nPlease enter value between (1-" +size+ ") :");
		Scanner scanner = new Scanner(System.in);
		int index = scanner.nextInt();
		while (index < 1 || index > size) {
			System.out.println("\nInvalid Input \nEnter again :");
			index = scanner.nextInt();
		}
		return index;
	}
	
	public FieldDetails getEntityDescriptionField(String entityName, List<FieldDetails> fields) {
		int index = 1;
		StringBuilder builder = new StringBuilder(MessageFormat.format(
				"\nSelect a descriptive field of {0} entity by typing their corresponding number: ", entityName));

		List<FieldDetails> fieldsList = getFilteredFieldsList(fields);
		
		for (FieldDetails f : fieldsList) {
			builder.append(MessageFormat.format("{0}.{1} ", index, f.getFieldName()));
			index++;
		}
		System.out.println(builder.toString());
		index= getFieldsInput(fieldsList.size());

		FieldDetails selected = fieldsList.get(index - 1);
		return selected;
	}
}

