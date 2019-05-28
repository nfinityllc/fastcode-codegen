import { Injectable } from '@angular/core';
import { HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import { environment } from '../../environments/environment';
import { ISearchField, operatorType, ISearchCriteria } from 'src/app/common/components/list-filters/ISearchCriteria';

//import { IUser } from '../users/iuser';

const API_URL = environment.apiUrl;

@Injectable()
export class GenericApiService<T> {
  private url = environment.apiUrl;
  private suffix = '';
  constructor(private http: HttpClient, suffix: string) {
    this.url = environment.apiUrl + '/' + suffix;
    this.suffix = suffix;
  }
  public buildQueryData(searchFields: ISearchField[], offset?: any, limit?: any, sort?: string): any {
    let params = {
      'search': this.parseSearchFields(searchFields),
      'offset': offset ? offset : 0,
      'limit': limit ? limit : 10,
      'sort': sort ? sort : ''
    }

    return params;
  }

  public parseSearchFields(searchFields: ISearchField[]): string {
    let searchString: string = "";
    console.log(searchFields);
    searchFields.forEach(field => {
      searchString += `${field.fieldName}[${field.operator}]=`;

      let searchValue: string = field.searchValue;
      let startingValue: string = field.startingValue;
      let endingValue: string = field.endingValue;
      
      if(field.operator === operatorType.Range){
        if(startingValue !== null){
          searchString += startingValue;
        }
        searchString += ',';
        if(endingValue !== null){
          searchString += endingValue;
        }
      }
      else{
        if(searchValue !== null){
          searchString += searchValue; 
        }
      }
      searchString += ";";
    });
    if(searchString.length > 0){
      searchString = searchString.slice(0,-1);
    }
    return searchString;
  }

  public getAll(searchFields?: ISearchField[], offset?: number, limit?: number, sort?: string): Observable<T[]> {

    let params = this.buildQueryData(searchFields, offset, limit, sort);

    return this.http.get<T[]>(this.url, { params }).pipe(map((response: any) => {
      return response;
    }), catchError(this.handleError));

  }
  getAssociations(parentSuffix: string, parentId: any, searchFields?: ISearchField[], offset?: number, limit?: number, sort?: string): Observable<T[]> {

    let url = API_URL + '/' + parentSuffix + '/' + parentId + '/' + this.suffix;
    let params = this.buildQueryData(searchFields, offset, limit, sort);
    return this.http.get<T[]>(url, { params }).pipe(map((response: any) => {
      return response;
    }), catchError(this.handleError));
  }
  /*public getChildren(parentUrl: string,search?:string, offset?:number, limit?:number, sort?:string): Observable<T[]> {
   
    let params = this.buildQueryData(search,offset,limit,sort);
    
    return this.http.get<T[]>(API_URL + '/' + parentUrl + '/'+ this.suffix,{params}).pipe(map((response:any)=>{
      return response;
    }), catchError(this.handleError));
     
  }*/
  public getById(id: any): Observable<T> {
    return this.http
      .get<T>(this.url + '/' + id).pipe(catchError(this.handleError));
  }
  public create(item: T): Observable<T> {
    return this.http
      .post<T>(this.url, item).pipe(catchError(this.handleError));

  }
  public update(item: T, id: any): Observable<T> {
    return this.http
      .put<T>(this.url + '/' + id, item).pipe(catchError(this.handleError));
  }
  public delete(id: any): Observable<null> {
    return this.http
      .delete(this.url + '/' + id).pipe(map(res => null), catchError(this.handleError));
  }
  public deleteAssociation(parentSuffix: string, parentId: any, id: any): Observable<null> {
    let url = API_URL + '/' + parentSuffix + '/' + parentId + '/' + this.suffix
    return this.http
      .delete(url + '/' + id).pipe(map(res => null), catchError(this.handleError));
  }
  public addAssociation(parentSuffix: string, parentId: any, item: any): Observable<null> {
    let url = API_URL + '/' + parentSuffix + '/' + parentId + '/' + this.suffix
    return this.http
      .post(url, item).pipe(map(res => null), catchError(this.handleError));
  }

  protected handleError(err: HttpErrorResponse) {

    let errorMessage = '';
    if (err.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      errorMessage = 'An error occurred: ' + err.error.message;
    } else {

      errorMessage = 'Server returned code: ' + err.status + ', error message is: ' + err.message;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
}
