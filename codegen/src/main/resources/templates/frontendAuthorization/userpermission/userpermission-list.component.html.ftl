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
	<i class="material-icons" (click)="addNew()">
		add
	</i>
</mat-toolbar>
<div class="container">
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<div class="table-container" (onScroll)="onTableScroll()" appVirtualScroll>
		<mat-table matSort [dataSource]="items" class="mat-elevation-z8">
			<ng-container matColumnDef="[=AuthenticationTable?cap_first]">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=AuthenticationTable?cap_first]')">[=AuthenticationTable?cap_first]</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("[=AuthenticationTable?cap_first]")}}:</span>
					{{ item.[=AuthenticationTable]Username }}
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="Permission">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Permission')">Permission </mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("Permission")}}:</span>
					{{ item.permissionName }}
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="actions">
				<mat-header-cell *matHeaderCellDef> Actions</mat-header-cell>
				<mat-cell *matCellDef="let item" (click)="$event.stopPropagation()"> 
					<button mat-button color="accent"(click)="delete(item)">{{(selectedAssociation && selectedAssociation.type == "ManyToMany") ? ('GENERAL.ACTIONS.DE-LINK' | translate) : ('GENERAL.ACTIONS.DELETE' | translate) }}</button>
				</mat-cell>
			</ng-container>
			<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
			<mat-row *matRowDef="let row; columns: displayedColumns;" (click)="openDetails(row)"></mat-row>
		</mat-table>
	</div>
</div>
