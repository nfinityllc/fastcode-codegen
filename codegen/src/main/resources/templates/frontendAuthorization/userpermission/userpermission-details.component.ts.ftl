import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { [=authenticationTable]permissionService } from './[=moduleName]permission.service';
import { I[=authenticationTable]permission } from './i[=moduleName]permission';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { [=authenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { PermissionService } from '../permission/permission.service';

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-[=moduleName]permission-details',
  templateUrl: './[=moduleName]permission-details.component.html',
  styleUrls: ['./[=moduleName]permission-details.component.scss']
})
export class [=authenticationTable]permissionDetailsComponent extends BaseDetailsComponent<I[=authenticationTable]permission> implements OnInit {
  title:string='[=authenticationTable]permission';
  parentUrl:string='[=authenticationTable]permission';
  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: [=authenticationTable]permissionService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public [=authenticationTable?uncap_first]Service: [=authenticationTable]Service,
		public permissionService: PermissionService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
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
	    if (this.idParam) {
			this.getItem(this.idParam).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
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
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany','OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1));
		});
	}

	onItemFetched(item:I[=authenticationTable]permission) {
		this.item = item;
		this.itemForm.patchValue({
			permissionId: item.permissionId,
			userid: item.userid,
			[=authenticationTable?uncap_first]Username: item.[=authenticationTable?uncap_first]Username,
			permissionName: item.permissionName,
		});
	}
}
