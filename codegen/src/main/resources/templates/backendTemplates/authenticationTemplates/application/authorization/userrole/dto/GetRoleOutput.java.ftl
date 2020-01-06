package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto;

import java.util.Date;

public class GetRoleOutput {
    
    private String displayName;
    private Long id;
    private String name;

    private Long [=AuthenticationTable?uncap_first]roleRoleId;
  
    public Long get[=AuthenticationTable]roleRoleId() {
  		return [=AuthenticationTable?uncap_first]roleRoleId;
    }

    public void set[=AuthenticationTable]roleRoleId(Long [=AuthenticationTable?uncap_first]roleRoleId){
  		this.[=AuthenticationTable?uncap_first]roleRoleId = [=AuthenticationTable?uncap_first]roleRoleId;
    }
  
    <#if AuthenticationType!="none" && !UserInput?? >
    private Long [=AuthenticationTable?uncap_first]role[=AuthenticationTable]Id;
  
    public Long get[=AuthenticationTable]role[=AuthenticationTable]Id() {
		return [=AuthenticationTable?uncap_first]role[=AuthenticationTable]Id;
	}

    public void set[=AuthenticationTable]role[=AuthenticationTable]Id(Long [=AuthenticationTable?uncap_first]role[=AuthenticationTable]Id){
   		this.[=AuthenticationTable?uncap_first]role[=AuthenticationTable]Id = [=AuthenticationTable?uncap_first]role[=AuthenticationTable]Id;
    }
    <#elseif AuthenticationType!="none" && UserInput??>
    <#if PrimaryKeys??>
    <#list PrimaryKeys as key,value>
    <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
	private [=value] [=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first];
  
	public [=value] get[=AuthenticationTable]role[=AuthenticationTable?cap_first][=key?cap_first]() {
    	return [=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first];
    }

    public void set[=AuthenticationTable]role[=AuthenticationTable?cap_first][=key?cap_first]([=value] [=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first]){
   		this.[=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first] = [=AuthenticationTable?uncap_first]role[=AuthenticationTable?cap_first][=key?cap_first];
    }
    </#if> 
    </#list>
    </#if>
    </#if>
    
    public String getDisplayName() {
  		return displayName;
    }

    public void setDisplayName(String displayName){
  		this.displayName = displayName;
    }
    public Long getId() {
  		return id;
    }

    public void setId(Long id){
  		this.id = id;
    }
    public String getName() {
  		return name;
    }

    public void setName(String name){
  		this.name = name;
    }

}
