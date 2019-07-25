<div *ngIf="item">
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
		<mat-card-content>
			<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
				<mat-form-field>
					<input formControlName="displayName" matInput placeholder="Display Name">
				</mat-form-field>
				<mat-form-field>
					<input formControlName="name" matInput placeholder="Name">
					<mat-error *ngIf="!itemForm.get('name').valid && itemForm.get('name').touched">
						{{'GENERAL.ERRORS.REQUIRED' | translate}}
					</mat-error>
				</mat-form-field>

				<mat-form-field *ngFor="let association of toOne">
					<input matInput disabled placeholder="{{association.table}}"
						value="{{item[association.descriptiveField]}}">
				</mat-form-field>

				<div *ngFor="let association of toMany">
					<a [routerLink]="['/' + association.table]" [queryParams]="getQueryParams(association)"
						class="btn btn-link">{{association.table}}</a>
				</div>
			</form>
		</mat-card-content>
	</mat-card>
</div>