import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { [=ClassName]Service } from './[=ModuleName].service';
import { [=IEntity] } from './[=IEntityFile]';

<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service'
</#if>
</#list>
</#if>

import {BaseDetailsComponent} from '../base/base-details.component';
import { Globals } from '../globals';

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
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		public [=relationValue.eName?lower_case]Service: [=relationValue.eName]Service
		</#if>
		</#list>
		</#if>
	) {
		super(formBuilder, router, route, dialog, global, dataService);
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
			[=value.fieldName]: ['', Validators.required],
	        <#elseif value.fieldType == "boolean">              
			[=value.fieldName]: [false, Validators.required],
	         <#elseif value.fieldType?lower_case == "string">                
			[=value.fieldName]: ['', Validators.required],
	        </#if> 
			</#list>
			<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
			[=relationValue.joinColumn]: ['', Validators.required],
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
				column: {
					key: '[=relationValue.joinColumn]',
					value: undefined
				},
				<#if relationValue.relation == "ManyToMany">
				<#list RelationInput as relationInput>
  			<#assign parent = relationInput>
  			<#if parent?keep_after("-") == relationValue.eName>
				isParent: true,
				<#else>
				isParent: false,
				</#if>
				</#list>
				<#elseif relationValue.relation == "OneToMany">
				isParent: true,
				<#else>
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
		    <#if fieldName == "id" || fieldType == "date" || fieldType == "string" || fieldType == "boolean">              
			[=value.fieldName]:item.[=value.fieldName],
			</#if>
		</#list>
		<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
			[=relationValue.joinColumn]: item.[=relationValue.joinColumn],
			</#if>
			</#list>
		</#if>
		});
	}
  
  
}
