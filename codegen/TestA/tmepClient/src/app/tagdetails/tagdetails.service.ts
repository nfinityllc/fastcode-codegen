
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ITagdetails } from './itagdetails';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class TagdetailsService extends GenericApiService<ITagdetails> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "tagdetails");
  }
  
  
}
