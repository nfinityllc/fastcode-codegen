package [=PackageName].application.EmailVariable.Dto;

public class FindEmailVariableByNameOutput {

	private Long id;
	private String propertyName;
	private String propertyType;
    private String defaultValue;
    <#if Audit!false>
  	private String creatorUserId;
  	private java.util.Date creationTime;
  	private String lastModifierUserId;
  	private java.util.Date lastModificationTime;
	</#if>
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getPropertyName() {
		return propertyName;
	}

	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}

	public String getPropertyType() {
		return propertyType;
	}

	public void setPropertyType(String propertyType) {
		this.propertyType = propertyType;
	}

	public String getDefaultValue() {
		return defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	<#if Audit!false>
  	public java.util.Date getCreationTime() {
      	return creationTime;
  	}

  	public void setCreationTime(java.util.Date creationTime) {
      	this.creationTime = creationTime;
  	}

  	public String getLastModifierUserId() {
      	return lastModifierUserId;
  	}

  	public void setLastModifierUserId(String lastModifierUserId) {
      	this.lastModifierUserId = lastModifierUserId;
  	}

  	public java.util.Date getLastModificationTime() {
      	return lastModificationTime;
  	}

  	public void setLastModificationTime(java.util.Date lastModificationTime) {
      	this.lastModificationTime = lastModificationTime;
  	}

  	public String getCreatorUserId() {
      	return creatorUserId;
  	}
    </#if>
}
