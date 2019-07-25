import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

import { IRoles } from './iroles';
import { RolesService } from './roles.service';
import { Router, ActivatedRoute } from '@angular/router';
import { RolesNewComponent } from './roles-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService } from 'fastCodeCore';

import { PermissionsService } from '../permissions/permissions.service';

@Component({
	selector: 'app-roles-list',
	templateUrl: './roles-list.component.html',
	styleUrls: ['./roles-list.component.scss']
})
export class RolesListComponent extends BaseListComponent<IRoles> implements OnInit {

	title: string = "Roles";

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
			label: 'Display Name',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'name',
			label: 'Name',
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
		public rolesService: RolesService,
		public permissionsService: PermissionsService,
	) {
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, rolesService)
	}

	ngOnInit() {
		this.setAssociation();
		super.ngOnInit();
	}

	setAssociation() {

		this.associations = [
			{
				column: {
					key: 'permissionId',
					value: undefined
				},
				isParent: true,
				descriptiveField: 'permissionsName',
				referencedDescriptiveField: 'name',
				service: this.permissionsService,
				associatedObj: undefined,
				table: 'permissions',
				type: 'ManyToMany'
			},
		];
	}

	addNew() {
		super.addNew(RolesNewComponent);
	}

}
