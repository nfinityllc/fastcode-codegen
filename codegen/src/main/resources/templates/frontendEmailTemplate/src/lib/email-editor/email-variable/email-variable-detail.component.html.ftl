<div *ngIf="item" class="details-container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onBack()">
	    Cancel </button>
		<span class="middle">{{title}}</span>
	
		<button mat-flat-button  [disabled]="!IsUpdatePermission"  (click)="itemNgForm.ngSubmit.emit()">
		Save </button>
		
	</mat-toolbar>
	<mat-card>
		<mat-card-content>
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
					<input formControlName="defaultValue" matInput placeholder="Enter defaultvalue">
				</mat-form-field>
			
			
				<mat-form-field *ngFor="let association of parentAssociations">
					<input matInput disabled placeholder="{{association.table}}" formControlName="{{association.descriptiveField}}">
					<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
				</mat-form-field>
				
			</form>
			<div *ngFor="let association of childAssociations" class="association-div">
				<button mat-stroked-button color="primary" (click)="openChildDetails(association)" class="btn btn-link">
					{{association.table}}
				</button>
			</div>
		</mat-card-content>
	</mat-card>
</div>