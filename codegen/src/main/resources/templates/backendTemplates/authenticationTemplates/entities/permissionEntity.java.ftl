package [=PackageName].domain.model;

import [=PackageName].domain.model.RolesEntity;
<#if Audit!false>
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import [=PackageName].Audit.AuditedEntity;
</#if>

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Permissions")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>

public class PermissionsEntity <#if Audit!false>extends AuditedEntity<String></#if> implements Serializable {
    private Long id;
    private String name;
    private String displayName;

    public PermissionsEntity() {
    }

    @Id
    @Column(name = "Id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "DisplayName", nullable = true)
    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    @Basic
    @Column(name = "Name", nullable = false, length = 128)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PermissionsEntity)) return false;
        PermissionsEntity permission = (PermissionsEntity) o;
        return id != null && id.equals(permission.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    @ManyToMany(mappedBy = "permissions")
    public Set<RolesEntity> getRoles() { return roles; }
    public void setRoles(Set<RolesEntity> roles) { this.roles = roles; }
    private Set<RolesEntity> roles = new HashSet<>();

   
    <#if AuthenticationType == "database">
    @ManyToMany(mappedBy = "permissions")
    public Set<UsersEntity> getUsers() { return users; }
    public void setUsers(Set<UsersEntity> users) { this.users = users; }
    private Set<UsersEntity> users = new HashSet<>();
    </#if>
}
