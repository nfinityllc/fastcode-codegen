<div *ngIf="item">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onBack()">
	    Cancel </button>
		<span class="middle">{{title}}</span>
	
		<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()">
	    Save </button>
	</mat-toolbar>
	<mat-card>
		<mat-card-content>
			<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
							<mat-form-field>
					<input formControlName="displayName" matInput placeholder="Enter displayName">
				</mat-form-field>
				<mat-form-field>
					<input formControlName="name" matInput placeholder="Enter name">
					<mat-error *ngIf="!itemForm.get('name').valid && itemForm.get('name').touched">name is required</mat-error>
				</mat-form-field>
			
				<mat-form-field *ngFor="let association of toOne">
					<input matInput disabled placeholder="{{association.table}}" value="{{item[association.descriptiveField]}}">
				</mat-form-field>
				
				<div *ngFor="let association of toMany">
					<a [routerLink]="['/' + association.table]" [queryParams]="getQueryParams(association)" class="btn btn-link">{{association.table}}</a>
				</div>
			</form>
		</mat-card-content>
	</mat-card>
</div>