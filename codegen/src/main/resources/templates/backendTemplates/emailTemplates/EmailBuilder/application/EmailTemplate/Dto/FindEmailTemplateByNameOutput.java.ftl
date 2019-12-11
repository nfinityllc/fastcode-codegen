package [=PackageName].application.EmailTemplate.Dto;

public class FindEmailTemplateByNameOutput {


	private Boolean active;
	private String attachmentpath;
	private Long id;
	private String templateName;
	private String category;
	private String contentHtml;
	private String contentJson;
	private String to;
	private String cc;
	private String bcc;
	private String subject;
	<#if Audit!false>
  	private String creatorUserId;
  	private java.util.Date creationTime;
  	private String lastModifierUserId;
  	private java.util.Date lastModificationTime;
    </#if>

	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active){
		this.active = active;
	}
	public String getAttachmentpath() {
		return attachmentpath;
	}

	public void setAttachmentpath(String attachmentpath){
		this.attachmentpath = attachmentpath;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTemplateName() {
		return templateName;
	}
	public void setTemplateName(String templateName) {
		this.templateName = templateName;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getContentHtml() {
		return contentHtml;
	}
	public void setContentHtml(String contentHtml) {
		this.contentHtml = contentHtml;
	}
	public String getContentJson() {
		return contentJson;
	}
	public void setContentJson(String contentJson) {
		this.contentJson = contentJson;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getCc() {
		return cc;
	}
	public void setCc(String cc) {
		this.cc = cc;
	}
	public String getBcc() {
		return bcc;
	}
	public void setBcc(String bcc) {
		this.bcc = bcc;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
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
