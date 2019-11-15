import { Component, OnInit, Inject } from '@angular/core';
import { PostService } from './post.service';
import { IPost } from './ipost';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
  selector: 'app-post-new',
  templateUrl: './post-new.component.html',
  styleUrls: ['./post-new.component.scss']
})
export class PostNewComponent extends BaseNewComponent<IPost> implements OnInit {
  
    title:string = "New Post";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<PostNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: PostService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	}
 
	ngOnInit() {
		this.entityName = 'Post';
		this.setAssociations();
		super.ngOnInit();
		this.itemForm = this.formBuilder.group({
			description: [''],
			postid: [''],
			title: [''],
		});
		this.checkPassedData();
    }
 		
	 
		setAssociations(){
	  	
			this.associations = [
			];
			this.parentAssociations = this.associations.filter(association => {
				return (!association.isParent);
			});
	
		}  
    
}
