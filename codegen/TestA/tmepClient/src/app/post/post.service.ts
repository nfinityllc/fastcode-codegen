
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IPost } from './ipost';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PostService extends GenericApiService<IPost> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "post");
  }
  
  
}
