import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TriggerNewComponent } from './trigger-new.component';

describe('TriggerNewComponent', () => {
  let component: TriggerNewComponent;
  let fixture: ComponentFixture<TriggerNewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TriggerNewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TriggerNewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
