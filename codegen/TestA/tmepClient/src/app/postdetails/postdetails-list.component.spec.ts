
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { Injectable, CUSTOM_ELEMENTS_SCHEMA ,NO_ERRORS_SCHEMA, Input} from '@angular/core';
import {  HttpTestingController } from '@angular/common/http/testing';
import { Observable, throwError,of } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import {Component, Directive, ChangeDetectorRef} from '@angular/core';
import {IPostdetails,PostdetailsListComponent,PostdetailsService } from './index';
import { TestingModule,EntryComponents } from '../../testing/utils';
import { environment } from '../../environments/environment';


@Injectable()
class MockRouter { navigate = ()=> {}; }
      
@Injectable()
class MockGlobals { }
      
@Injectable()
class MockPostdetailsService { }
      
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
describe('PostdetailsListComponent', () => {
  let fixture:ComponentFixture<PostdetailsListComponent>;
  let component:PostdetailsListComponent;
  let httpTestingController: HttpTestingController;
  let postdetailsService: PostdetailsService;
  let url:string = environment.apiUrl + '/postdetails';
  let mockGlobal = {
    isSmallDevice$: of({value:true})
  }; 
  let data:IPostdetails [] = [
		{   
			country: 'country1',
			pdid: 'pdid1',
			pid: 'pid1',
		},
		{   
			country: 'country2',
			pdid: 'pdid2',
			pid: 'pid2',
		},
  ]; 

  beforeEach(async(() => {
    
    TestBed.configureTestingModule({
      declarations: [
        PostdetailsListComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      PostdetailsService,      
        ChangeDetectorRef,
      ]      
   
    }).compileComponents();
  
  }));
  beforeEach(() => {
    fixture = TestBed.createComponent(PostdetailsListComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    postdetailsService = TestBed.get(PostdetailsService);
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
