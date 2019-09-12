import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { [=IEntity] } from './[=IEntityFile]';
import { [=ClassName]Service } from './[=ModuleName].service';
import { Router, ActivatedRoute } from '@angular/router';
import {[=ClassName]NewComponent} from './[=ModuleName]-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';


<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
import { [=relationValue.eName]Service } from '../[=relationValue.eName?uncap_first?replace("[A-Z]", "-$0", 'r')?lower_case]/[=relationValue.eName?uncap_first?replace("[A-Z]", "-$0", 'r')?lower_case].service';
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
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: [=ClassName]Service,
		public errorService: ErrorService,
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
		public [=relationValue.eName?uncap_first]Service: [=relationValue.eName]Service,
		</#if>
		</#list>
		</#if>
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		<#if Relationship?has_content>
		this.setAssociation();
	    </#if>
		this.setColumns();
		this.primaryKeys = [ <#list PrimaryKeys as key,value>"[=key]", </#list> ]
		super.ngOnInit();
	}
  
  <#if Relationship?has_content> 
	setAssociation(){
  	
		this.associations = [
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
			{
				column: [
				      <#list relationValue.joinDetails as joinDetails>
                      <#if joinDetails.joinEntityName == relationValue.eName>
                      <#if joinDetails.joinColumn??>
                      {
					  	key: '[=joinDetails.joinColumn]',
					  	value: undefined,
					  	referencedkey: '[=joinDetails.referenceColumn]'
					  },
					  </#if>
                      </#if>
                      </#list>
					  
				],
				isParent: false,
				<#if DescriptiveField[relationValue.eName]??>
				descriptiveField: '[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]',
				referencedDescriptiveField: '[=DescriptiveField[relationValue.eName].fieldName]',
				</#if>
				service: this.[=relationValue.eName?uncap_first]Service,
				associatedObj: undefined,
				table: '[=relationValue.eName?lower_case]',
				type: '[=relationValue.relation]'
			},
		</#if>
		</#list>
		];
	}
  </#if>
  
  	setColumns(){
  		this.columns = [
		<#list Fields as key,value>
		<#-- to exclude the duplicate fields(join columns) -->
		<#assign isJoinColumn = false>
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
		<#list relationValue.joinDetails as joinDetails>
	    <#if joinDetails.joinEntityName == relationValue.eName>
	    <#if joinDetails.joinColumn??>
	    <#if joinDetails.joinColumn == key>
	    <#assign isJoinColumn = true>
	    </#if>
	    </#if>
		</#if>
		</#list>
		</#if>
		</#list>
		</#if>
		<#if isJoinColumn == false && (value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "string")>
			<#if AuthenticationType== "database" && ClassName == AuthenticationTable>  
    		<#if AuthenticationFields?? && AuthenticationFields.Password.fieldName != value.fieldName>
    		{
				column: '[=value.fieldName]',
				label: '[=value.fieldName]',
				<#if value.isPrimaryKey == true>
				sort: false,
				filter: false,
				<#else>
				sort: true,
				filter: true,
				</#if>
				<#if value.fieldType?lower_case == "string">
				type: listColumnType.String
				<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "short">
				type: listColumnType.Number
				<#elseif value.fieldType?lower_case == "date">
				type: listColumnType.Date
				<#elseif value.fieldType?lower_case == "boolean">
				type: listColumnType.Boolean
				</#if>
			},
    		</#if>
    		<#else>
    		{
				column: '[=value.fieldName]',
				label: '[=value.fieldName]',
				<#if value.isPrimaryKey == true>
				sort: false,
				filter: false,
				<#else>
				sort: true,
				filter: true,
				</#if>
				<#if value.fieldType?lower_case == "string">
				type: listColumnType.String
				<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "short">
				type: listColumnType.Number
				<#elseif value.fieldType?lower_case == "date">
				type: listColumnType.Date
				<#elseif value.fieldType?lower_case == "boolean">
				type: listColumnType.Boolean
				</#if>
			},
    	</#if>
			
		</#if>
		</#list>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
			<#if DescriptiveField[relationValue.eName]??>
			{
	  			column: '[=relationValue.eName]',
				label: '[=relationValue.eName]',
				sort: false,
				filter: false,
				type: listColumnType.String
	  		},
			</#if>
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
		this.selectedColumns = this.columns;
		this.displayedColumns = this.columns.map((obj) => { return obj.column });
  	}
  
	addNew() {
		super.addNew([=ClassName]NewComponent);
	}
  
}
