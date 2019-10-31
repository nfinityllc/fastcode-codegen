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
				<mat-header-cell mat-sort-header *matHeaderCellDef> {{getFieldLabel("TemplateName")}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("TemplateName")}}:</span>
					<a routerLink="./{{item.id}}" >{{item.templateName}} </a>
				</mat-cell>
			</ng-container>
			<ng-container matColumnDef="subject">
				<mat-header-cell mat-sort-header *matHeaderCellDef> {{getFieldLabel("Subject")}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("Subject")}}:</span>
					{{ item.subject }}
				</mat-cell>
			</ng-container>
		
		<ng-container matColumnDef="category">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{getFieldLabel("Category")}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getFieldLabel("Category")}}:</span>
				{{ item.category }}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="lastModifierUserId">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{getFieldLabel("LastModifierUserId")}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getFieldLabel("LastModifierUserId")}}:</span>
				{{ item.lastModifierUserId }}
			</mat-cell>
		</ng-container>
		<ng-container matColumnDef="lastModificationTime">
			<mat-header-cell mat-sort-header *matHeaderCellDef> {{getFieldLabel("LastModificationTime")}}</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getFieldLabel("LastModificationTime")}}:</span>
				{{item.lastModificationTime | date:'short'}}
			</mat-cell>
		</ng-container>	
		
		<ng-container matColumnDef="actions">
			<mat-header-cell *matHeaderCellDef> {{getFieldLabel("Actions")}}</mat-header-cell>
			<mat-cell *matCellDef="let item"> 
				<button mat-button color="accent" [disabled]="!IsDeletePermission" (click)="delete(item)">{{(selectedAssociation && selectedAssociation.type == "ManyToMany")?'De-link':'Delete'}}</button>
			</mat-cell>
		</ng-container>
		<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
		<mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
		</mat-table>
	</div>
</div>
