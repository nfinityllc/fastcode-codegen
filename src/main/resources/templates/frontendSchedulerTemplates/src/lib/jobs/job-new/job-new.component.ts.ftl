import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../../globals';
import { MatDialogRef } from '@angular/material/dialog';
import { JobService } from '../job.service';
import { ActivatedRoute, Router } from "@angular/router";
import { Observable } from 'rxjs';
import { of } from 'rxjs';
import { FormControl } from '@angular/forms';
import { map, startWith } from 'rxjs/operators';

@Component({
  selector: 'app-job-new',
  templateUrl: './job-new.component.html',
  styleUrls: ['./job-new.component.scss']
})

export class JobNewComponent implements OnInit {
  jobForm: FormGroup;
  loading = false;
  submitted = false;
  ELEMENT_DATA = [];

  isMediumDeviceOrLess: boolean;

  displayedColumns: string[] = ['key', 'value', 'actions'];
  dataSource = of(this.ELEMENT_DATA);

  jobClasses: string[];
  options: string[];
  filteredOptions: Observable<string[]>;
  constructor(private formBuilder: FormBuilder, private router: Router,
    private global: Globals, private jobService: JobService,
    public dialogRef: MatDialogRef<JobNewComponent>
  ) { }

  ngOnInit() {

    this.global.isMediumDeviceOrLess$.subscribe(value => {
      this.isMediumDeviceOrLess = value;
    });

    this.jobForm = this.formBuilder.group({
      jobName: ['', Validators.required],
      jobGroup: ['', Validators.required],
      jobClass: ['', Validators.required],
      isDurable: [false],
      description: [''],
    });

    this.jobService.getJobGroups().subscribe(
      groups => {
        console.log(groups);
        this.options = groups;
        this.filteredOptions = this.jobForm.get('jobGroup').valueChanges
          .pipe(startWith(''),
            map(value => this._filter(value))
          );
      }
    );

    this.jobService.getJobClasses().subscribe(
      jobClasses => {
        console.log(jobClasses);
        this.jobClasses = jobClasses;
      }
    );

  }
  private _filter(value: string): string[] {
    const filterValue = value.toLowerCase();

    return this.options.filter(option => option.toLowerCase().includes(filterValue));
  }

  onSubmit() {
    this.submitted = true;

    // stop here if form is invalid
    if (this.jobForm.invalid) {
      return;
    }

    this.loading = true;
    let newJob = {};
    newJob = this.jobForm.value;
    newJob["jobMapData"] = {};
    this.ELEMENT_DATA.forEach(function (obj) {
      let tmp = {};
      tmp[obj.dataKey] = obj.dataValue;
      newJob["jobMapData"][obj.dataKey] = obj.dataValue;
    })
    this.jobService.create(this.jobForm.value)
      .pipe(first())
      .subscribe(
        data => {
          this.dialogRef.close(data);
        },
        error => {
          this.loading = false;
        });
  }

  onCancel(): void {
    this.dialogRef.close();
  }

  addJobData(): void {
    this.ELEMENT_DATA.push({
      "dataKey": "",
      "dataValue": ""
    })
    this.dataSource = of(this.ELEMENT_DATA);
  }

  removeJobData(index): void {
    this.ELEMENT_DATA.splice(index, 1);
    this.dataSource = of(this.ELEMENT_DATA);
  }


}
