import { Component, OnInit } from '@angular/core';
import { [=ClassName]Service } from './[=ModuleName].service';
import { [=IEntity] } from './[=IEntityFile]';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals } from '../globals';
import { MatDialogRef } from '@angular/material/dialog';
import {BaseNewComponent} from '../base/base-new.component';
@Component({
  selector: 'app-[=ModuleName]-new',
  templateUrl: './[=ModuleName]-new.component.html',
  styleUrls: ['./[=ModuleName]-new.component.scss']
})
export class [=ClassName]NewComponent extends BaseNewComponent<[=IEntity]> implements OnInit {
  
    title:string = "New [=ClassName]";
    constructor(public formBuilder: FormBuilder, public router: Router,
        public global:Globals, public dataService: [=ClassName]Service,
       public dialogRef: MatDialogRef<[=ClassName]NewComponent>
        ) { 
            super(formBuilder,router,global,dataService,dialogRef);
        }
 
    ngOnInit() {
        super.ngOnInit();
        this.itemForm = this.formBuilder.group({
        <#list Fields as key,value>
            <#if value.fieldName?lower_case == "id">    
            <#elseif value.fieldType == "Date">              
                [=value.fieldName]: ['', Validators.required],
            <#elseif value.fieldName?lower_case == "boolean">              
                [=value.fieldName]: [false, Validators.required],
            <#elseif value.fieldType?lower_case == "string">              
                [=value.fieldName]: ['', Validators.required],
            </#if> 
      </#list>    
         
        });
    }
 
    // convenience getter for easy access to form fields
   
    
}
