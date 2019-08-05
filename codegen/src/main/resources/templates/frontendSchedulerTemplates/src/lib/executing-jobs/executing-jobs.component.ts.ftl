import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { first,filter } from 'rxjs/operators';
import { ExecutingJob, IExecutingJob } from './executingJob';
import { JobService } from '../jobs/job.service';
import { Router,ActivatedRoute } from '@angular/router';
import { Globals } from '../globals';

@Component({
  selector: 'app-executing-jobs',
  templateUrl: './executing-jobs.component.html',
  styleUrls: ['./executing-jobs.component.scss']
})
export class ExecutingJobsComponent implements OnInit {

  displayedColumnsExecutingJobs: string[] = ['triggerName', 'triggerGroup', 'jobName', 'jobGroup','jobClass', 'status', 'fireTime', 'nextExecutionTime']

  userId:number;
  executingJobs: IExecutingJob[] = [];
  errorMessage = '';
  isMediumDeviceOrLess:boolean;
  dialogRef: MatDialogRef <any> ;
  mediumDeviceOrLessDialogSize:string = "100%";
  largerDeviceDialogWidthSize:string = "85%";
  largerDeviceDialogHeightSize:string = "85%";
  constructor(private router: Router,private route: ActivatedRoute,private global:Globals, private jobService:JobService,
    public dialog: MatDialog,private changeDetectorRefs: ChangeDetectorRef) {

    }


  ngOnInit() {
    this.global.isMediumDeviceOrLess$.subscribe(value=> {
      this.isMediumDeviceOrLess=value;
      if(this.dialogRef)
      this.dialogRef.updateSize(value?this.mediumDeviceOrLessDialogSize:this.largerDeviceDialogWidthSize,
        value?this.mediumDeviceOrLessDialogSize:this.largerDeviceDialogHeightSize);
     
    });
    this.route.queryParams.subscribe(params => {
      console.log(params);
      this.userId = params['userId'];
      let query = this.userId ? 'userId='+ this.userId : null;
      this.jobService.getExecutingJobs().subscribe(
        perms => {
          console.log(perms);
          this.executingJobs = perms;
        },
        error => this.errorMessage = <any>error
      );
    })
  }

}
