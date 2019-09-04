import { Component, OnInit, Inject } from '@angular/core';
import { [=authenticationTable]permissionService } from './[=moduleName]permission.service';
import { I[=authenticationTable]permission } from './i[=moduleName]permission';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { [=authenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

@Component({
  selector: 'app-[=moduleName]permission-new',
  templateUrl: './[=moduleName]permission-new.component.html',
  styleUrls: ['./[=moduleName]permission-new.component.scss']
})
export class [=authenticationTable]permissionNewComponent extends BaseNewComponent<I[=authenticationTable]permission> implements OnInit {
  
    title:string = "New [=authenticationTable]permission";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<[=authenticationTable]permissionNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: [=authenticationTable]permissionService,
			public errorService: ErrorService,
			public [=authenticationTable?uncap_first]Service: [=authenticationTable]Service,
			public permissionService: PermissionService,
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	  }
 
	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			permissionId: ['', Validators.required],
			userid: ['', Validators.required],
			[=authenticationTable?uncap_first]Username : [{ value: '', disabled: true }],
			permissionName : [{ value: '', disabled: true }],
		});
		this.checkPassedData();
    }
 		
	setAssociations(){
  	
		this.associations = [
			{
				column: [
					{
						key: 'userid',
						value: undefined,
						referencedkey: 'userid'
					},
				],
				isParent: false,
				table: '[=authenticationTable?uncap_first]',
				type: 'ManyToOne',
				service: this.[=authenticationTable?uncap_first]Service,
				descriptiveField: '[=authenticationTable?uncap_first]Username',
			},
			{
				column: [
					{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: false,
				table: 'permission',
				type: 'ManyToOne',
				service: this.permissionService,
				descriptiveField: 'permissionName',
			},
		];
		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}
}
