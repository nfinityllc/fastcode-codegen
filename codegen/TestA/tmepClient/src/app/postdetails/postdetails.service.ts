
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IPostdetails } from './ipostdetails';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PostdetailsService extends GenericApiService<IPostdetails> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "postdetails");
  }
  
  
}
