
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IPermission } from './ipermission';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PermissionService extends GenericApiService<IPermission> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "permission");
  }
  
  
}
