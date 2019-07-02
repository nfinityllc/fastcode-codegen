package [=PackageName].application.[=ClassName].Dto;

import java.util.Date;

public class Get[=RelationEntityName]Output {
 <#list RelationEntityFields as value>
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
<#list Relationship as relationKey,relationValue>
 <#if relationValue.relation == "ManyToMany"   && relationValue.entityDescriptionField?? >
  <#if relationValue.entityDescriptionField.isPrimaryKey ==false>
  <#if relationValue.entityDescriptionField.fieldType?lower_case == "long" || relationValue.entityDescriptionField.fieldType?lower_case == "int">
  private Long [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "boolean">
  private Boolean [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "date">
  private Date [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "string">
  private String [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  </#if> 
  </#if>
  </#if>
</#list>
<#list Fields as fkey,fvalue>
 <#if fvalue.isPrimaryKey?string('true','false') == "true" >
 <#if fvalue.fieldType?lower_case == "long" || fvalue.fieldType?lower_case == "int">
  private Long [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  
  public Long get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](Long [=ClassName?uncap_first][=fvalue.fieldName?cap_first]){
  this.[=ClassName?uncap_first][=fvalue.fieldName?cap_first] = [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }
  <#elseif fvalue.fieldType?lower_case == "boolean">
  private Boolean [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  
  public Boolean get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](Boolean [=ClassName?uncap_first][=fvalue.fieldName?cap_first]){
  this.[=ClassName?uncap_first][=fvalue.fieldName?cap_first] = [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }
  <#elseif fvalue.fieldType?lower_case == "date">
  private Date [=ClassName?uncap_first][=fvalue.fieldName];
  
  public Date get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](Date [=ClassName?uncap_first][=fvalue.fieldName?cap_first]){
  this.[=ClassName?uncap_first][=fvalue.fieldName?cap_first] = [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }
  <#elseif fvalue.fieldType?lower_case == "string">
  private String [=ClassName?uncap_first][=fvalue.fieldName];
  
  public String get[=ClassName?cap_first][=fvalue.fieldName?cap_first]() {
  return [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }

  public void set[=ClassName?cap_first][=fvalue.fieldName?cap_first](String [=ClassName?uncap_first][=fvalue.fieldName?cap_first]){
  this.[=ClassName?uncap_first][=fvalue.fieldName?cap_first] = [=ClassName?uncap_first][=fvalue.fieldName?cap_first];
  }
 </#if> 
 </#if>
</#list>
<#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToMany"   && relationValue.entityDescriptionField?? >
  <#if relationValue.entityDescriptionField.isPrimaryKey == false>
  <#if relationValue.entityDescriptionField.fieldType?lower_case == "long" || relationValue.entityDescriptionField.fieldType?lower_case == "int">
  public Long get[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first](Long [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "boolean">
  public Boolean get[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first](Boolean [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "date">
  public Date get[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void setget[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first](Date [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  <#elseif relationValue.entityDescriptionField.fieldType?lower_case == "string">
  public String get[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first]() {
   return [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }

  public void set[=relationValue.cName][=relationValue.entityDescriptionField.fieldName?cap_first](String [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]){
   this.[=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] = [=relationValue.cName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first];
  }
  </#if> 
  </#if>
  </#if>
</#list>
  
  <#list RelationEntityFields as value>
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

}
