<div>
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onCancel()">Cancel</button>
			<span class="middle">{{title}}</span>
			<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()"   [disabled]="!itemForm.valid || !IsUpdatePermission || loading">Save</button>
	</mat-toolbar>
	<mat-card>
		<h2>{{title}}</h2>
		<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
				
			
			<mat-form-field>
				<input formControlName="propertyName" matInput placeholder="Enter property name">
				<mat-error *ngIf="!itemForm.get('propertyName').valid && itemForm.get('propertyName').touched">propertyname is required</mat-error>
			</mat-form-field>
			<mat-form-field>
				<input formControlName="propertyType" matInput placeholder="Enter property type">
				<mat-error *ngIf="!itemForm.get('propertyType').valid && itemForm.get('propertyType').touched">propertytype is required</mat-error>
			</mat-form-field>
			<mat-form-field>
				<input formControlName="defaultValue" matInput placeholder="Enter default value">
			</mat-form-field>
			
			<mat-form-field *ngFor="let association of parentAssociations">
				<input formControlName="{{association.descriptiveField}}" matInput placeholder="{{association.table}}">
				<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
			</mat-form-field>       
		</form>
	</mat-card>
</div>
