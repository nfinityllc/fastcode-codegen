export interface [=IEntity] {  

 <#list Fields as key,value>
 <#if value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "int"> 
      [=value.fieldName]: number;
 <#elseif value.fieldType?lower_case == "boolean">
      [=value.fieldName]?: boolean;
 <#elseif value.fieldType?lower_case == "date">
      [=value.fieldName]?: string;
<#elseif value.fieldType?lower_case == "string">
      [=value.fieldName]?: string;
 </#if> 
</#list>
  }
