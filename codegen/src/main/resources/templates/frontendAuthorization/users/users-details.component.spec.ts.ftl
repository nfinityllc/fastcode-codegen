import { async, ComponentFixture, TestBed } from '@angular/core/testing';


import { TestingModule,EntryComponents } from '../../testing/utils';
import {IUsers,UsersService, UsersDetailsComponent} from './index';
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('UsersDetailsComponent', () => {
  let component: UsersDetailsComponent;
  let fixture: ComponentFixture<UsersDetailsComponent>;
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + "/users/";
    
  let data:IUsers = {
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
        };
  beforeEach(async(() => {
   

    TestBed.configureTestingModule({
      declarations: [
        UsersDetailsComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      UsersService,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UsersDetailsComponent);
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
