<div *ngIf="item" class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onBack()">
	    {{'GENERAL.ACTIONS.CANCEL' | translate}} </button>
		<span class="middle">{{title}}</span>
	
		<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()">
	    {{'GENERAL.ACTIONS.SAVE' | translate}} </button>
	</mat-toolbar>
	<mat-card class="card">
		<mat-card-content>
			<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
			
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