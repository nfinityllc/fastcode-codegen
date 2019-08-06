import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { EmailVariableService } from './email-variable.service';
import {  IEmailVariable } from './iemail-variable';
import { PickerDialogService } from 'fastCodeCore';

//import {BaseDetailsComponent} from '../base/base-details.component';
//import { Globals } from '../globals';
import { BaseDetailsComponent,Globals } from 'fastCodeCore';// from 'projects/fast-code-core/src/public_api';
@Component({
  selector: 'app-role-detail',
  templateUrl: './email-variable-detail.component.html',
  styleUrls: ['./email-variable-detail.component.scss']
})
export class EmailVariableDetailComponent extends BaseDetailsComponent<IEmailVariable> implements OnInit {
  title:string='Email Variable';
  parentUrl:string='./emailvariables';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: EmailVariableService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService);
		var u = this.route.parent.toString();
  }

	ngOnInit() {
		super.ngOnInit();
	  
		this.itemForm = this.formBuilder.group({
			id:[''],
			propertyName: ['', Validators.required],
			propertyType: ['', Validators.required],
			defaultValue: ['']   
	        
	     });
	    if (this.idParam) {
	      const id = +this.idParam;
	      this.getItem(id).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  

	onItemFetched(item:IEmailVariable) {
		this.item = item;
		this.itemForm.patchValue({
		
			defaultValue:item.defaultValue,
			id:item.id,
		
			propertyName:item.propertyName,
			propertyType:item.propertyType,
		});
	}
  
  
}
