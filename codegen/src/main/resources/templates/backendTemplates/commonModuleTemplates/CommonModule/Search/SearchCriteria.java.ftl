package [=PackageName].Search;

import java.util.ArrayList;
import java.util.List;

public class SearchCriteria {
	
	int type;
	String value;
	String operator;
	List<SearchFields> fields = new ArrayList<>();
	String joinColumn;
	Long joinColumnValue;
	
	public Long getJoinColumnValue() {
		return joinColumnValue;
	}
	public void setJoinColumnValue(Long joinColumnValue) {
		this.joinColumnValue = joinColumnValue;
	}
	public String getJoinColumn() {
		return joinColumn;
	}
	public void setJoinColumn(String joinColumn) {
		this.joinColumn = joinColumn;
	}
	
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public List<SearchFields> getFields() {
		return fields;
	}
	public void setFields(List<SearchFields> fields) {
		this.fields = fields;
	}
}
