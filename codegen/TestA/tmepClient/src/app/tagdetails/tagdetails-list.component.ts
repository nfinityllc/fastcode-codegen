import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { ITagdetails } from './itagdetails';
import { TagdetailsService } from './tagdetails.service';
import { Router, ActivatedRoute } from '@angular/router';
import {TagdetailsNewComponent} from './tagdetails-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'fastCodeCore';

import { TagService } from '../tag/tag.service';

@Component({
  selector: 'app-tagdetails-list',
  templateUrl: './tagdetails-list.component.html',
  styleUrls: ['./tagdetails-list.component.scss']
})
export class TagdetailsListComponent extends BaseListComponent<ITagdetails> implements OnInit {

	title:string = "Tagdetails";
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: TagdetailsService,
		public errorService: ErrorService,
		public tagService: TagService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.entityName = 'Tagdetails';
		this.setAssociation();
		this.setColumns();
		this.primaryKeys = [ "tid", "title",  ]
		super.ngOnInit();
	}
  
  
	setAssociation(){
  	
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
				descriptiveField: 'tagDescriptiveField',
				referencedDescriptiveField: 'description',
				service: this.tagService,
				associatedObj: undefined,
				table: 'tag',
				type: 'OneToOne'
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
	  			column: 'Tag',
				label: 'Tag',
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
		super.addNew(TagdetailsNewComponent);
	}
  
}
