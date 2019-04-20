import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
//import {MatDialog} from '@angular/material';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
//import { Observable } from 'rxjs';
import { IBase } from './ibase';

import { GenericApiService } from '../core/generic-api.service';
import { Router, ActivatedRoute } from '@angular/router';
import { Globals } from '../globals';
import { IListColumn, listColumnType } from '../common/ilistColumn';
//import { ComponentType } from '@angular/cdk/overlay';
import { ComponentType } from '@angular/cdk/portal';
import { IAssociationEntry } from '../core/iassociationentry';
import { PickerDialogService, IFCDialogConfig } from '../common/components/picker/picker-dialog.service';

@Component({

  template: '',
})
export class GenericDialog {

}
@Component({
  selector: 'app-base-list',
  template: ''
})
export class BaseListComponent<E> implements OnInit {

  defaultDateFormat: string = "short";
  associations: IAssociationEntry[];
  selectedAssociation: IAssociationEntry;

  //users$: Object;
  title: string = "title";
  items: E[] = [];
  //newItem:N;
  errorMessage = '';
  // displayedColumns: IListColumn[] = ['firstName', 'email', 'lastName'];
  columns: IListColumn[] = [];

  selectedColumns = this.columns;
  displayedColumns: string[] = this.columns.map((obj) => { return obj.column });

  isMediumDeviceOrLess: boolean;
  dialogRef: MatDialogRef<any>;
  mediumDeviceOrLessDialogSize: string = "100%";
  largerDeviceDialogWidthSize: string = "85%";
  largerDeviceDialogHeightSize: string = "85%";
  constructor(
    public router: Router,
    public route: ActivatedRoute,
    public dialog: MatDialog,
    public global: Globals,
    public changeDetectorRefs: ChangeDetectorRef,
    public pickerDialogService: PickerDialogService,
    public dataService: GenericApiService<E>
    ) { }

  ngOnInit() {
    this.manageScreenResizing();
    this.route.queryParams.subscribe(params => {
      console.log(params);
      this.checkForAssociations(params);
      this.getItems();
    });
  }

  manageScreenResizing() {
    this.global.isMediumDeviceOrLess$.subscribe(value => {
      this.isMediumDeviceOrLess = value;
      if (value) {
        this.selectedColumns = this.columns;
        this.selectedColumns = this.selectedColumns.slice(0, 3);
        this.displayedColumns = this.selectedColumns.map((obj, index) => { return obj.column });
      }
      else {
        this.selectedColumns = this.columns;
        this.displayedColumns = this.selectedColumns.map((obj) => { return obj.column });
      }
      if (this.dialogRef)
        this.dialogRef.updateSize(value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
          value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize);

    });
  }

  getItems() {
    if (this.selectedAssociation !== undefined) {
      this.dataService.getAssociations(this.selectedAssociation.table, this.selectedAssociation.column.value, '', 0, 20).subscribe(
        items => {
          this.items = items;
        },
        error => this.errorMessage = <any>error
      );
    }
    else {
      this.dataService.getAll(null, 0, 20).subscribe(
        items => {
          console.log(items)
          this.items = items;
        },
        error => this.errorMessage = <any>error
      );
    }
  }

  openDialog(k) {
    this.dialogRef = this.dialog.open(k, {
      disableClose: true,
      height: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize,
      width: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
      maxWidth: "none",
      panelClass: 'fc-modal-dialog'
    });
    this.dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.items = [...this.items, result];
        this.changeDetectorRefs.detectChanges();
      }
    });
  }
  addNew(k) {
    if (!this.selectedAssociation) {
      this.openDialog(k);
      return;
    }
    let dialogConfig: IFCDialogConfig = <IFCDialogConfig>{
      DataSource: this.dataService.getAll(),
      Title: this.title,
      IsSingleSelection: true
      //  OnClose:null
    };

    this.pickerDialogService.open(dialogConfig).subscribe(result => {

      if (result) {
      //   results.forEach(result => {
          this.dataService.addAssociation(this.selectedAssociation.table, this.selectedAssociation.column.value, result.id).subscribe(response => {
            this.getItems();
          });
        // }, err => {
        // });
      }
    });

  }

  applyFilter(filterCritaria): void {
    console.log(filterCritaria);
    this.dataService.getAll(filterCritaria).subscribe(
      items => {
        this.items = items;
        // this.users[0].firstName
        /* this.userService.getMainUsers().subscribe(log=> {
           let l = log;
         },error => {
           this.errorMessage = <any>error
          });*/
      },
      error => this.errorMessage = <any>error
    );
  }

  checkForAssociations(params) {
    this.associations.forEach((association) => {
      const columnValue = params[association.column.key];
      if (columnValue) {
        association.column.value = columnValue;
        this.selectedAssociation = association;
        console.log(this.selectedAssociation);
      }
    })
  }

  delete(item: E) {
    let currentPerm = item;
    if (this.selectedAssociation !== undefined) {
      this.dataService.deleteAssociation(this.selectedAssociation.table, this.selectedAssociation.column.value, item["id"]).subscribe(result => {
        this.getItems();
      });
    }
    else {
    	this.dataService.delete(item.id).subscribe(result => {
      	this.getItems();
      });
    }
  }

}
