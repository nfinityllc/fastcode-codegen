import { Component, OnInit, Inject } from '@angular/core';
import { EmailVariableService } from './email-variable.service';
import {  IEmailVariable } from './iemail-variable';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
//import { Globals } from '../globals';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';
//import { BaseNewComponent } from '../base/base-new.component';
//import { BaseNewComponent,Globals,PickerDialogService } from 'fastCodeCore'; // from 'fastCodeCore';
import { BaseNewComponent,Globals,PickerDialogService, GlobalPermissionService, ErrorService } from 'projects/fast-code-core/src/public_api';// 'fastCodeCore';
@Component({
  selector: 'app-email-variable-new',
  templateUrl: './email-variable-new.component.html',
  styleUrls: ['./email-variable-new.component.scss']
})
export class EmailVariableNewComponent extends BaseNewComponent<IEmailVariable> implements OnInit {
  
	title:string = "New Email Variable";
	entityName:string =  'EmailVariable';
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<EmailVariableNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService:PickerDialogService,
			public dataService: EmailVariableService,
			public globalPermissionService: GlobalPermissionService,
			public errorService: ErrorService
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global,pickerDialogService, dataService, errorService);
	  }
 
    ngOnInit() {
			this.itemForm = this.formBuilder.group({
				propertyName: ['', Validators.required],
         propertyType: ['', Validators.required],
         defaultValue: [''],
				});
			super.ngOnInit();
		  
		
				this.checkPassedData();
    }
 		
		
    // convenience getter for easy access to form fields
   
    
}
