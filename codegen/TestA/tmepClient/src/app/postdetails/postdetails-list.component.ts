import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { IPostdetails } from './ipostdetails';
import { PostdetailsService } from './postdetails.service';
import { Router, ActivatedRoute } from '@angular/router';
import {PostdetailsNewComponent} from './postdetails-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';

import { PostService } from '../post/post.service';

@Component({
  selector: 'app-postdetails-list',
  templateUrl: './postdetails-list.component.html',
  styleUrls: ['./postdetails-list.component.scss']
})
export class PostdetailsListComponent extends BaseListComponent<IPostdetails> implements OnInit {

	title:string = "Postdetails";
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: PostdetailsService,
		public errorService: ErrorService,
		public postService: PostService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.entityName = 'Postdetails';
		this.setAssociation();
		this.setColumns();
		this.primaryKeys = [ "pdid", "pid",  ]
		super.ngOnInit();
	}
  
  
	setAssociation(){
  	
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
				descriptiveField: 'postDescriptiveField',
				referencedDescriptiveField: 'title',
				service: this.postService,
				associatedObj: undefined,
				table: 'post',
				type: 'ManyToOne'
			},
		];
	}
  
  	setColumns(){
  		this.columns = [
    		{
				column: 'country',
				label: 'country',
				sort: true,
				filter: true,
				type: listColumnType.String
			},
    		{
				column: 'pdid',
				label: 'pdid',
				sort: false,
				filter: false,
				type: listColumnType.String
			},
			{
	  			column: 'Post',
				label: 'Post',
				sort: false,
				filter: false,
				type: listColumnType.String
	  		},
		  	{
				column: 'actions',
				label: 'Actions',
				sort: false,
				filter: false,
				type: listColumnType.String
			}
		];
		this.selectedColumns = this.columns;
		this.displayedColumns = this.columns.map((obj) => { return obj.column });
  	}
  
	addNew() {
		super.addNew(PostdetailsNewComponent);
	}
  
}
