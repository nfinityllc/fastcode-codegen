import { Component, OnInit, Inject } from '@angular/core';
import { [=ClassName]Service } from './[=ModuleName].service';
import { [=IEntity] } from './[=IEntityFile]';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service';
</#if>
</#list>
</#if>

@Component({
  selector: 'app-[=ModuleName]-new',
  templateUrl: './[=ModuleName]-new.component.html',
  styleUrls: ['./[=ModuleName]-new.component.scss']
})
export class [=ClassName]NewComponent extends BaseNewComponent<[=IEntity]> implements OnInit {
  
    title:string = "New [=ClassName]";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<[=ClassName]NewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: [=ClassName]Service,
			<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
			public [=relationValue.eName?lower_case]Service: [=relationValue.eName]Service,
			</#if>
			</#list>
			</#if>
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService);
	  }
 
    ngOnInit() {
      <#if Relationship?has_content>
			this.setAssociations();
			</#if>
			super.ngOnInit();
		  
			this.itemForm = this.formBuilder.group({
				<#list Fields as key,value>
				<#if value.fieldName?lower_case == "id">
				<#elseif value.fieldType == "Date">    
				<#if value.isNullable == false>          
				[=value.fieldName]: ['', Validators.required],
				<#else>
				[=value.fieldName]: [''],
				</#if>
				<#elseif value.fieldType == "boolean">  
				<#if value.isNullable == false>          
				[=value.fieldName]: [false, Validators.required],
				<#else>
				[=value.fieldName]: [false],
				</#if>            
				<#elseif value.fieldType?lower_case == "string">                
				<#if value.isNullable == false>          
				[=value.fieldName]: ['', Validators.required], 
				<#else>
				[=value.fieldName]: [''],
				</#if>
				<#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "int">
				<#if value.isNullable == false>   
				[=value.fieldName]: ['', Validators.required],       
				<#else>
				[=value.fieldName]: [''],
				</#if>
				</#if> 
				</#list>
				<#if Relationship?has_content>
				<#list Relationship as relationKey, relationValue>
				<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
				<#if relationValue.isJoinColumnOptional==false>          
				[=relationValue.joinColumn]: ['', Validators.required],
				<#else>
				[=relationValue.joinColumn]: [''],
				</#if>
				</#if>
				<#if relationValue.relation == "ManyToOne" && relationValue.entityDescriptionField?? >
				[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first] : [{ value: '', disabled: true }],
			  </#if>
				</#list>
				</#if>
				});
				this.checkPassedData();
    }
 		
	<#if Relationship?has_content> 
		setAssociations(){
	  	
			this.associations = [
			<#list Relationship as relationKey, relationValue>
				{
					column: {
						key: '[=relationValue.joinColumn]',
						value: undefined
					},
				<#if relationValue.relation == "ManyToMany">
				<#list RelationInput as relationInput>
	  			<#assign parent = relationInput>
	  			<#if relationKey == parent>
  				<#if parent?keep_after("-") == relationValue.eName>
						isParent: true,
				</#if>
          		</#if>
			<#if parent?keep_before("-") == relationValue.eName>
						isParent: false,
				</#if>
				</#list>
				<#elseif relationValue.relation == "OneToMany">
						isParent: true,
				<#elseif relationValue.relation == "ManyToOne">
						isParent: false,
				</#if>
						table: '[=relationValue.eName?lower_case]',
						type: '[=relationValue.relation]',
					<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
						service: this.[=relationValue.eName?lower_case]Service,
					</#if>
					<#if relationValue.relation == "ManyToOne" && relationValue.entityDescriptionField?? >
						descriptiveField: '[=relationValue.eName?uncap_first][=relationValue.entityDescriptionField.fieldName?cap_first]',
			  	</#if>
				},
			</#list>
			];
			this.toOne = this.associations.filter(association => {
				return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1) && !association.isParent);
			});
	
		}
	  </#if>
		
    // convenience getter for easy access to form fields
   
    
}
