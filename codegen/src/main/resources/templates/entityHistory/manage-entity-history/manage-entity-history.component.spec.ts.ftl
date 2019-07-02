import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ManageEntityHistoryComponent } from './manage-entity-history.component';

describe('ManageEntityHistoryComponent', () => {
  let component: ManageEntityHistoryComponent;
  let fixture: ComponentFixture<ManageEntityHistoryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ManageEntityHistoryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ManageEntityHistoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
