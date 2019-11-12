import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { PostdetailsService } from './postdetails.service';
import { IPostdetails } from './ipostdetails';
import { PickerDialogService, ErrorService } from 'fastCodeCore';

import { PostService } from '../post/post.service';

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-postdetails-details',
  templateUrl: './postdetails-details.component.html',
  styleUrls: ['./postdetails-details.component.scss']
})
export class PostdetailsDetailsComponent extends BaseDetailsComponent<IPostdetails> implements OnInit {
	title:string='Postdetails';
	parentUrl:string='postdetails';
	//roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: PostdetailsService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public postService: PostService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.entityName = 'Postdetails';
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			country: [''],
			pdid: [''],
			pid: [''],
			title: [''],
			postDescriptiveField : [{ value: '', disabled: true }],
			
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
						key: 'pid',
						value: undefined,
						referencedkey: 'postid'
					},
					{
						key: 'title',
						value: undefined,
						referencedkey: 'title'
					},
				],
				isParent: false,
				table: 'post',
				type: 'ManyToOne',
				service: this.postService,
				descriptiveField: 'postDescriptiveField',
			    referencedDescriptiveField: 'title',
			},
		];
		
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

	onItemFetched(item:IPostdetails) {
		this.item = item;
		this.itemForm.patchValue({
			country: item.country,
			pdid: item.pdid,
			pid: item.pid,
			title: item.title,
			postDescriptiveField: item.postDescriptiveField,
		});
	}
}
