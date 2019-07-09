import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {IPermissions,PermissionsService, PermissionsNewComponent} from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('PermissionsNewComponent', () => {
  let component: PermissionsNewComponent;
  let fixture: ComponentFixture<PermissionsNewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/permissions';
  let formBuilder:any = new FormBuilder(); 
    
  let data:IPermissions = {
		displayName: 'displayName1',
				id:1,
				name: 'name1',
						    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        PermissionsNewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				PermissionsService,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PermissionsNewComponent);
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
