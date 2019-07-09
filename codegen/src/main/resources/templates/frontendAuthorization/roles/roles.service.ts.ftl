
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IRoles } from './iroles';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class RolesService extends GenericApiService<IRoles> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "roles");
  }
  
  
}
