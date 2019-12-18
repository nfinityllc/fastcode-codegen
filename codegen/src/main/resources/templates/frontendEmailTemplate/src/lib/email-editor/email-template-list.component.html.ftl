<mat-toolbar class="action-tool-bar" color="primary">
	<span>
		<span *ngIf="selectedAssociation" (click)="back()">
			<i class="material-icons">arrow_back</i>
			<span *ngIf="selectedAssociation.associatedObj">
				/{{selectedAssociation.associatedObj[selectedAssociation.referencedDescriptiveField]}}
			</span>
		</span>
	</span>
	<span class="middle">{{title}}</span>
	<button mat-button [disabled]="!IsCreatePermission" (click)="addNew()">
		Add </button>
	
</mat-toolbar>
<div class="list-container">
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<div class="table-container" (onScroll)="onTableScroll()" appVirtualScroll>
		<mat-table matSort [dataSource]="items" class="mat-elevation-z8">
			
			<ng-container matColumnDef="templatename">
				<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.TEMPLATE-NAME' | translate}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.TEMPLATE-NAME' | translate}}:</span>
					<a routerLink="./{{item.id}}" >{{item.templateName}} </a>
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="subject">
				<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.SUBJECT' | translate}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.SUBJECT' | translate}}:</span>
					{{ item.subject }}
				</mat-cell>
			</ng-container>
		
		<ng-container matColumnDef="category">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CATEGORY' | translate}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.CATEGORY' | translate}}:</span>
				{{ item.category }}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="lastModifierUserId">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.LAST-MODIFIER-USER-ID' | translate}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.LAST-MODIFIER-USER-ID' | translate}}:</span>
				{{ item.lastModifierUserId }}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="lastModificationTime">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.LAST-MODIFICATION-TIME' | translate}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{'EMAIL-EDITOR.EMAIL-TEMPLATE.FIELDS.LAST-MODIFICATION-TIME' | translate}}:</span>
				{{item.lastModificationTime | date:'short'}}
			</mat-cell>
		</ng-container>	
		
		<ng-container matColumnDef="actions">
			<mat-header-cell *matHeaderCellDef> {{'EMAIL-GENERAL.ACTIONS.ACTIONS' | translate}}</mat-header-cell>
			<mat-cell *matCellDef="let item"> 
				<button mat-button color="accent" [disabled]="!IsDeletePermission" (click)="delete(item)">{{'EMAIL-GENERAL.ACTIONS.DELETE' | translate}}</button>
			</mat-cell>
		</ng-container>
		<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
		<mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
		</mat-table>
	</div>
</div>
