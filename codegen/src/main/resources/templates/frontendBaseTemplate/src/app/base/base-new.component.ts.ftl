import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { GenericApiService } from '../core/generic-api.service';
//import { IUser } from './iuser';
import { IBase } from './ibase';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { merge, of as observableOf, Observable } from 'rxjs';

import { Globals } from '../globals';

import { IAssociationEntry } from '../core/iassociationentry';
import { PickerComponent } from '../common/components/picker/picker.component';
import { PickerDialogService, IFCDialogConfig } from '../common/components/picker/picker-dialog.service';

@Component({

	template: ''

})
export class BaseNewComponent<E> implements OnInit {
	itemForm: FormGroup;
	loading = false;
	submitted = false;
	title: string = "title";

	pickerDialogRef: MatDialogRef<any>;

	associations: IAssociationEntry[];
	toMany: IAssociationEntry[];
	toOne: IAssociationEntry[];

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
		let parentField: string = association.descriptiveField.replace(association.table, '');
		parentField = parentField.charAt(0).toLowerCase() + parentField.slice(1);

		let dialogConfig: IFCDialogConfig = <IFCDialogConfig>{
			Title: association.table,
			IsSingleSelection: true,
			DisplayField: parentField
		};

		this.pickerDialogRef = this.pickerDialogService.open(dialogConfig);

		this.initializePickerPageInfo();
		association.service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
			this.isLoadingPickerResults = false;
			this.pickerDialogRef.componentInstance.items = items;
			this.updatePickerPageInfo(items);
		},
			error => this.errorMessage = <any>error
		);

		this.pickerDialogRef.componentInstance.onScroll.subscribe(data => {
			this.onPickerScroll();
		})

		this.pickerDialogRef.componentInstance.onSearch.subscribe(data => {
			this.onPickerSearch(data);
		})

		this.pickerDialogRef.afterClosed().subscribe(associatedItem => {
			if (associatedItem) {
				this.itemForm.get(association.column.key).setValue(associatedItem.id);
				this.itemForm.get(association.descriptiveField).setValue(associatedItem[parentField]);
			}
		});
	}

	isLoadingPickerResults = true;

	currentPickerPage: number;
	pickerPageSize: number;
	lastProcessedOffsetPicker: number;
	hasMoreRecordsPicker: boolean;
	searchValuePicker: any = "";
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
			let selectedAssociation: IAssociationEntry = this.toOne.find(association => association.table === this.pickerDialogRef.componentInstance.title);

			selectedAssociation.service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
				this.isLoadingPickerResults = false;
				this.pickerDialogRef.componentInstance.items = this.pickerDialogRef.componentInstance.items.concat(items);
				this.updatePickerPageInfo(items);
			},
				error => this.errorMessage = <any>error
			);

		}
	}

	onPickerSearch(searchValue: string) {
		console.log(this.pickerDialogRef.componentInstance);
		if (searchValue) {
			this.searchValuePicker = this.pickerDialogRef.componentInstance.displayField + ";" + searchValue;
		}
		else {
			this.searchValuePicker = "";
		}
		this.initializePickerPageInfo();

		let selectedAssociation: IAssociationEntry = this.toOne.find(association => association.table === this.pickerDialogRef.componentInstance.title);

		selectedAssociation.service.getAll(this.searchValuePicker, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
			this.isLoadingPickerResults = false;
			this.pickerDialogRef.componentInstance.items = items;
			this.updatePickerPageInfo(items);
		},
			error => this.errorMessage = <any>error
		);
	}

	checkPassedData() {
		if (this.data) {
			this.itemForm.patchValue(this.data);
		}
	}
}
