<div class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-button class="left" (click)="onCancel()">Cancel </button>
		<span class="middle">Select a {{title}}</span>

		<button mat-button class="right" (click)="onOk()">Ok</button>
	</mat-toolbar>
	
	<form class="search-form">
		<mat-form-field class="form-field">
			<input matInput placeholder="Search" (input)="onSearchChange($event.target.value)">
		</mat-form-field>
	</form>

	<mat-dialog-content (onScroll)="onTableScroll()" appVirtualScroll>
		<mat-selection-list>
			<mat-list-option *ngFor="let item of items" [value]="item">
				<mat-icon mat-list-icon>perm_identity</mat-icon>
				<h4 mat-line>{{item[displayField]}}</h4>
				<mat-divider></mat-divider>
			</mat-list-option>
		</mat-selection-list>
	</mat-dialog-content>
</div>