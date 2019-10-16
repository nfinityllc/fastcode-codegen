import { Component, OnInit, Inject } from '@angular/core';
import { RoleService } from './role.service';
import { IRole } from './irole';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
  selector: 'app-role-new',
  templateUrl: './role-new.component.html',
  styleUrls: ['./role-new.component.scss']
})
export class RoleNewComponent extends BaseNewComponent<IRole> implements OnInit {
  
    title:string = "New Role";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<RoleNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: RoleService,
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
			this.parentAssociations = this.associations.filter(association => {
				return (!association.isParent);
			});
	
		}
    
}
