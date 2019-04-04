<h1 mat-dialog-title>{{field.label}}</h1>
<form [formGroup]="filterFieldForm" #addFilterNgForm="ngForm" (ngSubmit)="addField()">
  <mat-form-field *ngIf="field.type == 'String'">
    <input formControlName="value" matInput placeholder="value">
  </mat-form-field>
</form>
<button mat-flat-button (click)="addFilterNgForm.ngSubmit.emit()" [disabled]="!filterFieldForm.valid || loading">
  Save </button>
  <button mat-flat-button (click)="cancel()" >
    Cancel </button>