package [=PackageName];

import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.util.Date;

@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class AuditedEntity<T> {

    @CreatedBy
    protected T creatorUserId;

    @CreatedDate
    @Temporal(TemporalType.TIMESTAMP)
    protected Date creationTime;

    @LastModifiedBy
    protected T lastModifierUserId;

    @LastModifiedDate
    @Temporal(TemporalType.TIMESTAMP)
    protected Date lastModificationTime;

    public T getLastModifierUserId() {
        return lastModifierUserId;
    }

    public void setLastModifierUserId(T lastModifierUserId) {
        this.lastModifierUserId = lastModifierUserId;
    }

    public T getCreatorUserId() {
        return creatorUserId;
    }

    public void setCreatorUserId(T creatorUserId) {
        this.creatorUserId = creatorUserId;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getLastModificationTime() {
        return lastModificationTime;
    }

    public void setLastModificationTime(Date lastModificationTime) {
        this.lastModificationTime = lastModificationTime;
    }
}
