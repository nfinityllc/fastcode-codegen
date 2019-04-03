import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { IListColumn, listColumnType } from '../../common/ilistColumn';

import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';

@Component({
  selector: 'app-add-filter-field',
  templateUrl: './add-filter-field.component.html',
  styleUrls: ['./add-filter-field.component.css']
})
export class AddFilterFieldComponent implements OnInit {
  field: IListColumn;
  filterFieldForm: FormGroup;
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<AddFilterFieldComponent>,
    private formBuilder: FormBuilder
    ) {}
  
  ngOnInit() {
    this.filterFieldForm = this.formBuilder.group({
      value: ['']
    });
    this.field = this.data;
    console.log(this.field)
  }

  addField():void{
    this.dialogRef.close(this.filterFieldForm.value.value)
  }

  cancel(): void{
    this.dialogRef.close(null)
  }

}
