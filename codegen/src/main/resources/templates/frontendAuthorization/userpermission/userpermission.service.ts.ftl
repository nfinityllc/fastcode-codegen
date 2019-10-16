
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { I[=AuthenticationTable]permission } from './i[=moduleName]permission';
import { GenericApiService } from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class [=AuthenticationTable]permissionService extends GenericApiService<I[=AuthenticationTable]permission> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "[=AuthenticationTable?uncap_first]permission");
  }
  
  
}
