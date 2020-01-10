import { Component, OnInit, ChangeDetectorRef, ViewChild } from '@angular/core';
import { EntityHistory, IEntityHistory } from './entityHistory';
import { EntityHistoryService } from './entity-history.service';
import { MatTableDataSource, Sort, MatDialog, MatDialogRef, MAT_DIALOG_DATA, MatSort } from "@angular/material";
import { Globals } from '../globals';
import { ManageEntityHistoryComponent } from '../manage-entity-history/manage-entity-history.component';

import { merge, of as observableOf, Observable, SubscriptionLike } from 'rxjs';

import { ErrorService, PickerDialogService, IFCDialogConfig, ISearchField, operatorType } from 'fastCodeCore';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';

import { [=AuthenticationTable]Service } from '../[=ModuleName]/[=ModuleName].service';

enum listProcessingType {
  Replace = "Replace",
  Append = "Append"
}

@Component({
  selector: 'app-entity-history',
  templateUrl: './entity-history.component.html',
  styleUrls: ['./entity-history.component.scss']
})

export class EntityHistoryComponent implements OnInit {

  entityHistory: IEntityHistory[] = [];
  itemsObservable: Observable<IEntityHistory[]>;
  errorMessage: '';
  displayedColumns: string[] = ['entity', 'cdoId', 'changeType', 'author', 'commitDate', 'propertyName', 'previousValue', 'currentValue'];

  public dataSource;

  
  pickerDialogRef: MatDialogRef<any>;

  isMediumDeviceOrLess: boolean;
  dialogRef: MatDialogRef<any>;
  mediumDeviceOrLessDialogSize: string = "100%";
  largerDeviceDialogWidthSize: string = "75%";
  largerDeviceDialogHeightSize: string = "75%";

  states: string[] = [
    'Alabama',
  ];
  state: string = "All";

  filterFields = [];
  basicFilterForm: FormGroup;

  constructor(
    private global: Globals,
    private entityHistoryService: EntityHistoryService,
    private changeDetectorRefs: ChangeDetectorRef,
    public dialog: MatDialog,
    public errorService: ErrorService,
    public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
    public pickerDialogService: PickerDialogService,
    private formBuilder: FormBuilder,
  ) { }

  ngOnInit() {
    this.manageScreenResizing();
    this.getEntityHistory();

    this.basicFilterForm = this.formBuilder.group({
      author : [''],
      from : [''],
      to : ['']
    });
  }

  getEntityHistory() {
    this.isLoadingResults = true;
    this.initializePageInfo();
    this.itemsObservable = this.entityHistoryService.getAll(this.searchValue, this.currentPage * this.pageSize, this.pageSize);
    this.processListObservable(this.itemsObservable, listProcessingType.Replace);
  }

  manageScreenResizing() {
    this.global.isMediumDeviceOrLess$.subscribe(value => {
      this.isMediumDeviceOrLess = value;
      if (value)
        this.displayedColumns = ['entity', 'cdoId', 'commitDate', 'author'];
      else
        this.displayedColumns = ['entity', 'cdoId', 'changeType', 'author', 'commitDate', 'propertyName', 'previousValue', 'currentValue']

      if (this.dialogRef)
        this.dialogRef.updateSize(value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
          value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize);
    });
  }

  createSearchString() {
    let searchString : string = "";
    let searchFormValue = this.basicFilterForm.getRawValue();
    if(searchFormValue.author){
      searchString += "author=" + searchFormValue.author;
    }
    
    if(searchFormValue.from){
      if(searchString.length > 0){
        searchString += ";";
      }
      let from = new Date(searchFormValue.from);
      searchString += "from=" + from.getFullYear() + "-" + (from.getMonth() + 1) + "-" + from.getDate() + " " + from.getHours() + ":" + from.getMinutes() + ":" + from.getSeconds() + "." + from.getMilliseconds();
    }
    
    if(searchFormValue.to){
      if(searchString.length > 0){
        searchString += ";";
      }
      let to = new Date(searchFormValue.to);
      searchString += "to=" + to.getFullYear() + "-" + (to.getMonth() + 1) + "-" + to.getDate() + " " + to.getHours() + ":" + to.getMinutes() + ":" + to.getSeconds() + "." + to.getMilliseconds();
    }

    return searchString;
  }

  applyFilter() {
    this.searchValue = this.createSearchString();
    this.isLoadingResults = true;
    this.initializePageInfo();
    this.itemsObservable = this.entityHistoryService.getAll(
      this.searchValue,
      this.currentPage * this.pageSize,
      this.pageSize,
    )
    this.processListObservable(this.itemsObservable, listProcessingType.Replace)
  }

  openDialog() {

    this.dialogRef = this.dialog.open(ManageEntityHistoryComponent, {
      disableClose: true,
      height: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize,
      width: this.isMediumDeviceOrLess ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
      maxWidth: "none",
      panelClass: 'fc-modal-dialog'
    });
    this.dialogRef.afterClosed().subscribe(result => {
      console.log(`Dialog result: ${result}`);

    });

  }

  add() {
    //this.openDialog();
  }
  closeUserDialog() {
    var result: any;
    this.dialogRef.close(result);
  }

  isLoadingResults = true;

  currentPage: number;
  pageSize: number;
  lastProcessedOffset: number;
  hasMoreRecords: boolean;
  searchValue: string = "";

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
    if (!this.isLoadingResults && this.hasMoreRecords && this.lastProcessedOffset < this.entityHistory.length) {
      this.isLoadingResults = true;
      this.itemsObservable = this.entityHistoryService.getAll(this.searchValue, this.currentPage * this.pageSize, this.pageSize);
      this.processListObservable(this.itemsObservable, listProcessingType.Append);
    }
  }

  processListObservable(listObservable: Observable<IEntityHistory[]>, type: listProcessingType) {
    listObservable.subscribe(
      entityHistory => {
        this.isLoadingResults = false;
        if (type == listProcessingType.Replace) {
          this.entityHistory = entityHistory;
          this.dataSource = new MatTableDataSource(this.entityHistory);
        }
        else {
          this.entityHistory = this.entityHistory.concat(entityHistory);
          this.dataSource = new MatTableDataSource(this.entityHistory);
        }
        this.updatePageInfo(entityHistory);
      },
      error => {
        this.errorMessage = <any>error
        this.errorService.showError("An error occured while fetching results");
      }
    )
  }

  selectAuthor() {

		let dialogConfig: IFCDialogConfig = <IFCDialogConfig>{
			Title: "Author",
			IsSingleSelection: true,
			DisplayField: "[=UserNameField]"
		};

		this.pickerDialogRef = this.pickerDialogService.open(dialogConfig);

		this.initializePickerPageInfo();
		this.[=AuthenticationTable?uncap_first]Service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
			this.isLoadingPickerResults = false;
			this.pickerDialogRef.componentInstance.items = items;
			this.updatePickerPageInfo(items);
		},
			error => {
				this.errorMessage = <any>error;
				this.pickerDialogRef.close();
				this.errorService.showError("An error occured while fetching results");
			}
		);

		this.pickerDialogRef.componentInstance.onScroll.subscribe(data => {
			this.onPickerScroll();
		})

		this.pickerDialogRef.componentInstance.onSearch.subscribe(data => {
			this.onPickerSearch(data);
		})

		this.pickerDialogRef.afterClosed().subscribe(user => {
      if (user) {
				this.basicFilterForm.get('author').setValue(user.[=UserNameField?uncap_first]);
			}
		});
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
		this.pickerPageSize = 30;
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
		if (!this.isLoadingPickerResults && this.hasMoreRecordsPicker && this.lastProcessedOffsetPicker < this.pickerDialogRef.componentInstance.items.length) {
			this.isLoadingPickerResults = true;
			this.[=AuthenticationTable?uncap_first]Service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(
				items => {
					this.isLoadingPickerResults = false;
					this.pickerDialogRef.componentInstance.items = this.pickerDialogRef.componentInstance.items.concat(items);
					this.updatePickerPageInfo(items);
				},
				error => {
					this.errorMessage = <any>error;
					this.errorService.showError("An error occured while fetching more results");
				}
			);

		}
	}

	onPickerSearch(searchValue: string) {
		if (searchValue) {
			let searchField: ISearchField = {
				fieldName: this.pickerDialogRef.componentInstance.displayField,
				operator: operatorType.Contains,
				searchValue: searchValue
			}
			this.searchValuePicker = [searchField];
		}

		this.initializePickerPageInfo();

		this.[=AuthenticationTable?uncap_first]Service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(
      items => {
				this.isLoadingPickerResults = false;
				this.pickerDialogRef.componentInstance.items = items;
				this.updatePickerPageInfo(items);
			},
			error => {
				this.errorMessage = <any>error
				this.errorService.showError("An error occured while fetching results");
      }
    )
	}

}