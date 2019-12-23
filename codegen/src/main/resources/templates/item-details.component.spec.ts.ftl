import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { By } from "@angular/platform-browser";
import { TestingModule, EntryComponents } from '../../testing/utils';
import { ActivatedRouteStub } from '../../testing/activated-route-stub';
import { [=IEntity], [=ClassName]Service, [=ClassName]DetailsComponent } from './index';
import { MatDialogRef } from '@angular/material';
import { of } from 'rxjs';


describe('[=ClassName]DetailsComponent', () => {
  let component: [=ClassName]DetailsComponent;
  let fixture: ComponentFixture<[=ClassName]DetailsComponent>;
  let el: HTMLElement;
  let activatedRoute: ActivatedRouteStub;
    
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
			<#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "double">              
		[=key]: [=counter],
			</#if> 
    </#list>
    
    <#if Relationship?has_content>
    <#list Relationship as relationKey, relationValue>
    <#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
    <#list relationValue.joinDetails as joinDetails>
    <#if joinDetails.joinEntityName == relationValue.eName>
    <#if joinDetails.joinColumn??>
    <#if !Fields[joinDetails.joinColumn]?? && !(DescriptiveField[relationValue.eName]?? && (joinDetails.joinColumn == relationValue.eName?uncap_first + DescriptiveField[relationValue.eName].fieldName?cap_first ))>
    <#if joinDetails.joinColumnType == "Date">           
    [=joinDetails.joinColumn]: new Date(),
    <#elseif joinDetails.joinColumnType?lower_case == "boolean">              
    [=joinDetails.joinColumn]: true,
    <#elseif joinDetails.joinColumnType?lower_case == "string">              
    [=joinDetails.joinColumn]: 'dummy',
    <#elseif joinDetails.joinColumnType?lower_case == "long" ||  joinDetails.joinColumnType?lower_case == "integer" ||  joinDetails.joinColumnType?lower_case == "double">              
    [=joinDetails.joinColumn]: 1,
    </#if>
    </#if>
    </#if>
    </#if>
    </#list>
    <#if DescriptiveField[relationValue.eName]?? && DescriptiveField[relationValue.eName].description??>
    <#if DescriptiveField[relationValue.eName].fieldType == "Date">           
    [=DescriptiveField[relationValue.eName].description?uncap_first]: new Date(),
    <#elseif DescriptiveField[relationValue.eName].fieldType?lower_case == "boolean">              
    [=DescriptiveField[relationValue.eName].description?uncap_first]: true,
    <#elseif DescriptiveField[relationValue.eName].fieldType?lower_case == "string">              
    [=DescriptiveField[relationValue.eName].description?uncap_first]: 'dummy',
    <#elseif DescriptiveField[relationValue.eName].fieldType?lower_case == "long" ||  DescriptiveField[relationValue.eName].fieldType?lower_case == "integer" ||  DescriptiveField[relationValue.eName].fieldType?lower_case == "double">              
    [=DescriptiveField[relationValue.eName].description?uncap_first]: 1,
    </#if>
    </#if>
    </#if>
    </#list>
    </#if>
  };
  beforeEach(async(() => {
   

    TestBed.configureTestingModule({
      declarations: [
        [=ClassName]DetailsComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      [=ClassName]Service,  
       
       {provide: MatDialogRef, useValue: {close: (dialogResult: any) => { }} },
      ]      
   
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent([=ClassName]DetailsComponent);
    component = fixture.componentInstance;
    activatedRoute = new ActivatedRouteStub();
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  
  it('should run #ngOnInit()', async () => {
       
    activatedRoute.setParamMap({"id":"1"});
    spyOn(component.dataService, "getById").and.returnValue(of(data));
    
    component.ngOnInit();
    
    expect(component.item).toEqual(data);
    expect(component.itemForm.getRawValue()).toEqual(data);
    expect(component.title.length).toBeGreaterThan(0);
    expect(component.associations).toBeDefined();
    expect(component.childAssociations).toBeDefined();
    expect(component.parentAssociations).toBeDefined();
  });
  
  it('should run #onSubmit()', async () => {
   
    component.item = data;
    component.itemForm.patchValue(data);
    component.itemForm.enable();
    fixture.detectChanges();
    
    spyOn(component, "onSubmit").and.returnValue();
    el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
    el.click();
    
    expect(component.onSubmit).toHaveBeenCalled();
 
  });
  
  it('should call the back', async () => {

    component.item = data;
    fixture.detectChanges();
    spyOn(component, "onBack").and.returnValue();
    el = fixture.debugElement.query(By.css('button[name=back]')).nativeElement;
    el.click();
    expect(component.onBack).toHaveBeenCalled();

  });
  
});
