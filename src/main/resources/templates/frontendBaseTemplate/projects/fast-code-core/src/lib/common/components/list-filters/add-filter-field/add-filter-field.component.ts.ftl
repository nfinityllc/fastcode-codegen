import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { IListColumn, listColumnType } from '../../../ilistColumn';

import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { ISearchField, operatorType} from '../ISearchCriteria';

@Component({
  selector: 'app-add-filter-field',
  templateUrl: './add-filter-field.component.html',
  styleUrls: ['./add-filter-field.component.css']
})
export class AddFilterFieldComponent implements OnInit {
  field: IListColumn;
  filterFieldForm: FormGroup;
  operators: string[];
  booleanOptions: string[] = ['True','False'];
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<AddFilterFieldComponent>,
    private formBuilder: FormBuilder
    ) {}
  
  ngOnInit() {
    this.filterFieldForm = this.formBuilder.group({
      fieldName: [this.data.column],
      searchValue: [''],
      startingValue: [''],
      endingValue: [''],
      operator: ['', Validators.required ],
    });
    this.field = this.data;
    this.operators = Object.keys(operatorType).map(k => operatorType[k as any]);
    if(this.field.type == listColumnType.String){
      this.operators.splice(this.operators.indexOf(operatorType.Range),1);
    }
    else if(this.field.type == listColumnType.Boolean){
      this.operators.splice(this.operators.indexOf(operatorType.Contains),1);
      this.operators.splice(this.operators.indexOf(operatorType.Range),1);
    }
    else{
      this.operators.splice(this.operators.indexOf(operatorType.Contains),1);
    }
  }

  addField():void{
    this.dialogRef.close(this.filterFieldForm.value)
  }

  cancel(): void{
    this.dialogRef.close(null)
  }

}