
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IUser } from './iuser';
import {GenericApiService} from 'projects/fast-code-core/src/public_api';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UserService extends GenericApiService<IUser> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "user");
  }
  
  
}
