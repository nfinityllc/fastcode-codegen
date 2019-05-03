import { Component, OnInit } from '@angular/core';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import {GenericApiService} from '../core/generic-api.service';
//import { IUser } from './iuser';
import { IBase } from './ibase';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';

import { IAssociationEntry } from '../core/iassociationentry';
import { PickerComponent } from '../common/components/picker/picker.component';

@Component({
  
  template: ''

})
export class BaseNewComponent<E> implements OnInit {
    protected itemForm: FormGroup;
    loading = false;
    submitted = false;
    title:string = "title";

    pickerDialogRef: MatDialogRef<any>;

    associations: IAssociationEntry[];
    toMany: IAssociationEntry[];
    toOne: IAssociationEntry[];

    isMediumDeviceOrLess: boolean;
    mediumDeviceOrLessDialogSize: string = "100%";
    largerDeviceDialogWidthSize: string = "65%";
    largerDeviceDialogHeightSize: string = "75%";
 
    constructor(
        public formBuilder: FormBuilder,
        public router: Router,
        public route: ActivatedRoute,
        public dialog: MatDialog,        
				public dialogRef: MatDialogRef<any>,
        public global: Globals,
        public dataService: GenericApiService<E>
        ) { }
 
    ngOnInit() {
       this.manageScreenResizing();
    }

    manageScreenResizing() {
        this.global.isMediumDeviceOrLess$.subscribe(value => {
          this.isMediumDeviceOrLess = value;
          if (this.dialogRef)
            this.dialogRef.updateSize(value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
              value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize);
        });
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
    
    selectAssociation(association) {
    console.log(association);
    this.pickerDialogRef = this.dialog.open(PickerComponent, {
        disableClose: true,
        height: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize,
        width: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
        maxWidth: "none",
        panelClass: 'fc-modal-dialog',
        data: {
        DataSource: association.service.getAll(),
        Title: association.table,
        IsSingleSelection: true
        }
    });
    this.pickerDialogRef.afterClosed().subscribe(associatedItem => {
        if (associatedItem) {
        this.itemForm.get(association.column.key).setValue(associatedItem.id);
        }
    });
    }
}
