import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {IUsers,UsersService, UsersNewComponent} from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('UsersNewComponent', () => {
  let component: UsersNewComponent;
  let fixture: ComponentFixture<UsersNewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/users';
  let formBuilder:any = new FormBuilder(); 
    
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
        UsersNewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				UsersService,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UsersNewComponent);
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
