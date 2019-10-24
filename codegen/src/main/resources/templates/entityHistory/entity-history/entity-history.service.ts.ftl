import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import { environment } from '../../environments/environment';
import { IEntityHistory, EntityHistory } from './entityHistory';
import { GenericApiService } from 'fastCodeCore';
@Injectable({
  providedIn: 'root'
})
// export class TriggerService extends GenericApiService<ITrigger> {
// export class EntityHistoryService extends GenericApiService<IEntityHistory> {
export class EntityHistoryService {
  //environment.apiUrl;//'https://jsonplaceholder.typicode.com/users';
  url = environment.apiUrl;

  resp: any
  constructor(private httpclient: HttpClient) {
    // super(httpclient, 'entityHistory');
    //super.sufix
  }

  public getAll(): Observable<IEntityHistory[]> {
    return this.httpclient.get<IEntityHistory[]>(this.url + '/audit/changes').pipe();
  }

}