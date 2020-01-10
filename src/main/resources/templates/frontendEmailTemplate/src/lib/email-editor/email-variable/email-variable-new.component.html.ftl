<div>
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onCancel()">
			{{'EMAIL-GENERAL.ACTIONS.CANCEL' | translate}}</button>
		<span class="middle">{{title}}</span>
		<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()"
			[disabled]="!itemForm.valid || !IsUpdatePermission || loading">
			{{'EMAIL-GENERAL.ACTIONS.SAVE' | translate}}</button>
	</mat-toolbar>
	<mat-card>
		<h2>{{title}}</h2>
		<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">


			<mat-form-field>
				<input formControlName="propertyName" matInput placeholder="{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-NAME' | translate}}">
				<mat-error *ngIf="!itemForm.get('propertyName').valid && itemForm.get('propertyName').touched">
					{{'EMAIL-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
			</mat-form-field>
			<mat-form-field>
				<input formControlName="propertyType" matInput placeholder="{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-TYPE' | translate}}">
				<mat-error *ngIf="!itemForm.get('propertyType').valid && itemForm.get('propertyType').touched">
					{{'EMAIL-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
			</mat-form-field>
			<mat-form-field>
				<input formControlName="defaultValue" matInput placeholder="{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.DEFAULT-VALUE' | translate}}">
			</mat-form-field>

			<mat-form-field *ngFor="let association of parentAssociations">
				<input formControlName="{{association.descriptiveField}}" matInput placeholder="{{association.table}}">
				<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
			</mat-form-field>
		</form>
	</mat-card>
</div>