
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IUser } from './iuser';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UserService extends GenericApiService<IUser> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "user");
  }
  
  
}
