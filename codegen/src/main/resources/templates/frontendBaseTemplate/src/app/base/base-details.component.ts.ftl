import { Component, OnInit } from '@angular/core';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { GenericApiService } from '../core/generic-api.service';
import { IBase } from './ibase';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { Globals } from '../globals';
import { IAssociationEntry } from '../core/iassociationentry';
import { IAssociation } from '../core/iassociation';

import { PickerComponent } from '../common/components/picker/picker.component'
@Component({

  template: ''

})
export class BaseDetailsComponent<E extends IBase> implements OnInit {

  associations: IAssociationEntry[];
  toMany: IAssociationEntry[];
  toOne: IAssociationEntry[];

  dialogRef: MatDialogRef<any>;

  title: string = 'Title';
  item: E | undefined;
  parentUrl: string;
  idParam: string;
  itemForm: FormGroup;
  errorMessage = '';
  loading = false;
  submitted = false;

  isMediumDeviceOrLess: boolean;
  mediumDeviceOrLessDialogSize: string = "100%";
  largerDeviceDialogWidthSize: string = "65%";
  largerDeviceDialogHeightSize: string = "75%";

  /*constructor(private route: ActivatedRoute, private userService: UserService) { 
     this.route.params.subscribe( params => this.user$ = params.id );
  }*/
  constructor(
    public formBuilder: FormBuilder,
    public router: Router,
    public route: ActivatedRoute,
    public dialog: MatDialog,
    public global: Globals,
    public dataService: GenericApiService<E>
    
    ) {
  }

  ngOnInit() {
    this.idParam = this.route.snapshot.paramMap.get('id');
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

  getItem(id: number): Observable<E> {
    return this.dataService.getById(id);
  }

  onSubmit() {
    this.submitted = true;

    // stop here if form is invalid
    if (this.itemForm.invalid) {
      return;
    }

    this.loading = true;
    this.dataService.update(this.itemForm.value, this.item.id)
      .pipe(first())
      .subscribe(
        data => {
          // this.alertService.success('Registration successful', true);
          this.loading = false;
          this.router.navigate([this.parentUrl]);
          //  this.dialogRef.close(data);
        },
        error => {

          this.loading = false;
        });
  }
  onDelete() {


    this.loading = true;
    this.dataService.delete(this.item.id)
      // .pipe(first())
      .subscribe(
        data => {
          // this.alertService.success('Registration successful', true);
          this.loading = false;
          this.router.navigate([this.parentUrl]);

          //  this.dialogRef.close(data);
        },
        error => {

          this.loading = false;
        });
  }
  onBack(): void {
    this.router.navigate([this.parentUrl]);
  }

  selectAssociation(association) {
    console.log(association);
    this.dialogRef = this.dialog.open(PickerComponent, {
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
    this.dialogRef.afterClosed().subscribe(associatedItem => {
      if (associatedItem) {
        this.itemForm.get(association.column.key).setValue(associatedItem.id);
      }
    });
  }

  getQueryParams(association) {
    let queryParam: any = {};
    queryParam[association.column.key] = this.item.id;
    return queryParam;
  }

}
