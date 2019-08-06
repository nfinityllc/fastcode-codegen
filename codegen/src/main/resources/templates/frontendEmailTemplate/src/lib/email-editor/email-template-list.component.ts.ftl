import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

//import { IEmail as IEmailTemplate } from './iemail';
//import { EmailService as EmailTemplateService } from './email.service';
import { IEmailTemplate } from './iemail-template';
import { EmailTemplateService } from './email-template.service';

import { Router, ActivatedRoute } from '@angular/router';
//import {EmailNewComponent} from './email-new.component';
import {BaseListComponent,IListColumn, listColumnType,Globals,PickerDialogService } from 'fastCodeCore';
//import { BaseListComponent,IListColumn, listColumnType,Globals,PickerDialogService,IFCDialogConfig } from 'projects/fast-code-core/src/public_api';
//import { Globals } from '../globals';
//import { IListColumn, listColumnType } from '../common/ilistColumn';
//import { PickerDialogService } from '../common/components/picker/picker-dialog.service';
//import {,IFCDialogConfig} from '../picker/picker-dialog.service';
import { TranslateService } from '@ngx-translate/core';

@Component({
	selector: 'app-emailtemplate-list',
	templateUrl: './email-template-list.component.html',
	styleUrls: ['./email-template-list.component.scss']
  })
  export class EmailTemplateListComponent extends BaseListComponent<IEmailTemplate> implements OnInit {

	title:string = "Email Template";
  
	columns: IListColumn[] = [
		{
			column: 'templatename',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.TEMPLATE-NAME'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'subject',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.SUBJECT'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'category',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CATEGORY'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		/*{
			column: 'cc',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CC'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'contenthtml',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CONTENT-HTML'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'contentjson',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CONTENT-JSON'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'creationtime',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CREATION-TIME'),
			sort: false,
			filter: false,
			type: listColumnType.Date
		},
		{
			column: 'creatoruserid',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CREATOR-USER-ID'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},*/
		{
			column: 'lastModifierUserId',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.LAST-MODIFIER-USER-ID'),
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'lastModificationTime',
			label: this.translate.instant('EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.LAST-MODIFICATION-TIME'),
			sort: false,
			filter: false,
			type: listColumnType.Date
		},
		
  	{
			column: 'actions',
			label: this.translate.instant('EMAIL-GENERAL.ACTIONS.ACTIONS'),
			sort: false,
			filter: false,
			type: listColumnType.String
		}
	];
  
	selectedColumns  = this.columns;
	displayedColumns: string[] = this.columns.map((obj) => { return obj.column });

  
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public emailService: EmailTemplateService,
		private translate: TranslateService
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, emailService)
  }

  ngOnInit() {
	this.setAssociation();
	super.ngOnInit();
}
initializePageInfo() {
    this.hasMoreRecords = true;
    this.pageSize = 10;
    this.lastProcessedOffset = -1;
    this.currentPage = 0;
  }
setAssociation(){
  
	this.associations = [
	];
}
  
  
	addNew() {
	//	super.addNew(EmailNewComponent);
	
      this.router.navigate(['./emailtemplate'],{ relativeTo: this.route.parent });
      return;
    
    
   
   
	}
  
}
