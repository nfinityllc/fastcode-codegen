import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { I[=AuthenticationTable]permission } from './i[=moduleName]permission';
import { [=AuthenticationTable]permissionService } from './[=moduleName]permission.service';
import { Router, ActivatedRoute } from '@angular/router';
import { [=AuthenticationTable]permissionNewComponent} from './[=moduleName]permission-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';


import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

@Component({
  selector: 'app-[=moduleName]permission-list',
  templateUrl: './[=moduleName]permission-list.component.html',
  styleUrls: ['./[=moduleName]permission-list.component.scss']
})
export class [=AuthenticationTable]permissionListComponent extends BaseListComponent<I[=AuthenticationTable]permission> implements OnInit {

	title:string = "[=AuthenticationTable]permission";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: [=AuthenticationTable]permissionService,
		public errorService: ErrorService,
		public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
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
					<#if AuthenticationType=="database" && !UserInput??>
					{
						key: 'userid',
						value: undefined,
						referencedkey: 'id'
					},
					<#elseif AuthenticationType=="database" && UserInput??>
					<#if PrimaryKeys??>
					<#list PrimaryKeys as key,value>
					<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
					{
						key: '[=AuthenticationTable?uncap_first + value.fieldName?cap_first]',
						value: undefined,
						referencedkey: '[=value.fieldName]'
					},
					</#if>
					</#list>
					</#if>
					</#if>				  
				],
				isParent: false,
				<#if AuthenticationType=="database" && UserInput??>
				<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
				<#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
				descriptiveField: '[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first]',
				referencedDescriptiveField: '[=DescriptiveField[AuthenticationTable].fieldName]',
				</#if>
                <#else>
                <#if AuthenticationFields??>
  				<#list AuthenticationFields as authKey,authValue>
  				<#if authKey== "User Name">
  				<#if !PrimaryKeys[authValue.fieldName]??>
  				descriptiveField: '[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]',
				referencedDescriptiveField: '[=authValue.fieldName]',
				</#if>
    			</#if>
    			</#list>
    			</#if>
				</#if>
				<#elseif AuthenticationType=="database" && !UserInput??>
				descriptiveField: '[=AuthenticationTable?uncap_first]Username',
				referencedDescriptiveField: 'username',
				</#if>
				service: this.[=AuthenticationTable?uncap_first]Service,
				associatedObj: undefined,
				table: '[=AuthenticationTable?uncap_first]',
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
	  			column: '[=AuthenticationTable]',
				label: '[=AuthenticationTable]',
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
		super.addNew([=AuthenticationTable]permissionNewComponent);
	}
  
}
