import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { RoleService } from './role.service';
import { IRole } from './irole';
import { PickerDialogService, ErrorService } from 'fastCodeCore';


import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-role-details',
  templateUrl: './role-details.component.html',
  styleUrls: ['./role-details.component.scss']
})
export class RoleDetailsComponent extends BaseDetailsComponent<IRole> implements OnInit {
  title:string='Role';
  parentUrl:string='role';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: RoleService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			displayName: [''],
			id: [{value: '', disabled: true}, Validators.required],
			name: ['', Validators.required],
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
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: true,
				table: 'rolepermission',
				type: 'OneToMany',
			},
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'userid'
					},
				],
				isParent: true,
				table: '[=authenticationTable]',
				type: 'OneToMany',
			},
		];
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany','OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1));
		});
	}

	onItemFetched(item:IRole) {
		this.item = item;
		this.itemForm.patchValue({
			displayName: item.displayName,
			id: item.id,
			name: item.name,
		});
	}
}
