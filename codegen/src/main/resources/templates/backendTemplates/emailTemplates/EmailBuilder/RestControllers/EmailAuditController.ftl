package [=PackageName].RestControllers;

import [=PackageName].domain.model.EmailTemplateEntity;
import [=PackageName].domain.model.EmailVariableEntity;

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
public class EmailAuditController {

    private final Javers javers;

    @Autowired
    public EmailAuditController(Javers javers) {
        this.javers = javers;
    }

    @RequestMapping("/email")
    public String getEmailChanges() {
        QueryBuilder jqlQuery = QueryBuilder.byClass(EmailTemplateEntity.class);
        List<Change> changes = javers.findChanges(jqlQuery.build());
        return javers.getJsonConverter().toJson(changes);
    }
    
     @RequestMapping("/emailvariable")
    public String getEmailVariableChanges() {
        QueryBuilder jqlQuery = QueryBuilder.byClass(EmailVariableEntity.class);
        List<Change> changes = javers.findChanges(jqlQuery.build());
        return javers.getJsonConverter().toJson(changes);
    }
    
    @RequestMapping("/allEmailChanges")
    public String getAllEmailChanges() {
        JqlQuery jqlQuery = QueryBuilder.anyDomainObject().withNewObjectChanges().build();
        List<Change> changes = javers.findChanges(jqlQuery);
        return javers.getJsonConverter().toJson(changes);
    }


}





















