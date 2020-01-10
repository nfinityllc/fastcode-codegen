package com.nfin.testemaa.domain.model.Temp;

import java.util.*;
import javax.persistence.*;

/**
 * Auto-generated by:
 * org.apache.openjpa.jdbc.meta.ReverseMappingTool$AnnotatedCodeGenerator
 */
@Entity
@Table(schema="blog", name="tag")
public class Tag {
	@Basic
	private double check;

	@OneToMany(targetEntity=com.nfin.testemaa.domain.model.Temp.EntryTag.class, mappedBy="tag", cascade=CascadeType.MERGE)
	private Set entryTags = new HashSet();

	@Basic
	@Column(nullable=false)
	private String name;

	@Id
	@Column(name="tag_id", columnDefinition="bigserial")
	private long tagId;


	public Tag() {
	}

	public Tag(long tagId) {
		this.tagId = tagId;
	}

	public double getCheck() {
		return check;
	}

	public void setCheck(double check) {
		this.check = check;
	}

	public Set getEntryTags() {
		return entryTags;
	}

	public void setEntryTags(Set entryTags) {
		this.entryTags = entryTags;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getTagId() {
		return tagId;
	}

	public void setTagId(long tagId) {
		this.tagId = tagId;
	}
}