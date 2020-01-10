import { async, ComponentFixture, TestBed } from '@angular/core/testing';


import { TestingModule,EntryComponents } from '../../testing/utils';
import {IUser,UserService, UserDetailsComponent} from './index';
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('UserDetailsComponent', () => {
  let component: UserDetailsComponent;
  let fixture: ComponentFixture<UserDetailsComponent>;
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + "/user/";
    
  let data:IUser = {
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
        UserDetailsComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      UserService,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UserDetailsComponent);
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
