import { Component, OnInit, Inject, HostListener } from '@angular/core';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';

import { GenericApiService } from '../core/generic-api.service';
//import { IUser } from './iuser';
import { IBase } from './ibase';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { merge, of as observableOf, Observable } from 'rxjs';

import { Globals } from '../../globals';

import { IAssociationEntry } from '../core/iassociationentry';
import { PickerComponent } from '../../common/components/picker/picker.component';
import { PickerDialogService, IFCDialogConfig } from '../../common/components/picker/picker-dialog.service';
import { ISearchField, operatorType } from '../../common/components/list-filters/ISearchCriteria';
import { IGlobalPermissionService } from '../core/iglobal-permission.service';

import { CanDeactivateGuard } from '../core/can-deactivate.guard';
import { ErrorService } from '../core/error.service';
@Component({

	template: ''

})
export class BaseNewComponent<E> implements OnInit, CanDeactivateGuard {

	// @HostListener allows us to also guard against browser refresh, close, etc.
	@HostListener('window:beforeunload')
	canDeactivate(): Observable<boolean> | boolean {
		// returning true will navigate without confirmation
		// returning false will show a confirm dialog before navigating away
		if (this.itemForm.touched) {
			return false
		}
		return true;
	}

	itemForm: FormGroup;
	loading = false;
	submitted = false;
	title: string = "title";

	pickerDialogRef: MatDialogRef<any>;

	associations: IAssociationEntry[];
	parentAssociations: IAssociationEntry[];

	entityName: string = "";
	IsReadPermission: Boolean = false;
	IsCreatePermission: Boolean = false;
	IsUpdatePermission: Boolean = false;
	IsDeletePermission: Boolean = false;
	globalPermissionService: IGlobalPermissionService;

	isMediumDeviceOrLess: boolean;
	mediumDeviceOrLessDialogSize: string = "100%";
	largerDeviceDialogWidthSize: string = "65%";
	largerDeviceDialogHeightSize: string = "75%";

	errorMessage = '';

	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<any>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: GenericApiService<E>,
		public errorService: ErrorService
	) { }

	setPermissions = () => {

		if (this.globalPermissionService) {
			let entityName = this.entityName.startsWith("I") ? this.entityName.substr(1) : this.entityName;
			this.IsCreatePermission = this.globalPermissionService.hasPermissionOnEntity(entityName, "CREATE");
			if (this.IsCreatePermission) {
				this.IsReadPermission = true;
				this.IsDeletePermission = true;
				this.IsUpdatePermission = true;
			} else {
				this.IsDeletePermission = this.globalPermissionService.hasPermissionOnEntity(entityName, "DELETE");
				this.IsUpdatePermission = this.globalPermissionService.hasPermissionOnEntity(entityName, "UPDATE");
				this.IsReadPermission = (this.IsDeletePermission || this.IsUpdatePermission) ? true : this.globalPermissionService.hasPermissionOnEntity(entityName, "READ");
			}
		}
		//});
	}
	ngOnInit() {
		this.setPermissions();
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

	onSubmit() {
		this.submitted = true;
		// stop here if form is invalid
		if (this.itemForm.invalid) {
			return;
		}

		this.loading = true;
		this.dataService.create(this.itemForm.getRawValue())
			.pipe(first())
			.subscribe(
				data => {
					// this.alertService.success('Registration successful', true);
					// this.router.navigate(['/users']);
					this.dialogRef.close(data);
				},
				error => {
					this.errorService.showError("Error Occured while updating");
					this.loading = false;
					this.dialogRef.close(null)

				});
	}
	onCancel(): void {
		this.dialogRef.close(null);
	}

	selectAssociation(association) {

		let dialogConfig: IFCDialogConfig = <IFCDialogConfig>{
			Title: association.table,
			IsSingleSelection: true,
			DisplayField: association.referencedDescriptiveField
		};

		this.pickerDialogRef = this.pickerDialogService.open(dialogConfig);

		this.initializePickerPageInfo();
		association.service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
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

		this.pickerDialogRef.afterClosed().subscribe(associatedItem => {
			if (associatedItem) {
				association.column.forEach(col => {
					this.itemForm.get(col.key).setValue(associatedItem[col.referencedkey]);
				});
				this.itemForm.get(association.descriptiveField).setValue(associatedItem[association.referencedDescriptiveField]);
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
		this.pickerPageSize = 20;
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
			let selectedAssociation: IAssociationEntry = this.associations.find(association => association.table === this.pickerDialogRef.componentInstance.title);

			selectedAssociation.service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(
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

		let selectedAssociation: IAssociationEntry = this.associations.find(association => association.table === this.pickerDialogRef.componentInstance.title);

		selectedAssociation.service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(
			items => {
				this.isLoadingPickerResults = false;
				this.pickerDialogRef.componentInstance.items = items;
				this.updatePickerPageInfo(items);
			},
			error => {
				this.errorMessage = <any>error
				this.errorService.showError("An error occured while fetching results");
			}
		);
	}

	checkPassedData() {
		if (this.data) {
			this.itemForm.patchValue(this.data);
		}
	}
}