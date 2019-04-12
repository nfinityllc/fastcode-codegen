import { async, ComponentFixture, TestBed } from '@angular/core/testing';


import { TestingModule,EntryComponents } from '../../testing/utils';
import {[=IEntity],[=ClassName]Service, [=ClassName]DetailComponent} from './index';
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('[=ClassName]DetailComponent', () => {
  let component: [=ClassName]DetailComponent;
  let fixture: ComponentFixture<[=ClassName]DetailComponent>;
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + "/[=InstanceName]s/";
    
  let data:[=IEntity] = {
      <#assign counter = 1>
     <#list Fields as key, value>           
            <#if key == "id">    
              [=key]:[=counter],
            <#elseif value.fieldType == "Date">           
                [=key]: new Date().toLocaleDateString("en-US") ,
            <#elseif value.fieldType?lower_case == "boolean">              
                [=key]: true,
            <#else>              
                   [=key]: '[=key][=counter]',
            </#if> 
      </#list>    };
  beforeEach(async(() => {
   

    TestBed.configureTestingModule({
      declarations: [
        [=ClassName]DetailComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      [=ClassName]Service,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent([=ClassName]DetailComponent);
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
