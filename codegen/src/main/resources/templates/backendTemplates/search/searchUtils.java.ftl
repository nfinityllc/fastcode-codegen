package [=PackageName].Search;

import java.util.ArrayList;
import java.util.List;

public class SearchUtils {
	public static SearchCriteria generateSearchCriteriaObject(String searchString){
		SearchCriteria searchCriteria = new SearchCriteria();
		searchCriteria.setType(3);

		List<SearchFields> searchFields = new ArrayList<SearchFields>();


		if(searchString.length() > 0) {
			String[] fields = searchString.split(";");

			for(String field: fields) {
				SearchFields searchField = new SearchFields();

				String fieldName = field.substring(0, field.indexOf('['));
				String operator = field.substring(field.indexOf('[') + 1, field.indexOf(']'));
				String searchValue = field.substring(field.indexOf('=') + 1);

				searchField.setFieldName(fieldName);
				searchField.setOperator(operator);

				if(!operator.equals("range")){
					searchField.setSearchValue(searchValue);
				}
				else {
					String[] rangeValues = searchValue.split(",");
					if(!rangeValues[0].isEmpty()) {
						String startingValue = rangeValues[0];
						searchField.setStartingValue(startingValue);
					}

					if(rangeValues.length == 2) {
						String endingValue = rangeValues[1];
						searchField.setEndingValue(endingValue);
					}
				}

				searchFields.add(searchField);

			}
		}

		searchCriteria.setFields(searchFields);
		return searchCriteria;
	}
}
