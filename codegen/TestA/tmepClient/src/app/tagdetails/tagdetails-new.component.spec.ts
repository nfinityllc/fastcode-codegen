import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestingModule,EntryComponents } from '../../testing/utils';
import {ITagdetails,TagdetailsService, TagdetailsNewComponent} from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { Validators, FormBuilder } from '@angular/forms';


describe('TagdetailsNewComponent', () => {
  let component: TagdetailsNewComponent;
  let fixture: ComponentFixture<TagdetailsNewComponent>;
  
  let httpTestingController: HttpTestingController;
  let url:string = environment.apiUrl + '/tagdetails';
  let formBuilder:any = new FormBuilder(); 
    
  let data:ITagdetails = {
		country: 'country1',
						tid: 'tid1',
				title: 'title1',
		    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        TagdetailsNewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				TagdetailsService,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TagdetailsNewComponent);
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
