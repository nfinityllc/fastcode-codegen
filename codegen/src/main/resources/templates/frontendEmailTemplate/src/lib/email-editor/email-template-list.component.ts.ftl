import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

//import { IEmail as IEmailTemplate } from './iemail';
//import { EmailService as EmailTemplateService } from './email.service';
import { IEmailTemplate } from './iemail-template';
import { EmailTemplateService } from './email-template.service';

import { Router, ActivatedRoute } from '@angular/router';
//import {EmailNewComponent} from './email-new.component';
//import {BaseListComponent,IListColumn, listColumnType,Globals,PickerDialogService } from 'fastCodeCore';
import { BaseListComponent, IListColumn, listColumnType, Globals, PickerDialogService, IFCDialogConfig, GlobalPermissionService, ErrorService } from 'projects/fast-code-core/src/public_api';
//import { Globals } from '../globals';
//import { IListColumn, listColumnType } from '../common/ilistColumn';
//import { PickerDialogService } from '../common/components/picker/picker-dialog.service';
//import {,IFCDialogConfig} from '../picker/picker-dialog.service';

@Component({
	selector: 'app-emailtemplate-list',
	templateUrl: './email-template-list.component.html',
	styleUrls: ['./email-template-list.component.scss']
})
export class EmailTemplateListComponent extends BaseListComponent<IEmailTemplate> implements OnInit {

	title: string = "Email Templates";
	entityName: string = 'Email';
	columns: IListColumn[] = [
		{
			column: 'templatename',
			label: 'Template Name',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'subject',
			label: 'subject',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'category',
			label: 'category',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		/*{
			column: 'cc',
			label: 'cc',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'contenthtml',
			label: 'contenthtml',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'contentjson',
			label: 'contentjson',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'creationtime',
			label: 'creationtime',
			sort: false,
			filter: false,
			type: listColumnType.Date
		},
		{
			column: 'creatoruserid',
			label: 'creatoruserid',
			sort: true,
			filter: true,
			type: listColumnType.String
		},*/
		{
			column: 'lastModifierUserId',
			label: 'Modified By',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
		{
			column: 'lastModificationTime',
			label: 'Modified Time',
			sort: false,
			filter: false,
			type: listColumnType.Date
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
		public emailService: EmailTemplateService,
		public globalPermissionService: GlobalPermissionService,
		public errorService: ErrorService
	) {
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, emailService, errorService)
		//this.globalPermissionService = localGlobalPermissionService;
	}

	ngOnInit() {
		this.setAssociation();
		this.primaryKeys = ["id"];
		super.ngOnInit();
	}
	initializePageInfo() {
		this.hasMoreRecords = true;
		this.pageSize = 10;
		this.lastProcessedOffset = -1;
		this.currentPage = 0;
	}
	setAssociation() {

		this.associations = [
		];
	}


	addNew() {
		//	super.addNew(EmailNewComponent);

		this.router.navigate(['./emailtemplate'], { relativeTo: this.route.parent });
		return;




	}

}
