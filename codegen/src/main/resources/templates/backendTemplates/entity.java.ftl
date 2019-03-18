package com.nfinity.fastcode.domain.Authorization.${PackageName};

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import javax.validation.constraints.Email;

import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import com.nfinity.fastcode.domain.BaseClasses.AuditedEntity;

@Entity
@Table(name = "${ClassName}", schema = "dbo")
@EntityListeners(AuditingEntityListener.class)

public class ${ClassName}Entity extends AuditedEntity<String> implements Serializable {
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
 <#if value.fieldType?lower_case == "long">
  <#if value.fieldName?lower_case == "id"> 
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  </#if>
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Long get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Long ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
  
  <#elseif value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
  <#if value.fieldName?lower_case != "id"> 
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Long get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Long ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
  </#if>
  
  <#elseif value.fieldType?lower_case == "boolean">
  
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Boolean get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Boolean ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
  <#elseif value.fieldType?lower_case == "date">
  
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')})
  public Date get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(Date ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
  <#elseif value.fieldType?lower_case == "string">
  
  @Basic
  @Column(name = "${value.fieldName}", nullable = ${value.isNullable?string('true','false')}, length = ${value.length})
  public String get${value.fieldName?cap_first}() {
  return ${value.fieldName};
  }

  public void set${value.fieldName?cap_first}(String ${value.fieldName}){
  this.${value.fieldName} = ${value.fieldName};
  }
 
 </#if> 
</#list>
 
}

  
      


