import { Component, OnInit, ChangeDetectorRef, ViewChild } from '@angular/core';
//import {MatDialog} from '@angular/material';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA, MatSort, MatTableDataSource } from '@angular/material';
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

import { merge, of as observableOf, Observable } from 'rxjs';
import { catchError, map, startWith, switchMap } from 'rxjs/operators';
@Component({

  template: '',
})
export class GenericDialog {

}

enum listProcessingType {
  Replace = "Replace",
  Append = "Append"
}

@Component({
  selector: 'app-base-list',
  template: ''
})

export class BaseListComponent<E extends IBase> implements OnInit {

  defaultDateFormat: string = "short";
  associations: IAssociationEntry[];
  selectedAssociation: IAssociationEntry;

  @ViewChild(MatSort) sort: MatSort;

  //users$: Object;
  title: string = "title";
  items: E[] = [];
  itemsObservable: Observable<E[]>;
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
      this.checkForAssociations(params);
      this.setSort();
    });
  }

  setSort() {
    this.sort.sortChange.pipe(
      startWith({}),
      switchMap(() => {
        this.isLoadingResults = true;
        this.initializePageInfo();
        let sortVal = this.getSortValue();

        if (this.selectedAssociation !== undefined) {
          return this.dataService.getAssociations(
            this.selectedAssociation.table,
            this.selectedAssociation.column.value,
            this.searchValue,
            this.currentPage * this.pageSize,
            this.pageSize,
            sortVal
          )
        }
        else {
          return this.dataService.getAll(this.searchValue, this.currentPage * this.pageSize, this.pageSize, sortVal);
        }
      }),
      map(data => {
        // Flip flag to show that loading has finished.
        this.isLoadingResults = false;
        return data;
      }),
      catchError(() => {
        this.isLoadingResults = false;
        // Catch if some error occurred. Return empty data.
        return observableOf([]);
      })
    ).subscribe(data => {
      this.items = data;
      //manage pages for virtual scrolling
      this.updatePageInfo(data);
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
    this.isLoadingResults = true;
    this.initializePageInfo();
    let sortVal = this.getSortValue();
    if (this.selectedAssociation !== undefined) {
      this.itemsObservable = this.dataService.getAssociations(
        this.selectedAssociation.table,
        this.selectedAssociation.column.value,
        this.searchValue,
        this.currentPage * this.pageSize,
        this.pageSize,
        sortVal
      )
    }
    else {
      this.itemsObservable = this.dataService.getAll(
        this.searchValue,
        this.currentPage * this.pageSize,
        this.pageSize,
        sortVal
      )
    }
    this.processListObservable(this.itemsObservable, listProcessingType.Replace);
  }

  openDialog(k, data) {
    this.dialogRef = this.dialog.open(k, {
      disableClose: true,
      height: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize,
      width: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
      maxWidth: "none",
      panelClass: 'fc-modal-dialog',
      data: data
    });
    this.dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.getItems();
      }
    });
  }
  addNew(k) {
    if (!this.selectedAssociation) {
      this.openDialog(k, null);
      return;
    }
    else if (this.selectedAssociation.type != "ManyToMany") {
      let data: any = {}
      data[this.selectedAssociation.column.key] = this.selectedAssociation.column.value;
      data[this.selectedAssociation.descriptiveField] = this.selectedAssociation.associatedObj[this.selectedAssociation.referencedDescriptiveField];
      this.openDialog(k, data);
      return;
    }
    let dialogConfig: IFCDialogConfig = <IFCDialogConfig>{
      DataSource: this.dataService.getAll(),
      Title: this.title,
      IsSingleSelection: true,
      DisplayField: "name",
      selectedList: this.items.map(item => item.id)
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
    this.searchValue = filterCritaria;
    this.isLoadingResults = true;
    this.initializePageInfo();
    let sortVal = this.getSortValue();
    if (this.selectedAssociation !== undefined) {
      // this.itemsObservable = this.dataService.getAssociations(
      //   this.selectedAssociation.table,
      //   this.selectedAssociation.column.value,
      //   this.searchValue,
      //   this.currentPage * this.pageSize,
      //   this.pageSize,
      //   sortVal
      //   )
    }
    else {
      this.itemsObservable = this.dataService.getAll(
        this.searchValue,
        this.currentPage * this.pageSize,
        this.pageSize,
        sortVal
      )
      this.processListObservable(this.itemsObservable, listProcessingType.Replace)
    }

  }

  checkForAssociations(params) {
    this.selectedAssociation = undefined;
    this.associations.forEach((association) => {
      const columnValue = params[association.column.key];
      if (columnValue) {
        association.column.value = columnValue;
        this.selectedAssociation = association;
        this.selectedAssociation.service.getById(this.selectedAssociation.column.value).subscribe(parentObj => {
          this.selectedAssociation.associatedObj = parentObj;
        })
      }
    })
  }

  delete(item: E) {
    let currentPerm = item;
    if (this.selectedAssociation !== undefined && this.selectedAssociation.type == "ManyToMany") {
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

  isLoadingResults = true;

  currentPage: number;
  pageSize: number;
  lastProcessedOffset: number;
  hasMoreRecords: boolean;
  searchValue: any = "";

  initializePageInfo() {
    this.hasMoreRecords = true;
    this.pageSize = 10;
    this.lastProcessedOffset = -1;
    this.currentPage = 0;
  }

  //manage pages for virtual scrolling
  updatePageInfo(data) {
    if (data.length > 0) {
      this.currentPage++;
      this.lastProcessedOffset += data.length;
    }
    else {
      this.hasMoreRecords = false;
    }
  }

  onTableScroll() {
    if (!this.isLoadingResults && this.hasMoreRecords && this.lastProcessedOffset < this.items.length) {
      this.isLoadingResults = true;
      let sortVal = this.getSortValue();
      if (this.selectedAssociation !== undefined) {
        // this.itemsObservable = this.dataService.getAssociations(this.selectedAssociation.table, this.selectedAssociation.column.value, this.searchValue, this.currentPage * this.pageSize, this.pageSize, sortVal);
      }
      else {
        this.itemsObservable = this.dataService.getAll(this.searchValue, this.currentPage * this.pageSize, this.pageSize, sortVal);
        this.processListObservable(this.itemsObservable, listProcessingType.Append);
      }
    }
  }

  getSortValue():string {
    let sortVal = '';
    if (this.sort.active && this.sort.direction) {
      sortVal = this.sort.active + "," + this.sort.direction;
    }
    return sortVal;
  }

  processListObservable(listObservable:Observable<E[]>, type:listProcessingType){
    listObservable.subscribe(items => {
        this.isLoadingResults = false;
        if(type == listProcessingType.Replace){
          this.items = items;
        }
        else{
          this.items = this.items.concat(items);
        }
        this.updatePageInfo(items);
      },
      error => this.errorMessage = <any>error
    )
  }
}