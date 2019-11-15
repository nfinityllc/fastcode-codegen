import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { TagService } from './tag.service';
import { ITag } from './itag';
import { PickerDialogService, ErrorService } from 'fastCodeCore';


import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-tag-details',
  templateUrl: './tag-details.component.html',
  styleUrls: ['./tag-details.component.scss']
})
export class TagDetailsComponent extends BaseDetailsComponent<ITag> implements OnInit {
	title:string='Tag';
	parentUrl:string='tag';
	//roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: TagService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.entityName = 'Tag';
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			description: [''],
			tagid: [''],
			title: [''],
			
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
				isParent: true,
				table: 'tagdetails',
				type: 'OneToOne',
			    associatedPrimaryKeys: [ 'tid',  'title', ]
			},
		];
		
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:ITag) {
		this.item = item;
		this.itemForm.patchValue({
			description: item.description,
			tagid: item.tagid,
			title: item.title,
		});
	}
}
