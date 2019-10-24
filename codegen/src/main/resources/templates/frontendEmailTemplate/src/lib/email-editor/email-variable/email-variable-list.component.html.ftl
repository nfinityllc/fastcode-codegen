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
			<ng-container matColumnDef="propertyName">
				<mat-header-cell mat-sort-header *matHeaderCellDef> Property Name</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("Propertyname")}}:</span>
					
					<a routerLink="./{{item.id}}">
						{{ item.propertyName }}
					</a>
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="propertyType">
				<mat-header-cell mat-sort-header *matHeaderCellDef> Property Type</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getMobileLabelForField("Propertytype")}}:</span>
					{{ item.propertyType }}
				</mat-cell>
			</ng-container>
		
		<ng-container matColumnDef="lastModificationTime">
			<mat-header-cell mat-sort-header *matHeaderCellDef> Modified Date </mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("Lastmodificationtime")}}:</span>
				{{item.lastModificationTime | date:'short'}}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="lastModifierUserId">
			<mat-header-cell mat-sort-header *matHeaderCellDef> Modified User</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("Lastmodifieruserid")}}:</span>
				{{ item.lastModifierUserId }}
			</mat-cell>
		</ng-container>
		
		<ng-container matColumnDef="actions">
			<mat-header-cell *matHeaderCellDef> Actions</mat-header-cell>
			<mat-cell *matCellDef="let item"> 
				<button mat-button color="accent" [disabled]="!IsDeletePermission" (click)="delete(item)">{{(selectedAssociation && selectedAssociation.type == "ManyToMany")?'De-link':'Delete'}}</button>
			</mat-cell>
		</ng-container>
		<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
		<mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
		</mat-table>
	</div>
</div>
