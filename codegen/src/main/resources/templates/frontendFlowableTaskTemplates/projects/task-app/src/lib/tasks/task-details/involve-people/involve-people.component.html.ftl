<div class="container1">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-button class="left" (click)="onCancel()">{{'GENERAL.ACTION.CANCEL' | translate}} </button>
    <span class="middle">{{'TASK.INVOLVEMENT.TITLE' | translate}}</span>

    <button mat-button class="right" (click)="onSelect()">{{'GENERAL.ACTION.SELECT' | translate}}</button>
  </mat-toolbar>

  <mat-card>
    <form [formGroup]="userForm" #userNgForm="ngForm" (submit)="submit($event)" class="user-form">
      <div class="full-width">
        <mat-form-field class="full-width">
          <input formControlName="name" matInput placeholder="Enter username">
          <mat-error *ngIf="userForm.get('name').errors && userForm.get('name').errors['required'] && userForm.get('name').touched">Name cannot be empty</mat-error>
        </mat-form-field>
      </div>
    </form>
    <button mat-flat-button (click)="onSearch()" [disabled]="!userForm.valid || loading">
      {{'GENERAL.ACTION.SEARCH' | translate}}
      </button>
  </mat-card>

  <mat-selection-list>

    <mat-list-option *ngFor="let item of users" [value]="item">
      <mat-icon mat-list-icon>perm_identity</mat-icon>
      <h4 mat-line>{{item.fullName}}</h4>
      <mat-divider></mat-divider>
    </mat-list-option>
  </mat-selection-list>

</div>