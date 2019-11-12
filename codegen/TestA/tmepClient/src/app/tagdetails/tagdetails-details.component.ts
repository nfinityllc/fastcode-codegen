import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { TagdetailsService } from './tagdetails.service';
import { ITagdetails } from './itagdetails';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { TagService } from '../tag/tag.service';

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-tagdetails-details',
  templateUrl: './tagdetails-details.component.html',
  styleUrls: ['./tagdetails-details.component.scss']
})
export class TagdetailsDetailsComponent extends BaseDetailsComponent<ITagdetails> implements OnInit {
	title:string='Tagdetails';
	parentUrl:string='tagdetails';
	//roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: TagdetailsService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public tagService: TagService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.entityName = 'Tagdetails';
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			country: [''],
			tid: [''],
			title: [''],
			tagDescriptiveField : [{ value: '', disabled: true }],
			
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
						key: 'tid',
						value: undefined,
						referencedkey: 'tagid'
					},
					{
						key: 'title',
						value: undefined,
						referencedkey: 'title'
					},
				],
				isParent: false,
				table: 'tag',
				type: 'OneToOne',
				service: this.tagService,
				descriptiveField: 'tagDescriptiveField',
			    referencedDescriptiveField: 'description',
			},
		];
		
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:ITagdetails) {
		this.item = item;
		this.itemForm.patchValue({
			country: item.country,
			tid: item.tid,
			title: item.title,
			tagDescriptiveField: item.tagDescriptiveField,
		});
	}
}
