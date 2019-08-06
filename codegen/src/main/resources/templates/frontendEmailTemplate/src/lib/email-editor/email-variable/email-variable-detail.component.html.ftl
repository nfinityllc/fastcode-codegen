<div *ngIf="item">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onBack()">
	    {{'EMAIL-GENERAL.ACTIONS.CANCEL' | translate}} </button>
		<span class="middle">{{title}}</span>
	
		<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()">
		{{'EMAIL-GENERAL.ACTIONS.SAVE' | translate}} </button>
	</mat-toolbar>
	<mat-card>
		<mat-card-content>
			<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
				
				<mat-form-field>
					<input formControlName="propertyName" matInput placeholder="{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-NAME' | translate}}">
					<mat-error *ngIf="!itemForm.get('propertyName').valid && itemForm.get('propertyName').touched">{{'EMAIL-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
				</mat-form-field>
				<mat-form-field>
					<input formControlName="propertyType" matInput placeholder="{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-TYPE' | translate}}">
					<mat-error *ngIf="!itemForm.get('propertyType').valid && itemForm.get('propertyType').touched">{{'EMAIL-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
				</mat-form-field>	
				<mat-form-field>
					<input formControlName="defaultValue" matInput placeholder="{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.DEFAULT-VALUE' | translate}}">
				</mat-form-field>
			
			
				<div *ngFor="let association of toOne" class="button-row">
					<span>{{association.table}} :</span>
					<a [routerLink]="['/' + association.table + '/' + itemForm.get(association.column.key).value]" *ngIf="itemForm.get(association.column.key).value">{{item[association.descriptiveField]}}</a>
					<label *ngIf="!itemForm.get(association.column.key).value">{{'EMAIL-EDITOR.EMAIL-VARIABLE.MESSAGES.NO-ASSOCIATION-SELECTED' | translate: { table: association.table } }}</label>
				</div>
				
				<div *ngFor="let association of toMany">
					<a [routerLink]="['/' + association.table]" [queryParams]="getQueryParams(association)" class="btn btn-link">{{association.table}}</a>
				</div>
			</form>
		</mat-card-content>
	</mat-card>
</div>