import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import {  IEmailVariable } from './iemail-variable';
import { EmailVariableService } from './email-variable.service';
import { Router, ActivatedRoute } from '@angular/router';
import {EmailVariableNewComponent} from './email-variable-new.component';
//import {BaseListComponent} from '../base/base-list.component';
//import { Globals } from '../globals';
//import { IListColumn, listColumnType } from '../common/ilistColumn';
//import { PickerDialogService } from '../common/components/picker/picker-dialog.service';
//import { BaseListComponent,Globals,IListColumn, listColumnType,PickerDialogService } from 'fastCodeCore';// from 'fastCodeCore';
import { BaseListComponent,Globals,IListColumn, listColumnType,PickerDialogService, GlobalPermissionService, ErrorService } from 'projects/fast-code-core/src/public_api';// 'fastCodeCore';
@Component({
	selector: 'app-email-variable-list',
	templateUrl: './email-variable-list.component.html',
	styleUrls: ['./email-variable-list.component.scss']
  })
export class EmailVariableListComponent extends BaseListComponent<IEmailVariable> implements OnInit {

	title:string = "Emailvariable";
  
	columns: IListColumn[] = [
		{
			column: 'propertyName',
			label: 'propertyName',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'propertyType',
			label: 'propertyType',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		
		
		{
			column: 'lastModificationTime',
			label: 'lastModificationTime',
			sort: false,
			filter: false,
			type: listColumnType.Date
		},
		{
			column: 'lastModifierUserId',
			label: 'lastModifierUserId',
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

    entityName:string =  'EmailVariable';
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public emailvariableService: EmailVariableService,
		public globalPermissionService: GlobalPermissionService,
		public errorService: ErrorService
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, emailvariableService, errorService)
  }

	ngOnInit() {
		this.setAssociation();
		super.ngOnInit();
	}
	setAssociation(){
  
		this.associations = [
		];
	}
  
	addNew() {
		super.addNew(EmailVariableNewComponent);
	}
  
}
