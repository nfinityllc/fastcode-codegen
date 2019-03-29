import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {${IEntity},${ClassName}Service, ${ClassName}NewComponent} from './index';
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('${ClassName}NewComponent', () => {
  let component: ${ClassName}NewComponent;
  let fixture: ComponentFixture<${ClassName}NewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/${InstanceName}s';
  let formBuilder:any = new FormBuilder(); 
    
  let data:${IEntity} = {
      <#assign counter = 1>
     <#list Fields as key, value>           
            <#if key == "id">    
              ${key}:${counter},
            <#elseif value.fieldType == "Date">           
                ${key}: new Date().toLocaleDateString("en-US") ,
            <#elseif value.fieldType?lower_case == "boolean">              
                ${key}: true,
            <#else>              
                   ${key}: '${key}${counter}',
            </#if> 
      </#list>    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        ${ClassName}NewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      ${ClassName}Service,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(${ClassName}NewComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  it('should run #onSubmit()', async () => {
   
    component.itemForm=formBuilder.group(data);    
    fixture.detectChanges();
    const result = component.onSubmit(); 
    const req = httpTestingController.expectOne(req => req.method === 'POST' && req.url === url ).flush(data); 
    httpTestingController.verify();
 
  });
});
