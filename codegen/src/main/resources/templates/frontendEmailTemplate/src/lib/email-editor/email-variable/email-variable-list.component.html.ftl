<mat-toolbar class="action-tool-bar" color="primary">
	<span *ngIf="!selectedAssociation"></span>
	<span *ngIf="selectedAssociation">
		<span routerLink="/{{selectedAssociation.table}}/{{selectedAssociation.column.value}}">
			<i class="material-icons">arrow_back</i>
			<span *ngIf="selectedAssociation.associatedObj">
				/{{selectedAssociation.associatedObj[selectedAssociation.referencedDescriptiveField]}}
			</span>
		</span>
	</span>
	<span class="middle">{{title}}</span>
	<i class="material-icons" (click)="addNew()">
		add
	</i>
</mat-toolbar>
<div class="container">
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<div class="table-container" (onScroll)="onTableScroll()" appVirtualScroll>
		<mat-table matSort [dataSource]="items" class="mat-elevation-z8">
			<ng-container matColumnDef="propertyName">
				<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-NAME' | translate}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-NAME' | translate}}:</span>
					
					<a routerLink="./{{item.id}}">
						{{ item.propertyName }}
					</a>
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="propertyType">
				<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-TYPE' | translate}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.PROPERTY-TYPE' | translate}}:</span>
					{{ item.propertyType }}
				</mat-cell>
			</ng-container>
		
		<ng-container matColumnDef="lastModificationTime">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.LAST-MODIFICATION-TIME' | translate}} </mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.LAST-MODIFICATION-TIME' | translate}}:</span>
				{{item.lastModificationTime | date:'short'}}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="lastModifierUserId">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.LAST-MODIFIER-USER-ID' | translate}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-VARIABLE.FIELDS.LAST-MODIFIER-USER-ID' | translate}}:</span>
				{{ item.lastModifierUserId }}
			</mat-cell>
		</ng-container>
		
		<ng-container matColumnDef="actions">
			<mat-header-cell *matHeaderCellDef> {{'EMAIL-GENERAL.ACTIONS.ACTIONS' | translate}}</mat-header-cell>
			<mat-cell *matCellDef="let item"> 
				<button mat-button color="accent"(click)="delete(item)">{{(selectedAssociation && selectedAssociation.type == "ManyToMany")? ('EMAIL-GENERAL.ACTIONS.DE-LINK' | translate) : ('EMAIL-GENERAL.ACTIONS.DELETE' | translate) }}</button>
			</mat-cell>
		</ng-container>
		<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
		<mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
		</mat-table>
	</div>
</div>
