import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

import { IUsers } from './iusers';
import { UsersService } from './users.service';
import { Router, ActivatedRoute } from '@angular/router';
import { UsersNewComponent } from './users-new.component';
//import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService } from 'fastCodeCore';
import { BaseListComponent,Globals, IListColumn, listColumnType, PickerDialogService, ErrorService  } from 'fastCodeCore';

import { RolesService } from '../roles/roles.service';
import { PermissionsService } from '../permissions/permissions.service';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
	selector: 'app-users-list',
	templateUrl: './users-list.component.html',
	styleUrls: ['./users-list.component.scss']
})
export class UsersListComponent extends BaseListComponent<IUsers> implements OnInit {

	title: string = "Users";
    entityName:string =  'IUsers';
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
			label: 'emailAddress',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'firstName',
			label: 'firstName',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'isActive',
			label: 'isActive',
			sort: true,
			filter: true,
			type: listColumnType.Boolean
		},
		{
			column: 'lastName',
			label: 'lastName',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'userName',
			label: 'userName',
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
		public globalPermissionService: GlobalPermissionService,
		public errorService: ErrorService
	) {
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, usersService, errorService);
		//this.globalPermissionService=globalPermissionService;
	}

	ngOnInit() {
		
		let test = this.IsDeletePermission;
		this.setAssociation();
		super.ngOnInit();
		let x = this.IsDeletePermission;
	}

	setAssociation() {

		this.associations = [
			{
				column:[ 
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					}
				],
				isParent: false,
				descriptiveField: 'rolesName',
				referencedDescriptiveField: 'name',
				service: this.rolesService,
				associatedObj: undefined,
				table: 'roles',
				type: 'ManyToOne'
			},
			{
				column: [
					{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					}
				],
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
