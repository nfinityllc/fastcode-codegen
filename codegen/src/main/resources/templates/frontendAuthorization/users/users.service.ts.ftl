
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IUsers } from './iusers';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UsersService extends GenericApiService<IUsers> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "users");
  }
  
  
}
