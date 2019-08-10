import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { [=ClassName]Service } from './[=ModuleName].service';
import { [=IEntity] } from './[=IEntityFile]';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service'
</#if>
</#list>
</#if>

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-[=ModuleName]-details',
  templateUrl: './[=ModuleName]-details.component.html',
  styleUrls: ['./[=ModuleName]-details.component.scss']
})
export class [=ClassName]DetailsComponent extends BaseDetailsComponent<[=IEntity]> implements OnInit {
  title:string='[=ClassName]';
  parentUrl:string='[=ApiPath]';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: [=ClassName]Service,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		public [=relationValue.eName?lower_case]Service: [=relationValue.eName]Service,
		</#if>
		</#list>
		</#if>
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
  		<#if Relationship?has_content>
		this.setAssociations();
		</#if>
		super.ngOnInit();
	  
		this.itemForm = this.formBuilder.group({
			<#list Fields as key,value>
	        <#if value.fieldName?lower_case == "id">              
			[=value.fieldName]: [],
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
			<#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "short" ||  value.fieldType?lower_case == "double">
			<#if value.isNullable == false>          
			[=value.fieldName]: ['', Validators.required],
			<#else>
			[=value.fieldName]: [''],
			</#if>
	        </#if> 
			</#list>
			<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne">
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
			</#list>
			</#if>
	        
	     });
	    if (this.idParam) {
	      const id = +this.idParam;
	      this.getItem(id).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
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
	
				<#if relationValue.relation == "OneToMany">
				isParent: true,
				<#elseif relationValue.relation == "ManyToOne">
				isParent: false,
				<#elseif relationValue.relation == "OneToOne">
				<#if relationValue.isParent!false>
				isParent: true,
				<#else>
				isParent: false,
				</#if>
				</#if>
				table: '[=relationValue.eName?lower_case]',
				type: '[=relationValue.relation]',
				<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
				service: this.[=relationValue.eName?lower_case]Service,
				</#if>
				<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
				<#if DescriptiveField[relationValue.eName]??>
				descriptiveField: '[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first]',
			    </#if>
                </#if>
			},
		</#list>
		];
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany','OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1));
		});
	}
  </#if>

	onItemFetched(item:[=IEntity]) {
		this.item = item;
		this.itemForm.patchValue({
		 <#list Fields as key,value>
		 	<#assign fieldType = value.fieldType?lower_case fieldName = value.fieldName?lower_case>
		    <#if fieldName == "id" || fieldType == "string" || fieldType == "boolean" || fieldType == "int" || fieldType == "long">              
			[=value.fieldName]: item.[=value.fieldName],
			<#elseif fieldType == "date">
			[=value.fieldName]: item.[=value.fieldName]? new Date(item.[=value.fieldName]): null,
		    </#if>
		</#list>
		<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne">
			<#list relationValue.joinDetails as joinDetails>
            <#if joinDetails.joinEntityName == relationValue.eName>
            <#if joinDetails.joinColumn??>
			[=joinDetails.joinColumn]: item.[=joinDetails.joinColumn],
			</#if>
			</#if>
			</#list>
			</#if>
            <#if relationValue.relation == "OneToOne">
            <#list relationValue.joinDetails as joinDetails>
            <#if joinDetails.joinEntityName == relationValue.eName>
            <#if joinDetails.joinColumn??>
			[=joinDetails.joinColumn]: item.[=joinDetails.joinColumn],
			</#if>
			</#if>
			</#list>
			</#if>
			</#list>
		</#if>
		});
	}
  
  
}
