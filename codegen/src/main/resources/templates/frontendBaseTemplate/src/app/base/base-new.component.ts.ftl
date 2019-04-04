import { Component, OnInit } from '@angular/core';

import {GenericApiService} from '../core/generic-api.service';
//import { IUser } from './iuser';
import { IBase } from './ibase';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
 
@Component({
  
  template: ''

})
export class BaseNewComponent<E> implements OnInit {
    protected itemForm: FormGroup;
    loading = false;
    submitted = false;
    title:string = "title";
 
    constructor(public formBuilder: FormBuilder, public router: Router,
        public global:Globals, public dataService: GenericApiService<E>,
       public dialogRef: MatDialogRef<any>
        ) { }
 
    ngOnInit() {
       
    }
 
    // convenience getter for easy access to form fields
    get f() { return this.itemForm.controls; }
 
    onSubmit() {
        this.submitted = true;
 
        // stop here if form is invalid
        if (this.itemForm.invalid) {
            return;
        }
 
        this.loading = true;
        this.dataService.create(this.itemForm.value)
            .pipe(first())
            .subscribe(
                data => {
                   // this.alertService.success('Registration successful', true);
                   // this.router.navigate(['/users']);
                    this.dialogRef.close(data);
                },
                error => {
                   
                    this.loading = false;
                });
    }
    onCancel(): void {
        this.dialogRef.close();
      }
    
}
