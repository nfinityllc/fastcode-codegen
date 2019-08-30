import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { I[=authenticationTable]permission } from './i[=moduleName]permission';
import { [=authenticationTable]permissionService } from './[=moduleName]permission.service';
import { Router, ActivatedRoute } from '@angular/router';
import { [=authenticationTable]permissionNewComponent} from './[=moduleName]permission-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';


import { [=authenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

@Component({
  selector: 'app-[=moduleName]permission-list',
  templateUrl: './[=moduleName]permission-list.component.html',
  styleUrls: ['./[=moduleName]permission-list.component.scss']
})
export class [=authenticationTable]permissionListComponent extends BaseListComponent<I[=authenticationTable]permission> implements OnInit {

	title:string = "[=authenticationTable]permission";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: [=authenticationTable]permissionService,
		public errorService: ErrorService,
		public [=authenticationTable?uncap_first]Service: [=authenticationTable]Service,
		public permissionService: PermissionService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.setAssociation();
		this.setColumns();
		this.primaryKeys = [ "permissionId", "userid",  ]
		super.ngOnInit();
	}
  
	setAssociation(){
  	
		this.associations = [
			{
				column: [
					{
						key: 'userid',
						value: undefined,
						referencedkey: 'userid'
					},					  
				],
				isParent: false,
				descriptiveField: '[=authenticationTable?uncap_first]Username',
				referencedDescriptiveField: 'username',
				service: this.[=authenticationTable?uncap_first]Service,
				associatedObj: undefined,
				table: '[=authenticationTable?uncap_first]',
				type: 'ManyToOne'
			},
			{
				column: [
                	{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					},  
				],
				isParent: false,
				descriptiveField: 'permissionName',
				referencedDescriptiveField: 'name',
				service: this.permissionService,
				associatedObj: undefined,
				table: 'permission',
				type: 'ManyToOne'
			},
		];
	}
  
  	setColumns(){
  		this.columns = [
			{
	  			column: '[=authenticationTable]',
				label: '[=authenticationTable]',
				sort: false,
				filter: false,
				type: listColumnType.Boolean
	  		},
			{
	  			column: 'Permission',
				label: 'Permission',
				sort: false,
				filter: false,
				type: listColumnType.Boolean
	  		},
		  	{
				column: 'actions',
				label: 'Actions',
				sort: false,
				filter: false,
				type: listColumnType.String
			}
		];
		this.selectedColumns = this.columns;
		this.displayedColumns = this.columns.map((obj) => { return obj.column });
  	}
  
	addNew() {
		super.addNew([=authenticationTable]permissionNewComponent);
	}
  
}
