import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

import { IUsers } from './iusers';
import { UsersService } from './users.service';
import { Router, ActivatedRoute } from '@angular/router';
import { UsersNewComponent } from './users-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService } from 'fastCodeCore';


import { RolesService } from '../roles/roles.service';
import { PermissionsService } from '../permissions/permissions.service';

@Component({
	selector: 'app-users-list',
	templateUrl: './users-list.component.html',
	styleUrls: ['./users-list.component.scss']
})
export class UsersListComponent extends BaseListComponent<IUsers> implements OnInit {

	title: string = "Users";

	columns: IListColumn[] = [
		{
			column: 'id',
			label: 'id',
			sort: true,
			filter: false,
			type: listColumnType.Number
		},
		{
			column: 'emailAddress',
			label: 'Email Address',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'firstName',
			label: 'First Name',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'isActive',
			label: 'Active',
			sort: true,
			filter: true,
			type: listColumnType.Boolean
		},
		{
			column: 'lastName',
			label: 'Last Name',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'userName',
			label: 'Username',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'actions',
			label: 'Actions',
			sort: false,
			filter: false,
			type: listColumnType.String
		}
	];

	selectedColumns = this.columns;
	displayedColumns: string[] = this.columns.map((obj) => { return obj.column });


	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public usersService: UsersService,
		public rolesService: RolesService,
		public permissionsService: PermissionsService,
	) {
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, usersService)
	}

	ngOnInit() {
		this.setAssociation();
		super.ngOnInit();
	}

	setAssociation() {

		this.associations = [
			{
				column: {
					key: 'roleId',
					value: undefined
				},
				isParent: false,
				descriptiveField: 'rolesName',
				referencedDescriptiveField: 'name',
				service: this.rolesService,
				associatedObj: undefined,
				table: 'roles',
				type: 'ManyToOne'
			},
			{
				column: {
					key: 'permissionId',
					value: undefined
				},
				isParent: true,
				descriptiveField: 'permissionsUserName',
				referencedDescriptiveField: 'userName',
				service: this.permissionsService,
				associatedObj: undefined,
				table: 'permissions',
				type: 'ManyToMany'
			},
		];
	}

	addNew() {
		super.addNew(UsersNewComponent);
	}

}
