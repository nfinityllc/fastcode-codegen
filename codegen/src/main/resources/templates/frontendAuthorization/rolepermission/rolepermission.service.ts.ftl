
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IRolepermission } from './irolepermission';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class RolepermissionService extends GenericApiService<IRolepermission> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "rolepermission");
  }
  
  
}
