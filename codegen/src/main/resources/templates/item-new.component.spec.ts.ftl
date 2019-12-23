import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { By } from "@angular/platform-browser";
import { TestingModule,EntryComponents } from '../../testing/utils';
import { [=IEntity],[=ClassName]Service, [=ClassName]NewComponent } from './index';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';


describe('[=ClassName]NewComponent', () => {
  let component: [=ClassName]NewComponent;
  let fixture: ComponentFixture<[=ClassName]NewComponent>;
  
  let el: HTMLElement;
  let data:[=IEntity] = {
		<#assign counter = 1>
		<#list Fields as key, value>           
			<#if value.fieldName == "id">    
		[=key]:[=counter],
			<#elseif value.fieldType == "Date">           
		[=key]: new Date(),
			<#elseif value.fieldType?lower_case == "boolean">
		[=key]: true,
			<#elseif value.fieldType?lower_case == "string">              
		[=key]: '[=key][=counter]',
			<#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "double" ||  value.fieldType?lower_case == "short">              
		[=key]: [=counter],
			</#if> 
		</#list>    };
  beforeEach(async(() => {
  
    TestBed.configureTestingModule({
      declarations: [
        [=ClassName]NewComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
				[=ClassName]Service,
				{ provide: MAT_DIALOG_DATA, useValue: {} },
				{provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent([=ClassName]NewComponent);
    component = fixture.componentInstance;
    spyOn(component, 'manageScreenResizing').and.returnValue();
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  
  it('should run #ngOnInit()', async (() => {
    
    component.ngOnInit();
    
    expect(component.title.length).toBeGreaterThan(0);
    expect(component.associations).toBeDefined();
    expect(component.parentAssociations).toBeDefined();
    expect(component.itemForm).toBeDefined();
    
  }));


  it('should run #onSubmit()', async () => {
   
    component.itemForm.patchValue(data);
    component.itemForm.enable();    
    fixture.detectChanges();
    spyOn(component, "onSubmit").and.returnValue();
    el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
    el.click();
    expect(component.onSubmit).toHaveBeenCalled();
 
  });

  it('should call the cancel', async () => {

    spyOn(component, "onCancel").and.callThrough();
    el = fixture.debugElement.query(By.css('button[name=cancel]')).nativeElement;
    el.click();
    expect(component.onCancel).toHaveBeenCalled();

  });
});
