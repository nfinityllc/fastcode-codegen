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
		<#list Fields as key,value>
		<#-- to exclude the duplicate fields(join columns) -->
		<#assign isJoinColumn = false>
		<#if Relationship?has_content>
		<#list Relationship as relationKey, relationValue>
		<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if joinDetails.joinColumn == key>
        <#assign isJoinColumn = true>
        </#if>
        </#if>
		</#if>
		</#list>
		</#list>
		</#if>
		<#if isJoinColumn == false>
		<#if value.fieldType == "Date">
		<ng-container matColumnDef="[=value.fieldName]">
			<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=value.fieldName]')"> [=value.fieldName] </mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("[=value.fieldName?cap_first]")}}:</span>
				{{item.[=value.fieldName] | date: defaultDateFormat}}
			</mat-cell>
		</ng-container>
		<#elseif value.fieldType?lower_case == "string" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
		<ng-container matColumnDef="[=value.fieldName]">
			<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=value.fieldName]')"> [=value.fieldName]</mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("[=value.fieldName?cap_first]")}}:</span>
				{{ item.[=value.fieldName] }}
			</mat-cell>
		</ng-container>
		</#if>
		</#if>
		</#list>
		<#list Relationship as relationKey, relationValue>
		<#if relationValue.relation == "ManyToOne">
		<#if DescriptiveField[relationValue.eName]??>
		<ng-container matColumnDef="[=relationValue.eName]">
			<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=relationValue.eName]')">[=relationValue.eName] </mat-header-cell>
			<mat-cell *matCellDef="let item">
				<span class="mobile-label">{{getMobileLabelForField("[=relationValue.eName]")}}:</span>
				{{ item.[=relationValue.eName?uncap_first][=DescriptiveField[relationValue.eName].fieldName?cap_first] }}
			</mat-cell>
		</ng-container>
		</#if>
		</#if>
		</#list>
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
