
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { Injectable, CUSTOM_ELEMENTS_SCHEMA ,NO_ERRORS_SCHEMA, Input} from '@angular/core';
import {  HttpTestingController } from '@angular/common/http/testing';
import { Observable, throwError,of } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import {Component, Directive, ChangeDetectorRef} from '@angular/core';
import {IPermission,PermissionListComponent,PermissionService } from './index';
import { TestingModule,EntryComponents } from '../../testing/utils';
import { environment } from '../../environments/environment';


@Injectable()
class MockRouter { navigate = ()=> {}; }
      
@Injectable()
class MockGlobals { }
      
@Injectable()
class MockPermissionService { }
      
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
describe('PermissionListComponent', () => {
  let fixture:ComponentFixture<PermissionListComponent>;
  let component:PermissionListComponent;
  let httpTestingController: HttpTestingController;
  let permissionService: PermissionService;
  let url:string = environment.apiUrl + '/permission';
  let mockGlobal = {
    isSmallDevice$: of({value:true})
  }; 
  let data:IPermission [] = [
		{   
			displayName: 'displayName1',
			id:1,
			name: 'name1',
		},
		{   
			displayName: 'displayName2',
			id:2,
			name: 'name2',
		},
  ]; 

  beforeEach(async(() => {
    
    TestBed.configureTestingModule({
      declarations: [
        PermissionListComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      PermissionService,      
        ChangeDetectorRef,
      ]      
   
    }).compileComponents();
  
  }));
  beforeEach(() => {
    fixture = TestBed.createComponent(PermissionListComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    permissionService = TestBed.get(PermissionService);
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
	it('should run #addNew()', async () => {   
		httpTestingController = TestBed.get(HttpTestingController);
		fixture.detectChanges();
		const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url ).flush(data);
		fixture.detectChanges();
		const result = component.addNew();
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
