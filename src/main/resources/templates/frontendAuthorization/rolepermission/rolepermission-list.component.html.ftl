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
 		{{'GENERAL.ACTIONS.ADD' | translate}} </button>
</mat-toolbar>
<div class="list-container">
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<div class="table-container" (onScroll)="onTableScroll()" appVirtualScroll>
		<mat-table matSort [dataSource]="items" class="mat-elevation-z8">
						<ng-container matColumnDef="Permission">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Permission')">Permission </mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("Permission")}}:</span>
					{{ item.permissionDescriptiveField }}
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="Role">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Role')">Role </mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("Role")}}:</span>
					{{ item.roleDescriptiveField }}
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="actions">
				<mat-header-cell *matHeaderCellDef> Actions</mat-header-cell>
				<mat-cell *matCellDef="let item" (click)="$event.stopPropagation()"> 
					<button mat-button color="accent"(click)="delete(item)">{{'GENERAL.ACTIONS.DELETE' | translate}}</button>
				</mat-cell>
			</ng-container>
			<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
			<mat-row *matRowDef="let row; columns: displayedColumns;" (click)="openDetails(row)"></mat-row>
		</mat-table>
	</div>
</div>
