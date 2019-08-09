import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {[=IEntity],[=ClassName]Service, [=ClassName]NewComponent} from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('[=ClassName]NewComponent', () => {
  let component: [=ClassName]NewComponent;
  let fixture: ComponentFixture<[=ClassName]NewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/[=InstanceName]';
  let formBuilder:any = new FormBuilder(); 
    
  let data:[=IEntity] = {
		<#assign counter = 1>
		<#list Fields as key, value>           
			<#if value.fieldName == "id">    
		[=key]:[=counter],
			<#elseif value.fieldType == "Date">           
		[=key]: new Date().toLocaleDateString("en-US") ,
			<#elseif value.fieldType?lower_case == "boolean">
		[=key]: true,
			<#elseif value.fieldType?lower_case == "string">              
		[=key]: '[=key][=counter]',
			<#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "double" ||  value.fieldType?lower_case == "short">              
		[=key]: [=counter],
			</#if> 
		</#list>    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        [=ClassName]NewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				[=ClassName]Service,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent([=ClassName]NewComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    component = fixture.componentInstance;
    spyOn(component, 'manageScreenResizing').and.returnValue(false);
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
