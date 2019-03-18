
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { Injectable, CUSTOM_ELEMENTS_SCHEMA ,NO_ERRORS_SCHEMA, Input} from '@angular/core';
import {  HttpTestingController } from '@angular/common/http/testing';
import { Observable, throwError,of } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import {Component, Directive, ChangeDetectorRef} from '@angular/core';
import {${IEntity},${ClassName}ListComponent,${ClassName}Service } from './index';
import { TestingModule,EntryComponents } from '../../testing/utils';
import { environment } from '../../environments/environment';


@Injectable()
class MockRouter { navigate = ()=> {}; }
      
@Injectable()
class MockGlobals { }
      
@Injectable()
class Mock${ClassName}Service { }
      
@Injectable()
class MockPickerDialogService { }
@Directive({
selector:'[routerlink]',
host: {'(click)':'onClick()'}
})
export  class RouterLinkDirectiveStub {
  @Input('routerLink') linkParams: any;
  navigatedTo: any = null;
  onClick () {
    this.navigatedTo = this.linkParams;
  }
}
describe('${ClassName}ListComponent', () => {
  let fixture:ComponentFixture<${ClassName}ListComponent>;
  let component:${ClassName}ListComponent;
  let httpTestingController: HttpTestingController;
  let ${InstanceName}Service: ${ClassName}Service;
  let url:string = environment.apiUrl + '/${InstanceName}s';
  let mockGlobal = {
    isSmallDevice$: of({value:true})
  }; 
  let data:${IEntity} [] = [
      <#list [1,2] as index>     
      {   
            <#list Fields as key, value>             
                    <#if key == "id">    
                      ${key}:${index},
                    <#elseif value.fieldType == "Timestamp">           
                        ${key}: new Date().toLocaleDateString("en-US") ,
                    <#elseif value.fieldType?lower_case == "boolean">              
                        ${key}: true,
                    <#else>              
                          ${key}: '${key}${index}',
                    </#if> 
              </#list>    
        },
       </#list> 
  ]; 

  beforeEach(async(() => {
    
    TestBed.configureTestingModule({
      declarations: [
        ${ClassName}ListComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      ${ClassName}Service,      
        ChangeDetectorRef,
      ]      
   
    }).compileComponents();
  
  }));
  beforeEach(() => {
    fixture = TestBed.createComponent(${ClassName}ListComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    ${InstanceName}Service = TestBed.get(${ClassName}Service);
    component = fixture.componentInstance;
  });

  it('should create a component', async () => {
    expect(component).toBeTruthy();
  });  
    
  it('should run #ngOnInit()', async () => {
       
    httpTestingController = TestBed.get(HttpTestingController);
    fixture.detectChanges();
   
    const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url ).flush(data);   
   
    expect(component.items.length).toEqual(2);
    httpTestingController.verify(); 
  });
    
    
  it('should list items', async () => {
    
    fixture.detectChanges();
    httpTestingController = TestBed.get(HttpTestingController);   
    const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url).flush(data);
  
   expect(component.items.length).toEqual(data.length);
   fixture.detectChanges(); 
 
    httpTestingController.verify()
  });   
  it('should run #onAdd()', async () => {
    // const result = component.onAdd();
   
    httpTestingController = TestBed.get(HttpTestingController);
    fixture.detectChanges();
   
    const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url ).flush(data);
   // req.flush(data);
   fixture.detectChanges();
    const result = component.onAdd();
   httpTestingController.verify();
 
  });
        
  it('should run #delete()', async () => {
    
    fixture.detectChanges();
    httpTestingController = TestBed.get(HttpTestingController);
   
   const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url ).flush(data);
    
   const result = component.delete(data[0]);   
   const req2 = httpTestingController.expectOne(req => req.method === 'DELETE' && req.url === url + '/'+ data[0].id).flush(null);
   expect(component.items.length).toEqual(1);
   //fixture.detectChanges();
   httpTestingController.verify();
 
  });
        
});
