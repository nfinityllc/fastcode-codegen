<div class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-button (click)="onBack()">
			{{'GENERAL.ACTIONS.CANCEL' | translate}}
		</button>
		<span class="middle">{{title}}</span>
			
		<button mat-button (click)="itemNgForm.ngSubmit.emit()" [disabled]="!itemForm.valid || loading">
			{{'GENERAL.ACTIONS.SAVE' | translate}}
		</button>
	</mat-toolbar>
	<mat-card>
		<h2>{{title}}</h2>
		<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">

			<mat-form-field>
				<input formControlName="firstName" matInput placeholder="First Name">
				<mat-error *ngIf="!itemForm.get('firstName').valid && itemForm.get('firstName').touched">
					{{'GENERAL.ERRORS.REQUIRED' | translate}}
				</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input formControlName="lastName" matInput placeholder="Last Name">
				<mat-error *ngIf="!itemForm.get('lastName').valid && itemForm.get('lastName').touched">
					{{'GENERAL.ERRORS.REQUIRED' | translate}}
				</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input type="email" email formControlName="emailAddress" matInput placeholder="Email Address">
				<mat-error *ngIf="itemForm.get('emailAddress').hasError('required') && itemForm.get('emailAddress').touched">
					{{'GENERAL.ERRORS.REQUIRED' | translate}}
				</mat-error>
				<mat-error *ngIf="!itemForm.get('emailAddress').valid && !itemForm.get('emailAddress').hasError('required') && itemForm.get('emailAddress').touched">
					{{'GENERAL.ERRORS.INVALID-EMAIL' | translate}}
				</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input formControlName="userName" matInput placeholder="Username">
				<mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">
					{{'GENERAL.ERRORS.REQUIRED' | translate}}
				</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input type="password" matInput placeholder="Password" formControlName="password" required>
				<mat-error *ngIf="itemForm.hasError('required', 'password')">
					{{'GENERAL.ERRORS.REQUIRED' | translate}}
				</mat-error>
			</mat-form-field>

			<mat-form-field>
				<input matInput type="password" placeholder="Confirm password" formControlName="confirmPassword" pattern="{{ itemForm.get('password').value }}">
				<mat-error *ngIf="!itemForm.get('confirmPassword').valid && itemForm.get('confirmPassword').touched">
					{{'GENERAL.ERRORS.PASSWORD-MISMATCH' | translate}}
				</mat-error>
			</mat-form-field>

			<mat-checkbox formControlName="isActive">Active</mat-checkbox>

			<mat-form-field *ngFor="let association of toOne">
				<input formControlName="{{association.descriptiveField}}" matInput placeholder="{{association.table}}">
				<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
			</mat-form-field>
		</form>
	</mat-card>
</div>