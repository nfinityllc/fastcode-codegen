import { Component, OnInit, Inject } from '@angular/core';
import { [=ClassName]Service } from './[=ModuleName].service';
import { [=IEntity] } from './[=IEntityFile]';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
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
			public errorService: ErrorService,
			<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
			public [=relationValue.eName?lower_case]Service: [=relationValue.eName]Service,
			</#if>
			</#list>
			</#if>
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	  }
 
    ngOnInit() {
      <#if Relationship?has_content>
			this.setAssociations();
			</#if>
			super.ngOnInit();
		  
			this.itemForm = this.formBuilder.group({
				<#list Fields as key,value>
				<#if value.fieldType?lower_case == "string" || value.fieldType == "Date" || value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "double" ||  value.fieldType?lower_case == "short">    
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
				
				</#if> 
				</#list>
				<#if Relationship?has_content>
				<#list Relationship as relationKey, relationValue>
				<#if relationValue.relation == "ManyToOne">
				<#list relationValue.joinDetails as joinDetails>
                <#if joinDetails.joinEntityName == relationValue.eName>
                <#if joinDetails.joinColumn??>
                <#if !Fields[joinDetails.joinColumn]??>
				<#if joinDetails.isJoinColumnOptional==false>          
				[=joinDetails.joinColumn]: ['', Validators.required],
				<#else>
				[=joinDetails.joinColumn]: [''],
				</#if>
                </#if>
                </#if>
                </#if>
                </#list>
				</#if>
                <#if relationValue.relation == "OneToOne">
                <#list relationValue.joinDetails as joinDetails>
                <#if joinDetails.joinEntityName == relationValue.eName>
                <#if joinDetails.joinColumn??>
				<#if joinDetails.isJoinColumnOptional==false>          
				[=joinDetails.joinColumn]: ['', Validators.required],
				<#else>
				[=joinDetails.joinColumn]: [''],
				</#if>
                </#if>
                </#if>
                </#list>
				</#if>
				<#if relationValue.relation == "ManyToOne">
				<#list DescriptiveField as dEntityName, dField>
				<#if dEntityName == relationValue.eName>
				[=relationValue.eName?uncap_first][=dField.fieldName?cap_first] : [{ value: '', disabled: true }],
				</#if>
                </#list>
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
				
				<#if relationValue.relation == "OneToOne">
			    <#if relationValue.isParent!false>
				isParent: true,
				<#else>
				isParent: false,
				</#if>
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
                <#if relationValue.relation == "ManyToOne">
				
				<#if DescriptiveField[relationValue.eName]??>
				descriptiveField: '[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]',
				</#if>
                
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
