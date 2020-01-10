import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {   HomeComponent } from './home.component';
import { TestingModule,EntryComponents } from '../../testing/utils';
import { AuthenticationService} from '../core/authentication.service';
//import {ILogin} from './ilogin'
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';
import {Location} from '@angular/common';
import { Router } from '@angular/router';

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;
  let location:Location;
  let mockRouter = {
    navigate: jasmine.createSpy('navigate')
  }
  let data:any = {userName:'userName1',password: 'password1'};
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + ''; //'http://localhost:5555/login'; //
  let formBuilder:any = new FormBuilder(); 
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        HomeComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
        { provide: Router, useValue: mockRouter},
      AuthenticationService,       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HomeComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    location = TestBed.get(Location);
    component = fixture.componentInstance;
  
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  it('should run #ngOnInit()', async () => {
       
   // httpTestingController = TestBed.get(HttpTestingController);
    //fixture.detectChanges();
   
    //const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === url ).flush(data);   
   
    //expect(component.iLogin).toBeTruthy();
   // httpTestingController.verify(); 
  });
  it('should run #onSubmit()', async () => {
   
  
   // component.itemForm=formBuilder.group(data);  
  
    
    const result = component.onSubmit(); 
    fixture.detectChanges();
    console.log("on submit:" + location.path());
    //fixture.detectChanges();
    expect (mockRouter.navigate).toHaveBeenCalled();
    
 
  });
  
});
