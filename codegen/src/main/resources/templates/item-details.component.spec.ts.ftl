import { async, ComponentFixture, TestBed } from '@angular/core/testing';


import { TestingModule,EntryComponents } from '../../testing/utils';
import {[=IEntity],[=ClassName]Service, [=ClassName]DetailsComponent} from './index';
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('[=ClassName]DetailsComponent', () => {
  let component: [=ClassName]DetailsComponent;
  let fixture: ComponentFixture<[=ClassName]DetailsComponent>;
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + "/[=InstanceName]/";
    
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
			<#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "int">              
		[=key]: [=counter],
			</#if> 
    </#list>    };
  beforeEach(async(() => {
   

    TestBed.configureTestingModule({
      declarations: [
        [=ClassName]DetailsComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      [=ClassName]Service,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent([=ClassName]DetailsComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  it('should run #ngOnInit()', async () => {
       
    httpTestingController = TestBed.get(HttpTestingController);
    fixture.detectChanges();
   
    const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url + data.id).flush(data);   
   
    expect(component.item).toBeTruthy();
    httpTestingController.verify(); 
  });
  it('should run #onSubmit()', async () => {
   
    //component.itemForm=formBuilder.group(data);    && req.url === url + data.id

    const req = httpTestingController.expectOne(req => req.method === 'GET'  && req.url === url + data.id).flush(data);
    fixture.detectChanges();
    ///if(component.per)
    console.log("Hello");
    const result = component.onSubmit(); 
    const req2 = httpTestingController.expectOne(req => req.method === 'PUT'  && req.url === url + data.id).flush(data); 
    httpTestingController.verify();
 
  });
});
