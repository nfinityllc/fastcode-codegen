package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;
public class Find[=ClassName]ByIdOutput {

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
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne">
  private [=relationValue.joinColumnType] [=relationValue.joinColumn];
</#if>
 <#if relationValue.relation == "ManyToOne" && relationValue.entityDescriptionField?? >
  <#if relationValue.entityDescriptionField.isPrimaryKey == false>
  <#if relationValue.entityDescriptionField.fieldType?lower_case == "long" || relationValue.entityDescriptionField.fieldType?lower_case == "int">
  private Long [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "boolean">
  private Boolean [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "date">
  private Date [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "string">
  private String [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  </#if>

  </#if>
  </#if>
</#list>

<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne">
<#if relationValue.joinColumnType?lower_case == "long">
  public Long get[=relationValue.joinColumn?cap_first]() {
  return [=relationValue.joinColumn];
  }

  public void set[=relationValue.joinColumn?cap_first](Long [=relationValue.joinColumn]){
  this.[=relationValue.joinColumn] = [=relationValue.joinColumn];
  }
</#if> 
</#if>
  <#if relationValue.relation == "ManyToOne" && relationValue.entityDescriptionField?? >
  <#if relationValue.entityDescriptionField.isPrimaryKey == false>
  <#if relationValue.entityDescriptionField.fieldType?lower_case == "long" || relationValue.entityDescriptionField.fieldType?lower_case == "int">
  public Long get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Long [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "boolean">
  public Boolean get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Boolean [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "date">
  public Date get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void setget[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Date [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "string">
  public String get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](String [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  </#if>
  </#if>
  </#if>
</#list>
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

  public void setCreatorUserId(String creatorUserId) {
      this.creatorUserId = creatorUserId;
  }
</#if>
 
}
