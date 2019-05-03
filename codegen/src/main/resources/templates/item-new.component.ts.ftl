import { Component, OnInit } from '@angular/core';
import { [=ClassName]Service } from './[=ModuleName].service';
import { [=IEntity] } from './[=IEntityFile]';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';
import { BaseNewComponent } from '../base/base-new.component';

<#if Relationship?has_content>
<#list Relationship as relationKey, relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import { [=relationValue.eName]Service } from '../[=relationValue.eName?lower_case]/[=relationValue.eName?lower_case].service'
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
			super(formBuilder, router, route, dialog, dialogRef, global, dataService);
	  }
 
    ngOnInit() {
      <#if Relationship?has_content>
			this.setAssociations();
			</#if>
			super.ngOnInit();
		  
			this.itemForm = this.formBuilder.group({
				<#list Fields as key,value>
		        <#if value.fieldType == "Date">              
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
					service: this.[=relationValue.eName?lower_case]Service
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
