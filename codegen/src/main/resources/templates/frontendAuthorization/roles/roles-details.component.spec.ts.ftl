import { async, ComponentFixture, TestBed } from '@angular/core/testing';


import { TestingModule,EntryComponents } from '../../testing/utils';
import {IRoles,RolesService, RolesDetailsComponent} from './index';
import { MatDialogRef } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('RolesDetailsComponent', () => {
  let component: RolesDetailsComponent;
  let fixture: ComponentFixture<RolesDetailsComponent>;
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + "/roles/";
    
  let data:IRoles = {
		displayName: 'displayName1',
    	  id:1,
    		name: 'name1',
                };
  beforeEach(async(() => {
   

    TestBed.configureTestingModule({
      declarations: [
        RolesDetailsComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      RolesService,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RolesDetailsComponent);
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
