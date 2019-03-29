<mat-toolbar class="action-tool-bar" color="primary">
  <i class="material-icons">
		arrow_back
	</i>
	<span class="middle">{{title}}</span>
	<i class="material-icons" (click)="addNew()">
		add
	</i>
</mat-toolbar>
<div class="container">
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<table mat-table [dataSource]="items" class="mat-elevation-z8">
	<#list Fields as key,value>
	<#if value.fieldName?lower_case == "id">                 
	<#elseif value.fieldType == "Date">
	<ng-container matColumnDef="${value.fieldName}">
		<th mat-header-cell *matHeaderCellDef> ${value.fieldName} </th>
		<td mat-cell *matCellDef="let item"> {{item.${value.fieldName} | date:'short'}} </td>
	</ng-container>
	<#else>
	<ng-container matColumnDef="${value.fieldName}">
		<th mat-header-cell *matHeaderCellDef> ${value.fieldName}</th>
		<td mat-cell *matCellDef="let item">
		<a routerLink="/${ApiPath}/{{item.id}}">{{ item.${value.fieldName} }}</a>
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