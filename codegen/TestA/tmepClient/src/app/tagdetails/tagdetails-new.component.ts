import { Component, OnInit, Inject } from '@angular/core';
import { TagdetailsService } from './tagdetails.service';
import { ITagdetails } from './itagdetails';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { TagService } from '../tag/tag.service';

@Component({
  selector: 'app-tagdetails-new',
  templateUrl: './tagdetails-new.component.html',
  styleUrls: ['./tagdetails-new.component.scss']
})
export class TagdetailsNewComponent extends BaseNewComponent<ITagdetails> implements OnInit {
  
    title:string = "New Tagdetails";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<TagdetailsNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: TagdetailsService,
		public errorService: ErrorService,
		public tagService: TagService,
	) {
		super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
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
		this.checkPassedData();
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
			this.parentAssociations = this.associations.filter(association => {
				return (!association.isParent);
			});
	
		}  
    
}
