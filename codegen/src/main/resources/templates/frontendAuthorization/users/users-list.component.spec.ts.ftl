
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { Injectable, CUSTOM_ELEMENTS_SCHEMA ,NO_ERRORS_SCHEMA, Input} from '@angular/core';
import {  HttpTestingController } from '@angular/common/http/testing';
import { Observable, throwError,of } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import {Component, Directive, ChangeDetectorRef} from '@angular/core';
import {IUsers,UsersListComponent,UsersService } from './index';
import { TestingModule,EntryComponents } from '../../testing/utils';
import { environment } from '../../environments/environment';


@Injectable()
class MockRouter { navigate = ()=> {}; }
      
@Injectable()
class MockGlobals { }
      
@Injectable()
class MockUsersService { }
      
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
describe('UsersListComponent', () => {
  let fixture:ComponentFixture<UsersListComponent>;
  let component:UsersListComponent;
  let httpTestingController: HttpTestingController;
  let usersService: UsersService;
  let url:string = environment.apiUrl + '/users';
  let mockGlobal = {
    isSmallDevice$: of({value:true})
  }; 
  let data:IUsers [] = [
		{   
			accessFailedCount: 1,
			authenticationSource: 'authenticationSource1',
			emailAddress: 'emailAddress1',
			emailConfirmationCode: 'emailConfirmationCode1',
			firstName: 'firstName1',
			id:1,
			isActive: true,
			isEmailConfirmed: true,
			isLockoutEnabled: true,
			isPhoneNumberConfirmed: 'isPhoneNumberConfirmed1',
			lastLoginTime: new Date().toLocaleDateString("en-US") ,
			lastName: 'lastName1',
			lockoutEndDateUtc: new Date().toLocaleDateString("en-US") ,
			password: 'password1',
			passwordResetCode: 'passwordResetCode1',
			phoneNumber: 'phoneNumber1',
			profilePictureId: 1,
			twoFactorEnabled: true,
			userName: 'userName1',
		},
		{   
			accessFailedCount: 2,
			authenticationSource: 'authenticationSource2',
			emailAddress: 'emailAddress2',
			emailConfirmationCode: 'emailConfirmationCode2',
			firstName: 'firstName2',
			id:2,
			isActive: true,
			isEmailConfirmed: true,
			isLockoutEnabled: true,
			isPhoneNumberConfirmed: 'isPhoneNumberConfirmed2',
			lastLoginTime: new Date().toLocaleDateString("en-US") ,
			lastName: 'lastName2',
			lockoutEndDateUtc: new Date().toLocaleDateString("en-US") ,
			password: 'password2',
			passwordResetCode: 'passwordResetCode2',
			phoneNumber: 'phoneNumber2',
			profilePictureId: 2,
			twoFactorEnabled: true,
			userName: 'userName2',
		},
  ]; 

  beforeEach(async(() => {
    
    TestBed.configureTestingModule({
      declarations: [
        UsersListComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      UsersService,      
        ChangeDetectorRef,
      ]      
   
    }).compileComponents();
  
  }));
  beforeEach(() => {
    fixture = TestBed.createComponent(UsersListComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    usersService = TestBed.get(UsersService);
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
