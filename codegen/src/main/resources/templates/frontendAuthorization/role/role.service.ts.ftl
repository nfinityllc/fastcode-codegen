
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IRole } from './irole';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class RoleService extends GenericApiService<IRole> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "role");
  }
  
  
}
