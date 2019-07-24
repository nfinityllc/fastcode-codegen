<div class="container1">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-flat-button (click)="onCancel()">
      {{'GENERAL.ACTION.CANCEL' | translate}}
    </button>
    <span class="middle">{{'PROCESS.TITLE.CREATE-NEW' | translate}}</span>

    <button mat-flat-button (click)="processNgForm.ngSubmit.emit()" [disabled]="!processForm.valid || loading">
      {{'PROCESS.ACTION.CREATE-CONFIRM' | translate}}
    </button>

  </mat-toolbar>
  <mat-card>
    <form [formGroup]="processForm" #processNgForm="ngForm" (ngSubmit)="onSubmit()" class="process-form">

      <mat-form-field class="full-width">
        <input formControlName="name" matInput placeholder="Name">
      </mat-form-field>

      <mat-form-field class="full-width">
        <mat-select formControlName="processDefinition" placeholder="{{'PROCESS.FIELD.PROCESS-DEFINITION' | translate}}">
          <mat-option *ngFor="let pd of processDefinitions" [value]="pd">
            {{pd.name}}
          </mat-option>
        </mat-select>
        <mat-error *ngIf="!processForm.get('processDefinition').valid && processForm.get('processDefinition').touched">
          {{'PROCESS.FIELD.PROCESS-DEFINITION' | translate}} {{'GENERAL.ERROR.REQUIRED' | translate}} </mat-error>
      </mat-form-field>

    </form>
  </mat-card>
</div>