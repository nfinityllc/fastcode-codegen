import { Component, OnInit, Inject } from '@angular/core';
import { PostdetailsService } from './postdetails.service';
import { IPostdetails } from './ipostdetails';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { PostService } from '../post/post.service';

@Component({
  selector: 'app-postdetails-new',
  templateUrl: './postdetails-new.component.html',
  styleUrls: ['./postdetails-new.component.scss']
})
export class PostdetailsNewComponent extends BaseNewComponent<IPostdetails> implements OnInit {
  
    title:string = "New Postdetails";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<PostdetailsNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: PostdetailsService,
		public errorService: ErrorService,
		public postService: PostService,
	) {
		super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
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
		this.checkPassedData();
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
			this.parentAssociations = this.associations.filter(association => {
				return (!association.isParent);
			});
	
		}  
    
}
