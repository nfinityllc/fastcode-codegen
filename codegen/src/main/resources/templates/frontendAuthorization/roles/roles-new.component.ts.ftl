import { Component, OnInit, Inject } from '@angular/core';
import { RolesService } from './roles.service';
import { IRoles } from './iroles';

import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
	selector: 'app-roles-new',
	templateUrl: './roles-new.component.html',
	styleUrls: ['./roles-new.component.scss']
})
export class RolesNewComponent extends BaseNewComponent<IRoles> implements OnInit {

	title: string = "New Roles";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<RolesNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: RolesService,
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
				column: [{
					key: 'roleId',
					value: undefined,
					referencedkey: 'id'
				}],
				isParent: true,
				table: 'users',
				type: 'OneToMany',
			},
			{
				column: [{
					key: 'roleId',
					value: undefined,
					referencedkey: 'id'
				}],
				isParent: true,
				table: 'permissions',
				type: 'ManyToMany',
			},
		];
		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne', 'OneToOne'].indexOf(association.type) > - 1) && !association.isParent);
		});

	}

	// convenience getter for easy access to form fields


}
