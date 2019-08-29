import { Component, OnInit, Inject } from '@angular/core';
import { PermissionService } from './permission.service';
import { IPermission } from './ipermission';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
  selector: 'app-permission-new',
  templateUrl: './permission-new.component.html',
  styleUrls: ['./permission-new.component.scss']
})
export class PermissionNewComponent extends BaseNewComponent<IPermission> implements OnInit {
  
    title:string = "New Permission";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<PermissionNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: PermissionService,
			public errorService: ErrorService,
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	  }
 
	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			displayName: [''],
			name: ['', Validators.required],
		});
		this.checkPassedData();
    }
 		
		setAssociations(){
	  	
			this.associations = [
			];
			this.toOne = this.associations.filter(association => {
				return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1) && !association.isParent);
			});
	
		}
    
}
