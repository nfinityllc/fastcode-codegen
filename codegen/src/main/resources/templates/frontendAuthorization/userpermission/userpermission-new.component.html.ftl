<div class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onCancel()">{{'GENERAL.ACTIONS.CANCEL' | translate}}</button>
			<span class="middle">{{title}}</span>
			<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()" [disabled]="!itemForm.valid || loading">{{'GENERAL.ACTIONS.SAVE' | translate}}</button>
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
