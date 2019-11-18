<div class="container1">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-button (click)="onCancel()">
      {{'GENERAL.ACTION.CANCEL' | translate}}
    </button>
    <span class="middle">{{'TASK.TITLE.CREATE-NEW' | translate}}</span>

    <button mat-button (click)="taskNgForm.ngSubmit.emit()" [disabled]="!taskForm.valid || loading">
      {{'TASK.ACTION.CREATE-CONFIRM' | translate}}
    </button>

  </mat-toolbar>
  <mat-card>
    <form [formGroup]="taskForm" #taskNgForm="ngForm" (ngSubmit)="onSubmit()" class="task-form">
      <div class="full-width">
        <mat-form-field class="full-width">
          <input formControlName="name" matInput placeholder="{{'TASK.FIELD.NAME' | translate}}">
          <mat-error *ngIf="taskForm.get('name').errors && taskForm.get('name').errors['required'] && taskForm.get('name').touched">Name
            {{'GENERAL.ERROR.REQUIRED' | translate}}</mat-error>
        </mat-form-field>
      </div>

      <div class="full-width">
        <mat-form-field class="full-width">
          <textarea formControlName="description" matInput placeholder="{{'TASK.FIELD.DESCRIPTION' | translate}}"></textarea>
          <mat-error *ngIf="taskForm.get('description').errors && taskForm.get('description').errors['maxlength']">{{'GENERAL.ERROR.LENGTH'
            | translate}} {{taskForm.get('description').errors.maxlength.requiredLength}}</mat-error>
        </mat-form-field>
      </div>
    </form>

    <div class="button-row">
      <button mat-raised-button color="accent" (click)="addAssignee()">
        <mat-icon>person</mat-icon>
        {{'TASK.FIELD.ASSIGNEE' | translate}}
      </button>
      {{assignee.fullName}}
    </div>
  </mat-card>
</div>