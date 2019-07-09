import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { PermissionsService } from './permissions.service';
import { IPermissions } from './ipermissions';


import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-permissions-details',
  templateUrl: './permissions-details.component.html',
  styleUrls: ['./permissions-details.component.scss']
})
export class PermissionsDetailsComponent extends BaseDetailsComponent<IPermissions> implements OnInit {
  title:string='Permissions';
  parentUrl:string='permissions';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: PermissionsService,
	) {
		super(formBuilder, router, route, dialog, global, dataService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
	  
		this.itemForm = this.formBuilder.group({
			displayName: [''],
			id: [],
			name: ['', Validators.required],
	        
	     });
	    if (this.idParam) {
	      const id = +this.idParam;
	      this.getItem(id).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  
	setAssociations(){
  	
		this.associations = [
			{
				column: {
					key: 'permissionId',
					value: undefined
				},
				isParent: false,
				table: 'users',
				type: 'ManyToMany',
			},
			{
				column: {
					key: 'permissionId',
					value: undefined
				},
				isParent: false,
				table: 'roles',
				type: 'ManyToMany',
			},
		];
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany','OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1));
		});
	}

	onItemFetched(item:IPermissions) {
		this.item = item;
		this.itemForm.patchValue({
			displayName: item.displayName,
			id: item.id,
			name: item.name,
		});
	}
  
  
}
