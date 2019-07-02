import { ISearchField, operatorType } from '../components/list-filters/ISearchCriteria';

export class ServiceUtils {
    public static parseSearchFields(searchFields: ISearchField[]): string {
        let searchString: string = "";
        console.log(searchFields);
        if (searchFields !== null && searchFields !== undefined) {
            searchFields.forEach(field => {
                searchString += `${field.fieldName}[${field.operator}]=`;

                let searchValue: string = field.searchValue;
                let startingValue: string = field.startingValue;
                let endingValue: string = field.endingValue;

                if (field.operator === operatorType.Range) {
                    if (startingValue !== null) {
                        searchString += startingValue;
                    }
                    searchString += ',';
                    if (endingValue !== null) {
                        searchString += endingValue;
                    }
                }
                else {
                    if (searchValue !== null) {
                        searchString += searchValue;
                    }
                }
                searchString += ";";
            });
            if (searchString.length > 0) {
                searchString = searchString.slice(0, -1);
            }
        }

        return searchString;
    }

    public static buildQueryData(searchFields: ISearchField[], offset?: any, limit?: any, sort?: string): any {
        let params = {
            'search': this.parseSearchFields(searchFields),
            'offset': offset ? offset : 0,
            'limit': limit ? limit : 10,
            'sort': sort ? sort : ''
        }

        return params;
    }
}

