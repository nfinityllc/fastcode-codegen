
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IPermissions } from './ipermissions';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PermissionsService extends GenericApiService<IPermissions> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "permissions");
  }
  
  
}
