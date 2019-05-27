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

<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToMany">
<#list RelationInput as relationInput>
<#assign parent = relationInput>
<#if parent?keep_before("-") == relationValue.eName>
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service';
</#if>
</#list>
<#elseif relationValue.relation == "ManyToOne">
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service';
</#if>
</#list>
</#if>

@Component({
  selector: 'app-[=ModuleName]-list',
  templateUrl: './[=ModuleName]-list.component.html',
  styleUrls: ['./[=ModuleName]-list.component.scss']
})
export class [=ClassName]ListComponent extends BaseListComponent<[=IEntity]> implements OnInit {

	title:string = "[=ClassName]";
  
	columns: IListColumn[] = [
		{
			column: 'id',
			label: 'id',
			sort: true,
			filter: false,
			type: listColumnType.Number
		},
	<#list Fields as key,value>
	<#if value.fieldName?lower_case == "id">  
	<#elseif value.fieldType?lower_case == "string">
		{
			column: '[=value.fieldName]',
			label: '[=value.fieldName]',
			sort: true,
			filter: true,
			type: listColumnType.String
		},
	<#elseif value.fieldType?lower_case == "int" || value.fieldType?lower_case == "long">
		{
			column: '[=value.fieldName]',
			label: '[=value.fieldName]',
			sort: true,
			filter: true,
			type: listColumnType.Number
		},
	<#elseif value.fieldType?lower_case == "date">
		{
			column: '[=value.fieldName]',
			label: '[=value.fieldName]',
			sort: true,
			filter: true,
			type: listColumnType.Date
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
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToMany">
		<#list RelationInput as relationInput>
		<#assign parent = relationInput>
		<#if parent?keep_before("-") == relationValue.eName>
		public [=relationValue.eName?lower_case]Service: [=relationValue.eName]Service,
		</#if>
		</#list>
		<#elseif relationValue.relation == "ManyToOne">
		public [=relationValue.eName?lower_case]Service: [=relationValue.eName]Service,
		</#if>
		</#list>
		</#if>
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
					key: '[=relationValue.joinColumn]',
					</#if>
					value: undefined
				},
				<#if relationValue.relation == "ManyToMany">
				<#list RelationInput as relationInput>
				<#assign parent = relationInput>
				<#if parent?keep_after("-") == relationValue.eName>
				isParent: true,
				<#else>
				isParent: false,
				descriptiveField: '[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]',
				referencedDescriptiveField: '[=relationValue.entityDescriptionField.fieldName]',
				service: this.[=relationValue.eName?lower_case]Service,
				associatedObj: undefined,
				</#if>
				</#list>
				<#else>
				isParent: false,
				descriptiveField: '[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]',
				referencedDescriptiveField: '[=relationValue.entityDescriptionField.fieldName]',
				service: this.[=relationValue.eName?lower_case]Service,
				associatedObj: undefined,
				</#if>
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
