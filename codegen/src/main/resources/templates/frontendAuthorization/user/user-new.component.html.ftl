<div class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onCancel()">{{'GENERAL.ACTIONS.CANCEL' | translate}}</button>
			<span class="middle">{{title}}</span>
			<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()" [disabled]="!itemForm.valid || loading">{{'GENERAL.ACTIONS.SAVE' | translate}}</button>
	</mat-toolbar>
	<mat-card>
		<h2>{{title}}</h2>
		<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
			<mat-form-field>
				<input formControlName="firstName" matInput placeholder="Enter firstName">
				<mat-error *ngIf="!itemForm.get('firstName').valid && itemForm.get('firstName').touched">firstName is required</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input formControlName="lastName" matInput placeholder="Enter lastName">
				<mat-error *ngIf="!itemForm.get('lastName').valid && itemForm.get('lastName').touched">lastName is required</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input formControlName="userName" matInput placeholder="Enter userName">
				<mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">userName is required</mat-error>
			</mat-form-field>
			
			<mat-form-field>
				<input formControlName="emailAddress" matInput placeholder="Enter emailAddress">
				<mat-error *ngIf="!itemForm.get('emailAddress').valid && itemForm.get('emailAddress').touched">emailAddress is required</mat-error>
			</mat-form-field>
			
			<mat-form-field>
				<input formControlName="phoneNumber" matInput placeholder="Enter phoneNumber">
			</mat-form-field>
			
			<mat-form-field>
				<input type="password"matInput placeholder="New password" formControlName="password" required>
				<mat-error *ngIf="itemForm.hasError('required', 'password')">
					Please enter your new password
				</mat-error>
			</mat-form-field>
			
			<mat-form-field>
				<input matInput type="password" placeholder="Confirm password" formControlName="confirmPassword"
				pattern="{{ itemForm.get('password').value }}">
				<mat-error *ngIf="!itemForm.get('confirmPassword').valid && itemForm.get('confirmPassword').touched">
					Passwords do not match
				</mat-error>
			</mat-form-field>
		
			<mat-checkbox formControlName="isActive">isActive</mat-checkbox>            
		
			<mat-form-field *ngFor="let association of parentAssociations">
				<input formControlName="{{association.descriptiveField}}" matInput placeholder="{{association.table}}">
				<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
			</mat-form-field>       
		</form>
	</mat-card>
</div>