package [=PackageName].domain.Flowable.Memberships;

import [=PackageName].domain.Flowable.Groups.ActIdGroupEntity;
import [=PackageName].domain.Flowable.Users.ActIdUserEntity;

import java.io.Serializable;

import javax.persistence.*;
import java.lang.reflect.Member;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;

@Entity
@Table(name = "act_id_membership", schema = "dbo")
@IdClass(MembershipId.class)
public class ActIdMembershipEntity {

private String groupId;
private String userId;

@Id
@Column(name = "group_id_", nullable = false, length =64)
public String getGroupId() {
return groupId;
}

public void setGroupId(String groupId){
this.groupId = groupId;
}

@Id
@Column(name = "user_id_", nullable = false, length =64)
public String getUserId() {
return userId;
}

public void setUserId(String userId){
this.userId = userId;
}
}

