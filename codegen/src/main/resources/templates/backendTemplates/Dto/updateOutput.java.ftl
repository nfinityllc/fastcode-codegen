package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;
public class Update[=ClassName]Output {

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  private Long [=value.fieldName];
 <#elseif value.fieldType?lower_case == "boolean">
  private Boolean [=value.fieldName];
 <#elseif value.fieldType?lower_case == "date">
  private Date [=value.fieldName];
<#elseif value.fieldType?lower_case == "string">
  private String [=value.fieldName];
 </#if> 
</#list>
<#if Audit!false>
  private String creatorUserId;
  private java.util.Date creationTime;
  private String lastModifierUserId;
  private java.util.Date lastModificationTime;
</#if>

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  public Long get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](Long [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 <#elseif value.fieldType?lower_case == "boolean">
  public Boolean get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](Boolean [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 <#elseif value.fieldType?lower_case == "date">
  public Date get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](Date [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 <#elseif value.fieldType?lower_case == "string">
  public String get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first](String [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
 </#if> 
</#list>
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
