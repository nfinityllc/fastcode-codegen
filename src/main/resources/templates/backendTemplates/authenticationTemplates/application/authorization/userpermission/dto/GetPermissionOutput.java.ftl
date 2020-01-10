package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto;

public class GetPermissionOutput {
   	private String displayName;
   	private Long id;
   	private String name;

   	private Long [=AuthenticationTable?uncap_first]permissionPermissionId;
  
   	public Long get[=AuthenticationTable]permissionPermissionId() {
   		return [=AuthenticationTable?uncap_first]permissionPermissionId;
   	}

   	public void set[=AuthenticationTable]permissionPermissionId(Long [=AuthenticationTable?uncap_first]permissionPermissionId){
   		this.[=AuthenticationTable?uncap_first]permissionPermissionId = [=AuthenticationTable?uncap_first]permissionPermissionId;
   	}
  
    <#if AuthenticationType!="none" && !UserInput?? >
    private Long [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id;
  
    public Long get[=AuthenticationTable]permission[=AuthenticationTable]Id() {
		return [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id;
	}

    public void set[=AuthenticationTable]permission[=AuthenticationTable]Id(Long [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id){
   		this.[=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id = [=AuthenticationTable?uncap_first]permission[=AuthenticationTable]Id;
    }
    <#elseif AuthenticationType!="none" && UserInput??>
    <#if PrimaryKeys??>
    <#list PrimaryKeys as key,value>
    <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
	private [=value] [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first];
  
	public [=value] get[=AuthenticationTable]permission[=AuthenticationTable?cap_first][=key?cap_first]() {
    	return [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first];
    }

    public void set[=AuthenticationTable]permission[=AuthenticationTable?cap_first][=key?cap_first]([=value] [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first]){
   		this.[=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first] = [=AuthenticationTable?uncap_first]permission[=AuthenticationTable?cap_first][=key?cap_first];
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
