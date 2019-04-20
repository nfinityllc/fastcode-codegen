import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { [=IEntity] } from './[=IEntityFile]';
import { [=ClassName]Service } from './[=ModuleName].service';
import { Router, ActivatedRoute } from '@angular/router';
import {[=ClassName]NewComponent} from './[=ModuleName]-new.component';
import {BaseListComponent} from '../base/base-list.component';
import { Globals } from '../globals';
import { IListColumn, listColumnType } from '../common/ilistColumn';
import { PickerDialogService } from '../common/components/picker/picker-dialog.service';
<#if Relationship?has_content>
import { IAssociationEntry } from '../core/iassociationentry';
</#if>

@Component({
  selector: 'app-[=ModuleName]-list',
  templateUrl: './[=ModuleName]-list.component.html',
  styleUrls: ['./[=ModuleName]-list.component.scss']
})
export class [=ClassName]ListComponent extends BaseListComponent<[=IEntity]> implements OnInit {

	title:string = "[=ClassName]s";
  
	columns: IListColumn[] = [
	<#list Fields as key,value>
	<#if value.fieldType?lower_case == "string">
		{
			column: '[=value.fieldName]',
			label: '[=value.fieldName]',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
  </#if> 
  </#list>
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
		public [=InstanceName]Service: [=ClassName]Service,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, [=InstanceName]Service)
  }

	ngOnInit() {
		<#if Relationship?has_content>
		this.setAssociation();
	    </#if>
		super.ngOnInit();
	}
  
  <#if Relationship?has_content> 
	setAssociation(){
  	
		this.associations = [
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "ManyToMany">
			{
				column: {
		<#if relationValue.relation == "ManyToMany">
					key: '[=relationValue.inverseJoinColumn]',
	    <#else>
					key: '[=relationValue.fName]',
		</#if>
					value: undefined
				},
				table: '[=relationValue.eName?lower_case]',
				type: '[=relationValue.relation]'
			},
		</#if>
		</#list>
		];
	}
  </#if>
  
	addNew() {
		super.addNew([=ClassName]NewComponent);
	}
  
}
