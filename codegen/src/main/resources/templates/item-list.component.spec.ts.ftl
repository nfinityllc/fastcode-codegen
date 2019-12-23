import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { of } from 'rxjs';
import { Directive, ChangeDetectorRef } from '@angular/core';
import { [=IEntity],[=ClassName]ListComponent,[=ClassName]Service } from './index';
import { TestingModule,EntryComponents } from '../../testing/utils';

describe('[=ClassName]ListComponent', () => {
  let fixture:ComponentFixture<[=ClassName]ListComponent>;
  let component:[=ClassName]ListComponent;
  let el: HTMLElement;
  let data:[=IEntity][]; 

  beforeEach(async(() => {
    
    TestBed.configureTestingModule({
      declarations: [
        [=ClassName]ListComponent       
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
      [=ClassName]Service,      
        ChangeDetectorRef,
      ]      
   
    }).compileComponents();
  
  }));
  beforeEach(() => {
    fixture = TestBed.createComponent([=ClassName]ListComponent);
    component = fixture.componentInstance;
    data = [
      <#list [1,2] as index>     
      {   
        <#list Fields as key, value>             
          <#if value.fieldName == "id">    
        [=key]:[=index],
          <#elseif value.fieldType == "Date">           
        [=key]: new Date(),
          <#elseif value.fieldType?lower_case == "boolean">              
        [=key]: true,
          <#elseif value.fieldType?lower_case == "string">              
        [=key]: '[=key][=index]',
          <#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "double" ||  value.fieldType?lower_case == "short">              
        [=key]: [=index],
          </#if> 
        </#list>    
      },
      </#list> 
    ];
  });

    it('should create a component', async () => {
    expect(component).toBeTruthy();
  });

  it('should run #ngOnInit()', async () => {

    spyOn(component.dataService,"getAll").and.returnValue(of(data));
    component.ngOnInit();
    
    expect(component.items.length).toEqual(data.length);
    expect(component.associations).toBeDefined();
    expect(component.entityName.length).toBeGreaterThan(0);
    expect(component.primaryKeys.length).toBeGreaterThan(0);
    expect(component.columns.length).toBeGreaterThan(0);
    expect(component.selectedColumns.length).toBeGreaterThan(0);
    expect(component.displayedColumns.length).toBeGreaterThan(0);
    
  });

  it('should run #addNew()', async () => {
    spyOn(component, "addNew").and.returnValue();
    el = fixture.debugElement.query(By.css('button[name=add]')).nativeElement;
    el.click();
    expect(component.addNew).toHaveBeenCalled();
  });

  it('should run #delete()', async () => {

    spyOn(component, "delete").and.returnValue();
    component.delete(data[0]);
    expect(component.delete).toHaveBeenCalledWith(data[0]);

  });
        
});
