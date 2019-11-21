package [=PackageName].domain.model;

import java.io.Serializable;

public class [=ClassName]Id implements Serializable {

<#list Fields as key,value>
 <#if value.isPrimaryKey !false>
 <#if value.fieldType?lower_case == "long">
    private Long [=value.fieldName];
 <#elseif value.fieldType?lower_case == "integer" >
    private Integer [=value.fieldName];
 <#elseif value.fieldType?lower_case == "short" >
    private Short [=value.fieldName];
 <#elseif value.fieldType?lower_case == "double" >
    private Double [=value.fieldName];
 <#elseif value.fieldType?lower_case == "string">
    private String [=value.fieldName];
 </#if> 
 </#if>
</#list>

    public [=ClassName]Id() {
    }
    
    public [=ClassName]Id(<#list PrimaryKeys?keys?sort as key><#if key_has_next>[=PrimaryKeys[key]] [=key],<#else>[=PrimaryKeys[key]] [=key]</#if></#list>) {
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
 <#elseif value.fieldType?lower_case == "integer" >
    public Integer get[=value.fieldName?cap_first]() {
        return [=value.fieldName];
    }
    public void set[=value.fieldName?cap_first](Integer [=value.fieldName]){
        this.[=value.fieldName] = [=value.fieldName];
    }
 <#elseif value.fieldType?lower_case == "short" >
    public Short get[=value.fieldName?cap_first]() {
        return [=value.fieldName];
    }
    public void set[=value.fieldName?cap_first](Short [=value.fieldName]){
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