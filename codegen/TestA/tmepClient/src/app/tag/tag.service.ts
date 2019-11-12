
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ITag } from './itag';
import {GenericApiService} from 'fastCodeCore';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class TagService extends GenericApiService<ITag> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "tag");
  }
  
  
}
