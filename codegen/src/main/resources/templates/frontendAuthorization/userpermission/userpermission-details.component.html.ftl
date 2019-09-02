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
			
				<mat-form-field *ngFor="let association of toOne">
					<input matInput disabled placeholder="{{association.table}}" formControlName="{{association.descriptiveField}}">
					<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
				</mat-form-field>
				
				<div *ngFor="let association of toMany">
					<a *ngIf="association.type == 'OneToMany'" [routerLink]="['/' + association.table]" [queryParams]="getQueryParams(association)" class="btn btn-link">{{association.table}}</a>
				</div>
			</form>
		</mat-card-content>
	</mat-card>
</div>