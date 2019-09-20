package [=PackageName].domain.model;

import [=PackageName].domain.model.RoleEntity;
<#if Audit!false>
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import [=PackageName].Audit.AuditedEntity;
</#if>

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Permission", schema = "[=SchemaName]")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>

public class PermissionEntity<#if Audit!false> extends AuditedEntity<String></#if> implements Serializable {
    private Long id;
    private String name;
    private String displayName;

    public PermissionEntity() {
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
        if (!(o instanceof PermissionEntity)) return false;
        PermissionEntity permission = (PermissionEntity) o;
        return id != null && id.equals(permission.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    @OneToMany(mappedBy = "permission", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<RolepermissionEntity> getRolepermissionSet() { 
      return rolepermissionSet; 
    } 
 
    public void setRolepermissionSet(Set<RolepermissionEntity> rolepermission) { 
      this.rolepermissionSet = rolepermission; 
    } 
 
    private Set<RolepermissionEntity> rolepermissionSet = new HashSet<RolepermissionEntity>(); 
  
   
    <#if AuthenticationType == "database" || AuthenticationType=="oidc">
    @OneToMany(mappedBy = "permission", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<[=AuthenticationTable]permissionEntity> get[=AuthenticationTable]permissionSet() { 
      return [=AuthenticationTable?uncap_first]permissionSet; 
    } 
 
    public void set[=AuthenticationTable]permissionSet(Set<[=AuthenticationTable]permissionEntity> [=AuthenticationTable?uncap_first]permission) { 
      this.[=AuthenticationTable?uncap_first]permissionSet = [=AuthenticationTable?uncap_first]permission; 
    } 
 
    private Set<[=AuthenticationTable]permissionEntity> [=AuthenticationTable?uncap_first]permissionSet = new HashSet<[=AuthenticationTable]permissionEntity>(); 

    </#if>
}
