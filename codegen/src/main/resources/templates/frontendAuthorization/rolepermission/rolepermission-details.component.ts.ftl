import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { RolepermissionService } from './rolepermission.service';
import { IRolepermission } from './irolepermission';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { PermissionService } from '../permission/permission.service'
import { RoleService } from '../role/role.service'

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-rolepermission-details',
  templateUrl: './rolepermission-details.component.html',
  styleUrls: ['./rolepermission-details.component.scss']
})
export class RolepermissionDetailsComponent extends BaseDetailsComponent<IRolepermission> implements OnInit {
  title:string='Rolepermission';
  parentUrl:string='rolepermission';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: RolepermissionService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public permissionService: PermissionService,
		public roleService: RoleService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			permissionId: ['', Validators.required],
			roleId: ['', Validators.required],
			permissionName : [{ value: '', disabled: true }],
			roleName : [{ value: '', disabled: true }],
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
				descriptiveField: 'roleName',
			},
		];
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:IRolepermission) {
		this.item = item;
		this.itemForm.patchValue({
			permissionId: item.permissionId,
			roleId: item.roleId,
			permissionName: item.permissionName,
			roleName: item.roleName,
		});
	}
}
