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
import { ISearchField, operatorType } from 'src/app/common/components/list-filters/ISearchCriteria';
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

  defaultDateFormat: string = "mediumDate";
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
        if (this.columns.length > 3) {
          this.selectedColumns.push(this.columns[this.columns.length - 1]);
        }
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
    this.initializePickerPageInfo();

    let dialogConfig: IFCDialogConfig = <IFCDialogConfig>{
      Title: this.title,
      IsSingleSelection: true,
      DisplayField: "name"
    };

    this.dialogRef = this.pickerDialogService.open(dialogConfig);

    this.dataService.getAssociations(this.selectedAssociation.table, this.selectedAssociation.column.value, this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
      this.isLoadingPickerResults = false;
      this.dialogRef.componentInstance.items = items;
      this.updatePickerPageInfo(items);
    },
      error => this.errorMessage = <any>error
    );

    this.dialogRef.componentInstance.onScroll.subscribe(data => {
      this.onPickerScroll();
    })

    this.dialogRef.componentInstance.onSearch.subscribe(data => {
      this.onPickerSearch(data);
    })

    this.dialogRef.afterClosed().subscribe(result => {

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
    this.processListObservable(this.itemsObservable, listProcessingType.Replace)
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
    if (this.selectedAssociation !== undefined) {
      this.dataService.deleteAssociation(this.selectedAssociation.table, this.selectedAssociation.column.value, item["id"]).subscribe(result => {
        const index: number = this.items.findIndex(x => x.id == item.id);
        if (index !== -1) {
          this.items.splice(index, 1);
          this.items = [...this.items];
          this.changeDetectorRefs.detectChanges();
        }
      });
    }
    else {
      this.dataService.delete(item.id).subscribe(result => {
        let r = result;
        const index: number = this.items.findIndex(x => x.id == item.id);
        if (index !== -1) {
          this.items.splice(index, 1);
          this.items = [...this.items];
          this.changeDetectorRefs.detectChanges();
        }
      });
    }
  }

  isLoadingResults = true;

  currentPage: number;
  pageSize: number;
  lastProcessedOffset: number;
  hasMoreRecords: boolean;
  searchValue: ISearchField[] = [];

  initializePageInfo() {
    this.hasMoreRecords = true;
    this.pageSize = 5;
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
        this.itemsObservable = this.dataService.getAssociations(this.selectedAssociation.table, this.selectedAssociation.column.value, this.searchValue, this.currentPage * this.pageSize, this.pageSize, sortVal);
      }
      else {
        this.itemsObservable = this.dataService.getAll(this.searchValue, this.currentPage * this.pageSize, this.pageSize, sortVal);
      }
      this.processListObservable(this.itemsObservable, listProcessingType.Append);
    }
  }

  getSortValue(): string {
    let sortVal = '';
    if (this.sort.active && this.sort.direction) {
      sortVal = this.sort.active + "," + this.sort.direction;
    }
    return sortVal;
  }

  processListObservable(listObservable: Observable<E[]>, type: listProcessingType) {
    listObservable.subscribe(items => {
      this.isLoadingResults = false;
      if (type == listProcessingType.Replace) {
        this.items = items;
      }
      else {
        this.items = this.items.concat(items);
      }
      this.updatePageInfo(items);
    },
      error => this.errorMessage = <any>error
    )
  }

  getMobileLabelForField(field: string) {
    return field.replace(/([a-z])([A-Z])/g, '$1 $2');
  }

  isLoadingPickerResults = true;

  currentPickerPage: number;
  pickerPageSize: number;
  lastProcessedOffsetPicker: number;
  hasMoreRecordsPicker: boolean;
  searchValuePicker: ISearchField[] = [];
  pickerItemsObservable: Observable<any>;

  initializePickerPageInfo() {
    this.hasMoreRecordsPicker = true;
    this.pickerPageSize = 5;
    this.lastProcessedOffsetPicker = -1;
    this.currentPickerPage = 0;
  }

  //manage pages for virtual scrolling
  updatePickerPageInfo(data) {
    if (data.length > 0) {
      this.currentPickerPage++;
      this.lastProcessedOffsetPicker += data.length;
    }
    else {
      this.hasMoreRecordsPicker = false;
    }
  }

  onPickerScroll() {
    if (!this.isLoadingPickerResults && this.hasMoreRecordsPicker && this.lastProcessedOffsetPicker < this.dialogRef.componentInstance.items.length) {
      this.isLoadingPickerResults = true;
      if (this.selectedAssociation !== undefined) {
        this.pickerItemsObservable = this.dataService.getAssociations(this.selectedAssociation.table, this.selectedAssociation.column.value, this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize);
      }
      else {
        this.pickerItemsObservable = this.dataService.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize);
      }
      this.processPickerListObservable(this.pickerItemsObservable, listProcessingType.Append);
    }
  }

  onPickerSearch(searchValue: string) {
    this.searchValuePicker = [];
    if (searchValue) {
      let searchField: ISearchField = {
        fieldName: "name",
        searchValue: searchValue,
        operator: operatorType.Contains
      };
      this.searchValuePicker.push(searchField);
    }

    this.initializePickerPageInfo();

    if (!this.isLoadingPickerResults && this.hasMoreRecordsPicker && this.lastProcessedOffsetPicker < this.dialogRef.componentInstance.items.length) {
      this.isLoadingPickerResults = true;
      if (this.selectedAssociation !== undefined) {
        this.pickerItemsObservable = this.dataService.getAssociations(this.selectedAssociation.table, this.selectedAssociation.column.value, this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize);
      }
      else {
        this.pickerItemsObservable = this.dataService.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize);
      }
      this.processPickerListObservable(this.pickerItemsObservable, listProcessingType.Replace);
    }
  }

  processPickerListObservable(pickerListObservable: Observable<any>, type: listProcessingType) {
    pickerListObservable.subscribe(items => {
      this.isLoadingPickerResults = false;
      if (type == listProcessingType.Replace) {
        this.dialogRef.componentInstance.items = items;
      }
      else {
        this.dialogRef.componentInstance.items = this.dialogRef.componentInstance.items.concat(items);
      }
      this.updatePickerPageInfo(items);
    },
      error => this.errorMessage = <any>error
    )
  }
}