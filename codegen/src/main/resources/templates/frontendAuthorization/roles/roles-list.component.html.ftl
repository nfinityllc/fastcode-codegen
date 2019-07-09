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
		
		<ng-container matColumnDef="id">
			<mat-header-cell mat-sort-header *matHeaderCellDef> id</mat-header-cell>
			<mat-cell *matCellDef="let item">
			<span class="mobile-label">{{getMobileLabelForField("id")}}:</span>
			<a routerLink="/roles/{{item.id}}">
				{{ item.id}}
			</a>
			</mat-cell>
		</ng-container>   
		<ng-container matColumnDef="displayName">
			<mat-header-cell mat-sort-header *matHeaderCellDef> displayName</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("DisplayName")}}:</span>
				{{ item.displayName }}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="name">
			<mat-header-cell mat-sort-header *matHeaderCellDef> name</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("Name")}}:</span>
				{{ item.name }}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="actions">
			<mat-header-cell *matHeaderCellDef> Actions</mat-header-cell>
			<mat-cell *matCellDef="let item"> 
				<button mat-button color="accent"(click)="delete(item)">{{(selectedAssociation && selectedAssociation.type == "ManyToMany")?'De-link':'Delete'}}</button>
			</mat-cell>
		</ng-container>
		<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
		<mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
		</mat-table>
	</div>
</div>
