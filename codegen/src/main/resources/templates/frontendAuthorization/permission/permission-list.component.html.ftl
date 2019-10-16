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
						<ng-container matColumnDef="displayName">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('displayName')"> displayName</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("DisplayName")}}:</span>
					{{ item.displayName }}
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="id">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('id')"> id</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("Id")}}:</span>
					{{ item.id }}
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="name">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('name')"> name</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("Name")}}:</span>
					{{ item.name }}
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
