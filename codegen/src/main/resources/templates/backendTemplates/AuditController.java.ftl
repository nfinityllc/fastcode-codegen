package com.nfinity.fastcode.ReSTControllers;

<#list entitiesMap as entityKey, entityMap>
import [=entityMap.importPkg];
</#list>

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






















