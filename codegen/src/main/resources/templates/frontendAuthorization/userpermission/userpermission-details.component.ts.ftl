import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { [=AuthenticationTable]permissionService } from './[=moduleName]permission.service';
import { I[=AuthenticationTable]permission } from './i[=moduleName]permission';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-[=moduleName]permission-details',
  templateUrl: './[=moduleName]permission-details.component.html',
  styleUrls: ['./[=moduleName]permission-details.component.scss']
})
export class [=AuthenticationTable]permissionDetailsComponent extends BaseDetailsComponent<I[=AuthenticationTable]permission> implements OnInit {
  title:string='[=AuthenticationTable]permission';
  parentUrl:string='[=AuthenticationTable]permission';
  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: [=AuthenticationTable]permissionService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
		public permissionService: PermissionService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			permissionId: ['', Validators.required],
			permissionName : [{ value: '', disabled: true }],
			<#if AuthenticationType=="database" && !UserInput??>
			userid: ['', Validators.required],
			[=AuthenticationTable?uncap_first]Username : [{ value: '', disabled: true }],
			<#elseif AuthenticationType=="database" && UserInput??>
			<#if PrimaryKeys??>
			<#list PrimaryKeys as key,value>
			<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
			[=value.fieldName] : ['', Validators.required],
			</#if> 
			</#list>
			</#if>
			</#if>
			<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
			[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first] : [{ value: '', disabled: true }],
			<#else>
			[=AuthenticationTable?uncap_first]Username : [{ value: '', disabled: true }],
			</#if>
	    });
	    if (this.idParam) {
			this.getItem(this.idParam).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  
	setAssociations(){
  	
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
						key: '[=value.fieldName]',
						value: undefined,
						referencedkey: '[=value.fieldName]'
					},
					</#if> 
					</#list>
					</#if>
					</#if>
				],
				isParent: false,
				table: '[=AuthenticationTable?uncap_first]',
				type: 'ManyToOne',
				service: this.[=AuthenticationTable?uncap_first]Service,
				<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
				descriptiveField: '[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first]',
				<#else>
				descriptiveField: '[=AuthenticationTable?uncap_first]Username',
				</#if>
				
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
				table: 'permission',
				type: 'ManyToOne',
				service: this.permissionService,
				descriptiveField: 'permissionName',
			},
		];
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:I[=AuthenticationTable]permission) {
		this.item = item;
		this.itemForm.patchValue({
			permissionId: item.permissionId,
			<#if AuthenticationType=="database" && !UserInput??>
			userid: item.userid,
			<#elseif AuthenticationType=="database" && UserInput??>
			<#if PrimaryKeys??>
			<#list PrimaryKeys as key,value>
			<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
			[=value.fieldName] : item.[=value.fieldName],
			</#if> 
			</#list>
			</#if>
			</#if>
			<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
			[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first] : item.[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first],
			<#else>
			[=AuthenticationTable?uncap_first]Username: item.[=AuthenticationTable?uncap_first]Username,
			</#if>
			permissionName: item.permissionName,
		});
	}
}
