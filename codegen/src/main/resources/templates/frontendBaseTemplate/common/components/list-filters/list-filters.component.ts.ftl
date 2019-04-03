import { Component, OnInit, Output, EventEmitter, Input, ElementRef, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { IListColumn, listColumnType } from '../common/ilistColumn';
import { MatDialog, MatDialogRef } from '@angular/material';
import { AddFilterFieldComponent } from './add-filter-field/add-filter-field.component';

import { COMMA, ENTER } from '@angular/cdk/keycodes';
import { MatAutocompleteSelectedEvent, MatChipInputEvent, MatAutocomplete } from '@angular/material';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';

@Component({
  selector: 'app-list-filters',
  templateUrl: './list-filters.component.html',
  styleUrls: ['./list-filters.component.scss']
})
export class ListFiltersComponent implements OnInit {
  @Output() onSearch: EventEmitter<any> = new EventEmitter();
  @Input() columnsList: IListColumn[];
  filterFields: IListColumn[] = [];
  selectedFilterFields: any[] = [];

  filterValues = {};

  basicFilterForm: FormGroup;
  detailsFilterForm: FormGroup;
  showFilters = false;
  filterButtonText = "Show filters";

  filterCtrl = new FormControl();

  @ViewChild('filterInput') filterInput: ElementRef<HTMLInputElement>;
  @ViewChild('auto') matAutocomplete: MatAutocomplete;


  addFieldDialogRef: MatDialogRef<any>;

  constructor(
    private formBuilder: FormBuilder,
    public dialog: MatDialog
  ) { }

  ngOnInit() {
    this.initializeFilterForms();
  }

  initializeFilterForms(): void{
    this.basicFilterForm = this.formBuilder.group({
    });
    this.basicFilterForm.addControl("searchText", new FormControl(''));
    this.basicFilterForm.addControl("addFilter", new FormControl(''));

    this.columnsList.forEach((column) => {
      if (column.filter && column.type == (listColumnType.String || listColumnType.Number)) {
        this.filterFields.push(column);
      }
    });
  }

  search(): void {
    this.onSearch.emit(this.getFilterString(this.filterValues));
  }

  addFilter(field): void {
    console.log(field);
    this.addFieldDialogRef = this.dialog.open(AddFilterFieldComponent, {
      disableClose: true,
      data: field
    });
    this.addFieldDialogRef.afterClosed().subscribe(result => {
      console.log(result)
    });
    this.basicFilterForm.get("addFilter").setValue(this.basicFilterForm.get("addFilter").value + " " + field.label);
    this.filterFields.forEach((filterField, index) => {
      if (filterField.column == field.column) {
        this.filterFields.splice(index, 1)
      }
    });
  }

  add(event: MatChipInputEvent): void {
    // Add filter field only when MatAutocomplete is not open
    // To make sure this does not conflict with OptionSelected Event
    if (!this.matAutocomplete.isOpen) {
      const input = event.input;
      const value = event.value;

      // Add our filter field
      if ((value || '').trim()) {
        this.selectedFilterFields.push(value.trim());
      }

      // Reset the input value
      if (input) {
        input.value = '';
      }

      this.filterCtrl.setValue(null);
    }
  }

  selected(event: MatAutocompleteSelectedEvent): void {
    
    //getting Icolumnfield object for selected field
    let field = this.filterFields.find(x => x.label == event.option.viewValue);

    this.addFieldDialogRef = this.dialog.open(AddFilterFieldComponent, {
      disableClose: true,
      data: field
    });
    this.addFieldDialogRef.afterClosed().subscribe(result => {
      if(result != null){
        // adding value for this column to filter values object 
        this.filterValues[field.column] = result;

        this.selectedFilterFields.push(event.option.viewValue + ": \"" + result + "\"");
        this.filterInput.nativeElement.value = '';
        this.filterCtrl.setValue(null);

        //removing selected field from filter field options
        this.filterFields.splice(this.filterFields.findIndex(filterField => filterField === field),1);
      }
    });
  }

  remove(field: string): void {
    const index = this.selectedFilterFields.indexOf(field);

    // get listcolumn object from filter field
    let filterField = this.columnsList.find(x => {
      return x.label == field.split(':')[0];
    });

    // re-add field to filter fields
    this.filterFields.push(filterField);

    if (index >= 0) {
      delete this.filterValues[filterField.column];
      this.selectedFilterFields.splice(index, 1);
    }
  }

  getFilterString(filterObj): string{
    let filterString = "";
    if(filterObj){
      Object.keys(filterObj).forEach((key)=>{
        filterString = filterString + key + ":" + filterObj[key] + ',';
      })
      filterString = filterString.slice(0, -1);
    }
    return filterString;
  }
}
