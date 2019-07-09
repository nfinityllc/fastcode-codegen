import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { IPermissions } from './ipermissions';
import { PermissionsService } from './permissions.service';
import { Router, ActivatedRoute } from '@angular/router';
import {PermissionsNewComponent} from './permissions-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService } from 'fastCodeCore';


import { UsersService } from '../users/users.service';
import { RolesService } from '../roles/roles.service';

@Component({
  selector: 'app-permissions-list',
  templateUrl: './permissions-list.component.html',
  styleUrls: ['./permissions-list.component.scss']
})
export class PermissionsListComponent extends BaseListComponent<IPermissions> implements OnInit {

	title:string = "Permissions";
  
	columns: IListColumn[] = [
		{
			column: 'id',
			label: 'id',
			sort: true,
			filter: false,
			type: listColumnType.Number
		},
		{
			column: 'displayName',
			label: 'displayName',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'name',
			label: 'name',
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
		public permissionsService: PermissionsService,
		public usersService: UsersService,
		public rolesService: RolesService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, permissionsService)
  }

	ngOnInit() {
		this.setAssociation();
		super.ngOnInit();
	}
  
	setAssociation(){
  	
		this.associations = [
			{
				column: {
					key: 'userId',
					value: undefined
				},
				isParent: false,
				descriptiveField: 'usersUserName',
				referencedDescriptiveField: 'userName',
				service: this.usersService,
				associatedObj: undefined,
				table: 'users',
				type: 'ManyToMany'
			},
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
				type: 'ManyToMany'
			},
		];
	}
  
	addNew() {
		super.addNew(PermissionsNewComponent);
	}
  
}
