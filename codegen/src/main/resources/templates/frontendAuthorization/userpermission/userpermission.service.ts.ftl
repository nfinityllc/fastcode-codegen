
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IUserpermission } from './iuserpermission';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UserpermissionService extends GenericApiService<IUserpermission> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "userpermission");
  }
  
  
}
