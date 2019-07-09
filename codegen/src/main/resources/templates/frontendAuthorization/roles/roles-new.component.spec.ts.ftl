import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {IRoles,RolesService, RolesNewComponent} from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('RolesNewComponent', () => {
  let component: RolesNewComponent;
  let fixture: ComponentFixture<RolesNewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/roles';
  let formBuilder:any = new FormBuilder(); 
    
  let data:IRoles = {
		displayName: 'displayName1',
				id:1,
				name: 'name1',
						    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        RolesNewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				RolesService,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RolesNewComponent);
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
