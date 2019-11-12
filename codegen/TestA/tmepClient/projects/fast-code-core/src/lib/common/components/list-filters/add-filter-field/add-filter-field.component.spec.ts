import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddFilterFieldComponent } from './add-filter-field.component';

describe('AddFilterFieldComponent', () => {
  let component: AddFilterFieldComponent;
  let fixture: ComponentFixture<AddFilterFieldComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddFilterFieldComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddFilterFieldComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
