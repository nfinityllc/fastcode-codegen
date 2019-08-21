import { Component, OnInit, Inject } from '@angular/core';
import { UsersService } from './users.service';
import { IUsers } from './iusers';

import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { RolesService } from '../roles/roles.service';

@Component({
	selector: 'app-users-new',
	templateUrl: './users-new.component.html',
	styleUrls: ['./users-new.component.scss']
})
export class UsersNewComponent extends BaseNewComponent<IUsers> implements OnInit {

	title: string = "New Users";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<UsersNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: UsersService,
		public rolesService: RolesService,
		public errorService: ErrorService
	) {
		super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	}

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();

		this.itemForm = this.formBuilder.group({
			emailAddress: ['', Validators.required],
			firstName: ['', Validators.required],
			isActive: [false],
			lastName: ['', Validators.required],
			userName: ['', Validators.required],
			password: ['', Validators.required],
			confirmPassword: ['', Validators.required],
			roleId: [''],
			rolesName: [{ value: '', disabled: true }],
		});
		this.checkPassedData();
	}

	setAssociations() {

		this.associations = [
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					}
				],
				isParent: false,
				table: 'roles',
				type: 'ManyToOne',
				service: this.rolesService,
				descriptiveField: 'rolesName',
			},
			{
				column: [
					{
						key: 'userId',
						value: undefined,
						referencedkey: 'id'
					}
				],
				isParent: true,
				table: 'permissions',
				type: 'ManyToMany',
			},
		];
		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne', 'OneToOne'].indexOf(association.type) > - 1) && !association.isParent);
		});

	}

}
