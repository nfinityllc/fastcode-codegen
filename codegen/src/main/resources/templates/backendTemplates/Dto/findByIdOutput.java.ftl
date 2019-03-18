package com.nfinity.fastcode.application.Authorization.${PackageName}.Dto;

import java.util.Date;
public class Find${ClassName}ByIdOutput {

<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  private Long ${value.fieldName};
 <#elseif value.fieldType?lower_case == "boolean">
  private Boolean ${value.fieldName};
 <#elseif value.fieldType?lower_case == "date">
  private Date ${value.fieldName};
<#elseif value.fieldType?lower_case == "string">
  private String ${value.fieldName};
 </#if> 
</#list>


<#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  public Long get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Long ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 <#elseif value.fieldType?lower_case == "boolean">
  public Boolean get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Boolean ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 <#elseif value.fieldType?lower_case == "date">
  public Date get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Date ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 <#elseif value.fieldType?lower_case == "string">
  public String get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(String ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 </#if> 
</#list>
 
}