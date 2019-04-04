import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { Component } from '@angular/core';
import { ChangeDetectorRef } from '@angular/core';
import { ListFiltersComponent } from './list-filters.component';

import { TestingModule } from '../../testing/utils';
import { environment } from '../../environments/environment';
import { PickerComponent } from '../picker/picker.component';
import { UserNewComponent } from 'src/app/users';
import { JobNewComponent } from '../jobs/job-new/job-new.component';
import { AddFilterFieldComponent } from './add-filter-field/add-filter-field.component';
import { TriggerNewComponent } from '../triggers/trigger-new/trigger-new.component';
import { IListColumn, listColumnType } from '../common/ilistColumn';

describe('ListFiltersComponent', () => {
  @Component({
    selector: `host-component`,
    template: `<app-list-filters [columnsList]="columns" (onSearch)="applyFilter($event)"></app-list-filters>`
  })
  class TestHostComponent {
    columns: IListColumn[] = [
      {
        column: 'column1',
        label: 'Column 1',
        sort: true,
        filter: true,
        type: listColumnType.String
      },
      {
        column: 'coolumn2',
        label: 'Column 2',
        sort: true,
        filter: true,
        type: listColumnType.String
      }
    ]
  
    applyFilter(){}
  }

  let testHostComponent: TestHostComponent;
  let testHostFixture: ComponentFixture<TestHostComponent>;
  let component: ListFiltersComponent;
  let fixture: ComponentFixture<ListFiltersComponent>;

  
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [TestHostComponent, TriggerNewComponent, JobNewComponent, UserNewComponent, ListFiltersComponent, AddFilterFieldComponent, PickerComponent],
      imports: [TestingModule],
      providers: [
        ChangeDetectorRef,
      ],
    })
      .compileComponents();
  }));

  beforeEach(() => {
    testHostFixture = TestBed.createComponent(TestHostComponent);
    testHostComponent = testHostFixture.componentInstance;
    component = testHostFixture.debugElement.children[0].componentInstance;
    testHostFixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
  
  it('should remove filter field from search bar', () => {
    let filterField = testHostComponent.columns[0];
    let filterFieldString = filterField.label + ":value1"
    component.filterFields.splice(0,1);
    component.selectedFilterFields = [filterFieldString];

    component.remove(filterFieldString);
    expect(component.filterFields.length).toBe(testHostComponent.columns.length);
  });

  it('Should create filter string', () => {
    let filterObj = {
      key1: "value1",
      key2: "value2"
    }
    expect(component.getFilterString(filterObj)).toBe("key1:value1,key2:value2")
  });
});
