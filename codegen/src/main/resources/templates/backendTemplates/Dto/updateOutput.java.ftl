package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;
public class Update[=ClassName]Output {

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  private [=value.fieldType] [=value.fieldName];
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
<#if CompositeKeyClasses?seq_contains(ClassName)>
 <#if !Fields[relationValue.joinColumn]?? >
 private [=relationValue.joinColumnType] [=relationValue.joinColumn];
 </#if>
 <#else>
 private [=relationValue.joinColumnType] [=relationValue.joinColumn];
 </#if>
</#if>
<#if relationValue.relation == "ManyToOne" && relationValue.entityDescriptionField?? >
  <#if relationValue.entityDescriptionField.isPrimaryKey == false>
  <#if relationValue.entityDescriptionField.fieldType?lower_case == "long">
  private Long [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "integer">
  private Integer [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "short">
  private Short [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "double">
  private Double [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
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
<#if CompositeKeyClasses?seq_contains(ClassName)>
 <#if !Fields[relationValue.joinColumn]?? >
  <#if relationValue.joinColumnType?lower_case == "long" || relationValue.joinColumnType?lower_case == "integer" || relationValue.joinColumnType?lower_case == "short" || relationValue.joinColumnType?lower_case == "double" || relationValue.joinColumnType?lower_case == "string">
  public [=relationValue.joinColumnType?cap_first] get[=relationValue.joinColumn?cap_first]() {
  return [=relationValue.joinColumn];
  }

  public void set[=relationValue.joinColumn?cap_first]([=relationValue.joinColumnType?cap_first] [=relationValue.joinColumn]){
  this.[=relationValue.joinColumn] = [=relationValue.joinColumn];
  }
  </#if>
  </#if>
  <#else> 
  <#if relationValue.joinColumnType?lower_case == "long" || relationValue.joinColumnType?lower_case == "integer" || relationValue.joinColumnType?lower_case == "short" || relationValue.joinColumnType?lower_case == "double" || relationValue.joinColumnType?lower_case == "string">
  public [=relationValue.joinColumnType?cap_first] get[=relationValue.joinColumn?cap_first]() {
  return [=relationValue.joinColumn];
  }

  public void set[=relationValue.joinColumn?cap_first]([=relationValue.joinColumnType?cap_first] [=relationValue.joinColumn]){
  this.[=relationValue.joinColumn] = [=relationValue.joinColumn];
  }
  </#if>
</#if>
</#if>
<#if relationValue.relation == "ManyToOne" && relationValue.entityDescriptionField?? >
  <#if relationValue.entityDescriptionField.isPrimaryKey == false>
  <#if relationValue.entityDescriptionField.fieldType?lower_case == "long">
  public Long get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Long [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "integer">
  public Integer get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Integer [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "short">
  public Short get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Short [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "double">
  public Double get[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.eName][=relationValue.entityDescriptionField.fieldName?cap_first](Double [=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
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
 <#if value.isAutogenerated == false>
  <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean"|| value.fieldType?lower_case == "date"|| value.fieldType?lower_case == "string" >
  public [=value.fieldType?cap_first] get[=value.fieldName?cap_first]() {
  return [=value.fieldName];
  }

  public void set[=value.fieldName?cap_first]([=value.fieldType?cap_first] [=value.fieldName]){
  this.[=value.fieldName] = [=value.fieldName];
  }
  </#if> 
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
