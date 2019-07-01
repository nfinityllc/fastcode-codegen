import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef } from '@angular/material/dialog';
import { Globals } from '../globals';

@Component({
  selector: 'app-manage-entity-history',
  templateUrl: './manage-entity-history.component.html',
  styleUrls: ['./manage-entity-history.component.scss']
})
export class ManageEntityHistoryComponent implements OnInit {
  manageEntityHistoryForm: FormGroup;
  entities = ['books','pens'];
  properties = ['color','price'];
  
  isMediumDeviceOrLess: boolean;

  constructor(private global: Globals, private formBuilder: FormBuilder, public dialogRef: MatDialogRef<ManageEntityHistoryComponent>) { }

  ngOnInit() {
    this.global.isMediumDeviceOrLess$.subscribe(value => {
      this.isMediumDeviceOrLess = value;
    });

    this.manageEntityHistoryForm = this.formBuilder.group({
      entity: [''],
      property: ['']
    });
  }

  onSubmit() {
    
  }

  onCancel(): void {
    this.dialogRef.close();
  }

}
