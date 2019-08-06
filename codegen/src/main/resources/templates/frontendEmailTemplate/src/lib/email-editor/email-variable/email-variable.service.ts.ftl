
import { Injectable,Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {  IEmailVariable } from './iemail-variable';
//import {GenericApiService} from '../core/generic-api.service';
import { GenericApiService } from 'fastCodeCore'; //from 'projects/fast-code-core/src/lib/common/core/generic-api.service';
import { IP_CONFIG } from '../../tokens';
import { IForRootConf } from '../../interfaces';
@Injectable({
  providedIn: 'root'
})
export class EmailVariableService extends GenericApiService<IEmailVariable> { 
  constructor(private httpclient: HttpClient,@Inject(IP_CONFIG)  config: IForRootConf) { 
    super(httpclient,{apiUrl:config.apiPath} ,"emailvariable");
    
   
  }
  
  
}
