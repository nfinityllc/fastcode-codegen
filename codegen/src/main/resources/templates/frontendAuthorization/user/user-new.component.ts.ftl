import { Component, OnInit, Inject } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { RoleService } from '../role/role.service';
import { GlobalPermissionService } from '../core/global-permission.service';
import { UserService } from './user.service';
import { IUser } from './iuser';

@Component({
  selector: 'app-user-new',
  templateUrl: './user-new.component.html',
  styleUrls: ['./user-new.component.scss']
})
export class UserNewComponent extends BaseNewComponent<IUser> implements OnInit {
  
    title:string = "New User";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<UserNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: UserService,
			public errorService: ErrorService,
			public roleService: RoleService,
			public globalPermissionService: GlobalPermissionService,
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	  }
 
	ngOnInit() {
		this.entityName = "User";
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			accessFailedCount: [''],
			authenticationSource: [''],
			emailAddress: ['', Validators.required],
			emailConfirmationCode: [''],
			firstName: ['', Validators.required],
			isActive: [false],
			isEmailConfirmed: [false],
			isLockoutEnabled: [false],
			isPhoneNumberConfirmed: [''],
			lastLoginTime: [''],
			lastName: ['', Validators.required],
			lockoutEndDateUtc: [''],
			password: [''],
			confirmPassword: ['', Validators.required],
			passwordResetCode: [''],
			phoneNumber: [''],
			profilePictureId: [''],
			twoFactorEnabled: [false],
			userName: ['', Validators.required],
			roleId: [''],
			roleDescriptiveField : [{ value: '', disabled: true }],
		});
		this.checkPassedData();
    }
 		
	setAssociations(){
		this.associations = [
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: false,
				table: 'role',
				type: 'ManyToOne',
				service: this.roleService,
				descriptiveField: 'roleDescriptiveField',
				referencedDescriptiveField: 'name',
			},
		];
		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}
    
}
