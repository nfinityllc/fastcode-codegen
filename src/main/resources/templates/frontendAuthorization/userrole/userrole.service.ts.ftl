
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { I[=AuthenticationTable]role } from './i[=moduleName]role';
import { GenericApiService } from 'projects/fast-code-core/src/public_api';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class [=AuthenticationTable]roleService extends GenericApiService<I[=AuthenticationTable]role> { 
  
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "[=AuthenticationTable?uncap_first]role");
  }
  
}
