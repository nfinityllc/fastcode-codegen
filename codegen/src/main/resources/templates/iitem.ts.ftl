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
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne">
<#if relationValue.isJoinColumnOptional==false>
 <#if relationValue.joinColumnType?lower_case == "long" ||  relationValue.joinColumnType?lower_case == "int"> 
      [=relationValue.joinColumn]: number;
  <#elseif relationValue.joinColumnType?lower_case == "boolean">
      [=relationValue.joinColumn]: boolean;
  <#else>    
      [=relationValue.joinColumn]: string;
  </#if>
  <#else>   
      [=relationValue.joinColumn]?: [=relationValue.joinColumnType];   
</#if>
</#if>
</#list>
  }
