import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ChangeDetectorRef } from '@angular/core';
import { HttpTestingController } from '@angular/common/http/testing';

import { ExecutionHistoryComponent, ListFiltersComponent, AddFilterFieldComponent, IExecutionHistory, JobService } from './index';

import { TestingModule } from '../../testing/utils';
import { environment } from '../../environments/environment';
import { trigger } from '@angular/animations';
import { PickerComponent } from '../picker/picker.component';
import { UserNewComponent } from 'src/app/users';

describe('ExecutionHistoryComponent', () => {
  let component: ExecutionHistoryComponent;
  let fixture: ComponentFixture<ExecutionHistoryComponent>;
  let jobService: JobService;
  
  let baseUrl:string = environment.apiUrl;

  let data: IExecutionHistory[] = [
    {
      id: 1,
      jobName: "job1",
      jobGroup: "group1",
      jobStatus: "Success",
      triggerName: "trigger1",
      triggerGroup: "group1",
      firedTime: new Date(),
      finishedTime: new Date()
    },
    {
      id: 2,
      jobName: "job2",
      jobGroup: "group2",
      jobStatus: "Success",
      triggerName: "trigger2",
      triggerGroup: "group2",
      firedTime: new Date(),
      finishedTime: new Date()
    }
  ];

  let httpTestingController: HttpTestingController;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [UserNewComponent, ExecutionHistoryComponent, ListFiltersComponent, AddFilterFieldComponent, PickerComponent],
      imports: [TestingModule],
      providers: [
        JobService,
        ChangeDetectorRef,
      ],
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExecutionHistoryComponent);
    httpTestingController = TestBed.get(HttpTestingController);
    jobService = TestBed.get(JobService);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should list execution history', async () => {
    httpTestingController = TestBed.get(HttpTestingController);
    fixture.detectChanges();
    const req = httpTestingController.expectOne(req => req.method === 'GET' && req.url === baseUrl + '/jobs/jobExecutionHistory').flush(data);
    expect(component.executionHistory.length).toEqual(data.length);
    fixture.detectChanges();
    httpTestingController.verify();

  });
});
