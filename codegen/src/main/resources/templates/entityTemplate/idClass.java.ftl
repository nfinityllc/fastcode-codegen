package [=PackageName].domain.model;

import java.io.Serializable;

public class [=ClassName]Id implements Serializable {

<#list Fields as key,value>
 <#if value.isPrimaryKey !false>
 <#if value.fieldType?lower_case == "long">
  private Long [=value.fieldName];
 <#elseif value.fieldType?lower_case == "int" >
  private int [=value.fieldName];
 <#elseif value.fieldType?lower_case == "short" >
  private short [=value.fieldName];
 <#elseif value.fieldType?lower_case == "double" >
  private Double [=value.fieldName];
 <#elseif value.fieldType?lower_case == "string">
  private String [=value.fieldName];
 </#if> 
 </#if>
</#list>
    public [=ClassName]Id() {

    }
    public [=ClassName]Id(<#list PrimaryKeys?keys as key><#if key_has_next>[=PrimaryKeys[key]] [=key],<#else>[=PrimaryKeys[key]] [=key]</#if></#list>) {
    <#list Fields as key,value>
    <#if value.isPrimaryKey !false>
  		this.[=value.fieldName] =[=value.fieldName];
    </#if>
    </#list>
    }
    
    <#list Fields as key,value>
 <#if value.isPrimaryKey !false>
 <#if value.fieldType?lower_case == "long">
    public Long get[=value.fieldName?cap_first]() {
        return [=value.fieldName];
    }
    public void set[=value.fieldName?cap_first](Long [=value.fieldName]){
        this.[=value.fieldName] = [=value.fieldName];
    }
 <#elseif value.fieldType?lower_case == "int" >
    public int get[=value.fieldName?cap_first]() {
        return [=value.fieldName];
    }
    public void set[=value.fieldName?cap_first](int [=value.fieldName]){
        this.[=value.fieldName] = [=value.fieldName];
    }
 <#elseif value.fieldType?lower_case == "short" >
    public short get[=value.fieldName?cap_first]() {
        return [=value.fieldName];
    }
    public void set[=value.fieldName?cap_first](short [=value.fieldName]){
        this.[=value.fieldName] = [=value.fieldName];
    }
 <#elseif value.fieldType?lower_case == "double" >
    public Double get[=value.fieldName?cap_first]() {
        return [=value.fieldName];
    }
    public void set[=value.fieldName?cap_first](Double [=value.fieldName]){
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
 </#if>
</#list>
    
}