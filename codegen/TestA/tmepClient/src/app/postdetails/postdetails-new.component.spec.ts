import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {IPostdetails,PostdetailsService, PostdetailsNewComponent} from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('PostdetailsNewComponent', () => {
  let component: PostdetailsNewComponent;
  let fixture: ComponentFixture<PostdetailsNewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/postdetails';
  let formBuilder:any = new FormBuilder(); 
    
  let data:IPostdetails = {
		country: 'country1',
				pdid: 'pdid1',
				pid: 'pid1',
				    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        PostdetailsNewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				PostdetailsService,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PostdetailsNewComponent);
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
