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
import { BaseListComponent,Globals,IListColumn, listColumnType,PickerDialogService } from 'fastCodeCore';// from 'projects/fast-code-core/src/public_api';
import { TranslateService } from '@ngx-translate/core';

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
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-NAME'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'propertyType',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-TYPE'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		
		
		{
			column: 'lastModificationTime',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.LAST-MODIFICATION-TIME'),
			sort: false,
			filter: false,
			type: listColumnType.Date
		},
		{
			column: 'lastModifierUserId',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.LAST-MODIFIER-USER-ID'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		
  	{
			column: 'actions',
			label: this.translate.instant('EMAIL-GENERAL.ACTIONS.ACTIONS'),
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
		public emailvariableService: EmailVariableService,
		private translate: TranslateService
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, emailvariableService)
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
