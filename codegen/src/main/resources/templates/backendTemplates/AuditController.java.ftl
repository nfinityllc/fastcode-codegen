package [=PackageName].RestControllers;

<#list entitiesMap as entityKey, entityMap>
import [=entityMap.importPkg];
</#list>
<#if AuthenticationType == "database">
import [=PackageName].domain.model.UserEntity;
</#if>
<#if AuthenticationType != "none">
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.PermissionEntity;
</#if>
 
import org.javers.core.Javers;
import org.javers.core.diff.Change;
import org.javers.repository.jql.JqlQuery;
import org.javers.repository.jql.QueryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/audit")
public class AuditController {

    private final Javers javers;

    @Autowired
    public AuditController(Javers javers) {
        this.javers = javers;
    }
    <#if AuthenticationType == "database">
    @RequestMapping("/user")
    public String getUserChanges() {
        QueryBuilder jqlQuery = QueryBuilder.byClass(UserEntity.class);
        List<Change> changes = javers.findChanges(jqlQuery.build());
        return javers.getJsonConverter().toJson(changes);
    }
    </#if>
    <#if AuthenticationType != "none">
    @RequestMapping("/role")
    public String getRoleChanges() {
        QueryBuilder jqlQuery = QueryBuilder.byClass(RoleEntity.class);
        List<Change> changes = javers.findChanges(jqlQuery.build());
        return javers.getJsonConverter().toJson(changes);
    }

    @RequestMapping("/permission")
    public String getPermissionChanges() {
        QueryBuilder jqlQuery = QueryBuilder.byClass(PermissionEntity.class);
        List<Change> changes = javers.findChanges(jqlQuery.build());
        return javers.getJsonConverter().toJson(changes);
    }
    </#if>

		<#list entitiesMap as entityKey, entityMap>
    @RequestMapping("[=entityMap.requestMapping]")
    public String [=entityMap.method]() {
        QueryBuilder jqlQuery = QueryBuilder.byClass([=entityMap.entity].class);
        List<Change> changes = javers.findChanges(jqlQuery.build());
        return javers.getJsonConverter().toJson(changes);
    }
		</#list>
    
    @RequestMapping("/changes")
    public String getAllChanges() {
        JqlQuery jqlQuery = QueryBuilder.anyDomainObject().withNewObjectChanges().build();
        List<Change> changes = javers.findChanges(jqlQuery);
        return javers.getJsonConverter().toJson(changes);
    }

}

