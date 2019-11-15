import { Component, OnInit, Inject } from '@angular/core';
import { TagService } from './tag.service';
import { ITag } from './itag';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'fastCodeCore';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
  selector: 'app-tag-new',
  templateUrl: './tag-new.component.html',
  styleUrls: ['./tag-new.component.scss']
})
export class TagNewComponent extends BaseNewComponent<ITag> implements OnInit {
  
    title:string = "New Tag";
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public dialogRef: MatDialogRef<TagNewComponent>,
		@Inject(MAT_DIALOG_DATA) public data: any,
		public global: Globals,
		public pickerDialogService: PickerDialogService,
		public dataService: TagService,
		public errorService: ErrorService,
	) {
		super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
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
