<div>
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-button (click)="onCancel()">
      {{'GENERAL.ACTIONS.CANCEL' | translate}} </button>
    <span class="middle">{{title}}</span>
  
    <button [disabled]="!itemForm.valid || loading || !IsCreatePermission" mat-button (click)="itemNgForm.ngSubmit.emit()">
      {{'GENERAL.ACTIONS.SAVE' | translate}} </button>
  </mat-toolbar>
	<mat-card>
		<h2>{{title}}</h2>
		<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
			<mat-form-field *ngFor="let association of parentAssociations">
				<input formControlName="{{association.descriptiveField}}" matInput placeholder="{{association.table}}">
				<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
			</mat-form-field>       
		</form>
	</mat-card>
</div>
