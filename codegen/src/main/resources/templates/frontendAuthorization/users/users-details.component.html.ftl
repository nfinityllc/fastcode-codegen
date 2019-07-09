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
					<input type="number" formControlName="accessFailedCount" matInput placeholder="Enter accessFailedCount">
				</mat-form-field>

				<mat-form-field>
					<input formControlName="emailAddress" matInput placeholder="Enter emailAddress">
					<mat-error *ngIf="!itemForm.get('emailAddress').valid && itemForm.get('emailAddress').touched">emailAddress is required</mat-error>
				</mat-form-field>

				<mat-form-field>
					<input formControlName="firstName" matInput placeholder="Enter firstName">
					<mat-error *ngIf="!itemForm.get('firstName').valid && itemForm.get('firstName').touched">firstName is required</mat-error>
				</mat-form-field>
				<mat-checkbox formControlName="isActive">isActive</mat-checkbox>
				<mat-form-field>
					<input formControlName="lastName" matInput placeholder="Enter lastName">
					<mat-error *ngIf="!itemForm.get('lastName').valid && itemForm.get('lastName').touched">lastName is required</mat-error>
				</mat-form-field>
        
				<mat-form-field>
					<input formControlName="userName" matInput placeholder="Enter userName">
					<mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">userName is required</mat-error>
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