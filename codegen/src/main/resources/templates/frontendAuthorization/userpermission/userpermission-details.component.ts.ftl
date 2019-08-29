import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { UserpermissionService } from './userpermission.service';
import { IUserpermission } from './iuserpermission';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { UserService } from '../user/user.service'
import { PermissionService } from '../permission/permission.service'

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-userpermission-details',
  templateUrl: './userpermission-details.component.html',
  styleUrls: ['./userpermission-details.component.scss']
})
export class UserpermissionDetailsComponent extends BaseDetailsComponent<IUserpermission> implements OnInit {
  title:string='Userpermission';
  parentUrl:string='userpermission';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: UserpermissionService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public userService: UserService,
		public permissionService: PermissionService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			permissionId: ['', Validators.required],
			userId: ['', Validators.required],
			userUserName : [{ value: '', disabled: true }],
			permissionName : [{ value: '', disabled: true }],
	    });
	    if (this.idParam) {
			this.getItem(this.idParam).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  
	setAssociations(){
  	
		this.associations = [
			{
				column: [
					{
						key: 'userId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: false,
				table: 'user',
				type: 'ManyToOne',
				service: this.userService,
				descriptiveField: 'userUserName',
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
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany','OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1));
		});
	}

	onItemFetched(item:IUserpermission) {
		this.item = item;
		this.itemForm.patchValue({
			permissionId: item.permissionId,
			userId: item.userId,
			userUserName: item.userUserName,
			permissionName: item.permissionName,
		});
	}
}
