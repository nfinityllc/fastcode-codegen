
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { [=IEntity] } from './[=IEntityFile]';
import {GenericApiService} from '../core/generic-api.service';

@Injectable({
  providedIn: 'root'
})
export class [=ClassName]Service extends GenericApiService<[=IEntity]> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient,"[=ApiPath]");
    
   
  }
  
  
}
