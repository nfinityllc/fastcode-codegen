<div class="container1">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-flat-button (click)="onCancel()">
      {{'GENERAL.ACTION.CANCEL' | translate}} </button>
    <span class="middle">{{'TASK.DUE-DATE.TITLE' | translate}}</span>

    <button mat-flat-button (click)="dueDateNgForm.ngSubmit.emit()" [disabled]="!dueDateForm.valid || loading">
      {{'GENERAL.ACTION.SELECT' | translate}} </button>

  </mat-toolbar>
  <mat-card>
    <div class="button-row">
      <button mat-raised-button color="accent" (click)="clearDueDate()">{{'TASK.DUE-DATE.CLEAR' | translate}}</button>
      <button mat-raised-button color="accent" (click)="dueToday()">{{'TASK.DUE-DATE.DUE-TODAY' | translate}}</button>
    </div>

    <form [formGroup]="dueDateForm" #dueDateNgForm="ngForm" (ngSubmit)="onSubmit()" class="update-duedate-form">
      <div class="full-width">

        <mat-form-field class="full-width">
          <input matInput [matDatepicker]="dueDatePicker" formControlName="dueDate">
          <mat-datepicker-toggle matSuffix [for]="dueDatePicker"></mat-datepicker-toggle>
          <mat-datepicker #dueDatePicker></mat-datepicker>
        </mat-form-field>

      </div>
    </form>
  </mat-card>
</div>