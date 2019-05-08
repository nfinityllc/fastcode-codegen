<mat-toolbar class="action-tool-bar" color="primary">
	<span *ngIf="!selectedAssociation"></span>
	<span *ngIf="selectedAssociation">
		<span routerLink="/{{selectedAssociation.table}}/{{selectedAssociation.column.value}}">
			<i class="material-icons">arrow_back</i>
			<span *ngFor="let item of items; let i = index">
				<span *ngIf="i == 0">
					/{{item[selectedAssociation.descriptiveField]}}
				</span>
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
		<table mat-table [dataSource]="items" class="mat-elevation-z8">
		
		<ng-container matColumnDef="id">
			<th mat-header-cell *matHeaderCellDef> id</th>
			<td mat-cell *matCellDef="let item">
			<a routerLink="/[=ApiPath]/{{item.id}}">{{ item.id}}</a>
			</td>
		</ng-container>   
		<#list Fields as key,value>
		<#if value.fieldName?lower_case == "id">
		<#elseif value.fieldType == "Date">
		<ng-container matColumnDef="[=value.fieldName]">
			<th mat-header-cell *matHeaderCellDef> [=value.fieldName] </th>
			<td mat-cell *matCellDef="let item"> {{item.[=value.fieldName] | date:'short'}} </td>
		</ng-container>
		<#elseif value.fieldType?lower_case == "string" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "int">
		<ng-container matColumnDef="[=value.fieldName]">
			<th mat-header-cell *matHeaderCellDef> [=value.fieldName]</th>
			<td mat-cell *matCellDef="let item">
			{{ item.[=value.fieldName] }}
			</td>
		</ng-container>
		</#if> 
		</#list>
		<ng-container matColumnDef="actions">
			<th mat-header-cell *matHeaderCellDef> Actions</th>
			<td mat-cell *matCellDef="let item"> 
				<button mat-button color="accent"(click)="delete(item)">{{selectedAssociation?'De-link':'Delete'}}</button>
			</td>
		</ng-container>
		<tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
		<tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
		</table>
	</div>
</div>
