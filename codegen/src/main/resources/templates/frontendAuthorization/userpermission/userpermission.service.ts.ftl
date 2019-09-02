
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { I[=authenticationTable]permission } from './i[=moduleName]permission';
import { GenericApiService } from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class [=authenticationTable]permissionService extends GenericApiService<I[=authenticationTable]permission> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "[=authenticationTable?uncap_first]permission");
  }
  
  
}
