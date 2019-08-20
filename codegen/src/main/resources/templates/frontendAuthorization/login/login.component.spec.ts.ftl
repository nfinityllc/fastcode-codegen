import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {  LoginComponent } from './login.component';
import { TestingModule,EntryComponents } from '../../testing/utils';
import { AuthenticationService} from '../core/authentication.service';
import {ILogin} from './ilogin'
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let data:ILogin = {userName:'userName1',password: 'password1'};
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/login'; //'http://localhost:5555/login'; //
  let formBuilder:any = new FormBuilder(); 
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        LoginComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      AuthenticationService,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LoginComponent);
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
   
    //const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url ).flush(data);   
   
    expect(component.iLogin).toBeTruthy();
    httpTestingController.verify(); 
  });
  it('should run #onSubmit()', async () => {
   
    //component.permissionForm=formBuilder.group(data);    && req.url === baseUrl + '/permissions/'+ data.id

    //const req = httpTestingController.expectOne(req => req.method === 'GET'  && req.url === url + '?returnUrl=dashboard').flush(data);
    //fixture.detectChanges();
    ///if(component.per)
   // httpTestingController = TestBed.get(HttpTestingController);
    //fixture.detectChanges();
    component.itemForm=formBuilder.group(data);  
    console.log("on submit:" + url);
    
    const result = component.onSubmit(); 
    fixture.detectChanges();
    /*const req2 = httpTestingController.expectOne(req => {
      console.log("url: ", req.url); 
      return true  }); *///.flush(data); 
      const req2 =  httpTestingController.expectOne(req => req.method === 'POST' && req.url === url ).flush(data);
    httpTestingController.verify();
 
  });
  
});
