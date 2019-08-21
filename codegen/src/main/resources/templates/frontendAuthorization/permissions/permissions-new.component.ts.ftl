import { Component, OnInit, Inject } from '@angular/core';
import { PermissionsService } from './permissions.service';
import { IPermissions } from './ipermissions';

import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
	selector: 'app-permissions-new',
	templateUrl: './permissions-new.component.html',
	styleUrls: ['./permissions-new.component.scss']
})
export class PermissionsNewComponent extends BaseNewComponent<IPermissions> implements OnInit {

	title: string = "New Permissions";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<PermissionsNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: PermissionsService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	}

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();

		this.itemForm = this.formBuilder.group({
			displayName: [''],
			name: ['', Validators.required],
		});
		this.checkPassedData();
	}

	setAssociations() {

		this.associations = [
			{
				column: [
					{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					}
				],
				isParent: false,
				table: 'users',
				type: 'ManyToMany',
			},
			{
				column: [
					{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					}
				],
				isParent: false,
				table: 'roles',
				type: 'ManyToMany',
			},
		];
		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne', 'OneToOne'].indexOf(association.type) > - 1) && !association.isParent);
		});

	}

	// convenience getter for easy access to form fields


}
