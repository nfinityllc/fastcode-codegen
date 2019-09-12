export interface I[=AuthenticationTable]permission {  

	permissionId: number;
	permissionName?: string;
	<#if AuthenticationType=="database" && !UserInput??>
	[=AuthenticationTable?uncap_first]Id?: string;
	[=AuthenticationTable?uncap_first]Username?: string;
	<#elseif AuthenticationType=="database" && UserInput??>
	<#if PrimaryKeys??>
	<#list PrimaryKeys as key,value>
	<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
	[=AuthenticationTable?uncap_first + value.fieldName?cap_first] : number;
	<#elseif value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
	[=AuthenticationTable?uncap_first + value.fieldName?cap_first] : string;
	<#elseif value.fieldType?lower_case == "boolean">
	[=AuthenticationTable?uncap_first + value.fieldName?cap_first] : boolean;
	</#if> 
	</#list>
	</#if>
	<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
	<#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
	[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first]: string;
	</#if>
    <#else>
	<#if AuthenticationFields??>
  	<#list AuthenticationFields as authKey,authValue>
  	<#if authKey== "User Name">
  	<#if !PrimaryKeys[authValue.fieldName]??>
  	[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]: string;
  	</#if>
    </#if>
    </#list>
    </#if>
	</#if>
	</#if>
  }
