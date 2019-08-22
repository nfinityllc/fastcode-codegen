import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { RolesService } from './roles.service';
import { IRoles } from './iroles';


import { BaseDetailsComponent, Globals, PickerDialogService, ErrorService } from 'fastCodeCore';

@Component({
	selector: 'app-roles-details',
	templateUrl: './roles-details.component.html',
	styleUrls: ['./roles-details.component.scss']
})
export class RolesDetailsComponent extends BaseDetailsComponent<IRoles> implements OnInit {
	title: string = 'Roles';
	parentUrl: string = 'roles';
	//roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: RolesService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
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
			this.getItem(id).subscribe(x => this.onItemFetched(x), error => this.errorMessage = <any>error);
		}
	}

	setAssociations() {

		this.associations = [
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'

					}
				],
				isParent: true,
				table: 'users',
				type: 'OneToMany',
			},
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'

					}
				],
				isParent: true,
				table: 'permissions',
				type: 'ManyToMany',
			},
		];
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany', 'OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne', 'OneToOne'].indexOf(association.type) > - 1));
		});
	}

	onItemFetched(item: IRoles) {
		this.item = item;
		this.itemForm.patchValue({
			displayName: item.displayName,
			id: item.id,
			name: item.name,
		});
	}


}
