<h1 mat-dialog-title>{{field.label}}</h1>

<div mat-dialog-content>
  <form [formGroup]="filterFieldForm" #addFilterNgForm="ngForm" (ngSubmit)="addField()" class="field-form">

    <mat-form-field>
      <mat-label>Operator</mat-label>
      <mat-select formControlName="operator">
        <mat-option *ngFor="let operator of operators" [value]="operator">
          {{operator}}
        </mat-option>
      </mat-select>
    </mat-form-field>

    <div class="field-div" *ngIf="field.type == 'String'">
      <mat-form-field *ngIf="filterFieldForm.get('operator').value">
        <input formControlName="searchValue" matInput placeholder="value">
      </mat-form-field>
    </div>

    <div class="field-div" *ngIf="field.type == 'Boolean'">
      <mat-form-field *ngIf="filterFieldForm.get('operator').value">
        <mat-label>value</mat-label>
        <mat-select formControlName="searchValue">
          <mat-option *ngFor="let option of booleanOptions" [value]="option">
            {{option}}
          </mat-option>
        </mat-select>
      </mat-form-field>
    </div>

    <div class="field-div" *ngIf="field.type == 'Number'">
      <mat-form-field *ngIf="['equals','notEqual'].indexOf(filterFieldForm.get('operator').value) > - 1">
        <input type="number" formControlName="searchValue" matInput placeholder="value">
      </mat-form-field>

      <mat-form-field *ngIf="filterFieldForm.get('operator').value == 'range'">
        <input type="number" formControlName="startingValue" matInput placeholder="starting value">
      </mat-form-field>

      <mat-form-field *ngIf="filterFieldForm.get('operator').value == 'range'">
        <input type="number" formControlName="endingValue" matInput placeholder="ending value">
      </mat-form-field>
    </div>

    <div class="field-div" *ngIf="field.type == 'Date'">
      <mat-form-field *ngIf="['equals','notEqual'].indexOf(filterFieldForm.get('operator').value) > - 1">
        <input formControlName="searchValue" matInput [matDatepicker]="datePicker" placeholder="value">
        <mat-datepicker-toggle matSuffix [for]="datePicker"></mat-datepicker-toggle>
        <mat-datepicker #datePicker></mat-datepicker>
      </mat-form-field>

      <mat-form-field *ngIf="filterFieldForm.get('operator').value == 'range'">
        <input formControlName="startingValue" matInput [matDatepicker]="startDatePicker" placeholder="starting value">
        <mat-datepicker-toggle matSuffix [for]="startDatePicker"></mat-datepicker-toggle>
        <mat-datepicker #startDatePicker></mat-datepicker>
      </mat-form-field>

      <mat-form-field *ngIf="filterFieldForm.get('operator').value == 'range'">
        <input formControlName="endingValue" matInput [matDatepicker]="startDatePicker" placeholder="ending value">
        <mat-datepicker-toggle matSuffix [for]="startDatePicker"></mat-datepicker-toggle>
        <mat-datepicker #startDatePicker></mat-datepicker>
      </mat-form-field>
    </div>

  </form>
</div>

<div mat-dialog-actions>
  <button mat-flat-button (click)="addFilterNgForm.ngSubmit.emit()" [disabled]="!filterFieldForm.valid || loading">
    Save </button>
  <button mat-flat-button (click)="cancel()">
    Cancel </button>
</div>