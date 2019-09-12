import { Component, OnInit, Inject } from '@angular/core';
import { [=AuthenticationTable]permissionService } from './[=moduleName]permission.service';
import { I[=AuthenticationTable]permission } from './i[=moduleName]permission';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

@Component({
  selector: 'app-[=moduleName]permission-new',
  templateUrl: './[=moduleName]permission-new.component.html',
  styleUrls: ['./[=moduleName]permission-new.component.scss']
})
export class [=AuthenticationTable]permissionNewComponent extends BaseNewComponent<I[=AuthenticationTable]permission> implements OnInit {
  
    title:string = "New [=AuthenticationTable]permission";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<[=AuthenticationTable]permissionNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: [=AuthenticationTable]permissionService,
			public errorService: ErrorService,
			public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
			public permissionService: PermissionService,
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
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
			
			<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
			<#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
			[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first] : [{ value: '', disabled: true }],
			</#if>
            <#else>
			<#if AuthenticationFields??>
  			<#list AuthenticationFields as authKey,authValue>
  			<#if authKey== "User Name">
  			<#if !PrimaryKeys[authValue.fieldName]??>
  			[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]: [{ value: '', disabled: true }],
  			</#if>
    		</#if>
    		</#list>
    		</#if>
			</#if>
			
			</#if>
		});
		this.checkPassedData();
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
				<#if AuthenticationType=="database" && UserInput??>
				<#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
				<#if DescriptiveField[AuthenticationTable].isPrimaryKey == false>
				descriptiveField: '[=AuthenticationTable?uncap_first + DescriptiveField[AuthenticationTable].fieldName?cap_first]',
				</#if>
                <#else>
				descriptiveField: '[=AuthenticationTable?uncap_first]Username',
				</#if>
				<#elseif AuthenticationType=="database" && !UserInput??>
				<#if AuthenticationFields??>
  				<#list AuthenticationFields as authKey,authValue>
  				<#if authKey== "User Name">
  				<#if !PrimaryKeys[authValue.fieldName]??>
  				descriptiveField: '[=AuthenticationTable?uncap_first][=authValue.fieldName?cap_first]',
				</#if>
    			</#if>
    			</#list>
    			</#if>
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
		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}
}
