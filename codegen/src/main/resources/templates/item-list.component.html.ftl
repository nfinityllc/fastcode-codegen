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
	<button mat-button<#if AuthenticationType!="none"> [disabled]="!IsCreatePermission"</#if> (click)="addNew()">
 		{{'GENERAL.ACTIONS.ADD' | translate}} </button>
</mat-toolbar>
<div class="list-container">
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<div class="table-container" (onScroll)="onTableScroll()" appVirtualScroll>
		<mat-table matSort [dataSource]="items" class="mat-elevation-z8">
			<#list Fields as key,value>
			<#-- to exclude the duplicate fields(join columns) -->
			<#assign isJoinColumn = false>
			<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
			<#list relationValue.joinDetails as joinDetails>
	        <#if joinDetails.joinEntityName == relationValue.eName>
	        <#if joinDetails.joinColumn??>
	        <#if joinDetails.joinColumn == key>
	        <#assign isJoinColumn = true>
	        </#if>
	        </#if>
			</#if>
			</#list>
			</#if>
			</#list>
			</#if>
			<#-- to exclude the password field in case of user provided "User" table -->
			<#assign isPasswordField = false>
			<#if AuthenticationType != "none" && ClassName == AuthenticationTable>  
    		<#if AuthenticationFields?? && AuthenticationFields.Password.fieldName == value.fieldName>
			<#assign isPasswordField = true>
			</#if>
			</#if>
			<#if isJoinColumn == false && isPasswordField == false>
			<#if value.fieldType == "Date">
			<ng-container matColumnDef="[=value.fieldName]">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=value.fieldName]')"> {{getFieldLabel("[=value.fieldName?cap_first]")}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("[=value.fieldName?cap_first]")}}:</span>
					{{item.[=value.fieldName] | date: defaultDateFormat}}
				</mat-cell>
			</ng-container>
			<#elseif value.fieldType?lower_case == "string" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
			<ng-container matColumnDef="[=value.fieldName]">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=value.fieldName]')"> {{getFieldLabel("[=value.fieldName?cap_first]")}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("[=value.fieldName?cap_first]")}}:</span>
					{{ item.[=value.fieldName] }}
				</mat-cell>
			</ng-container>
			</#if>
    		</#if>
			</#list>
			<#list Relationship as relationKey, relationValue>
			<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
			<#if DescriptiveField[relationValue.eName]?? && DescriptiveField[relationValue.eName].description??>
			<ng-container matColumnDef="[=relationValue.eName]">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=relationValue.eName]')"> {{getFieldLabel("[=relationValue.eName?cap_first]")}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("[=relationValue.eName?cap_first]")}}:</span>
					{{ item.[=DescriptiveField[relationValue.eName].description?uncap_first] }}
				</mat-cell>
			</ng-container>
			</#if>
			</#if>
			</#list>
			<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
			<ng-container matColumnDef="Role">
				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Role')"> {{getFieldLabel("Role")}}</mat-header-cell>
				<mat-cell *matCellDef="let item">
					<span class="mobile-label">{{getFieldLabel("Role")}}:</span>
					{{ item.roleDescriptiveField }}
				</mat-cell>
			</ng-container>
			</#if>
			<ng-container matColumnDef="actions">
				<mat-header-cell *matHeaderCellDef> {{getFieldLabel("Actions")}}</mat-header-cell>
				<mat-cell *matCellDef="let item" (click)="$event.stopPropagation()"> 
					<button mat-button<#if AuthenticationType!="none"> [disabled]="!IsDeletePermission"</#if> color="accent" (click)="delete(item)">{{'GENERAL.ACTIONS.DELETE' | translate }}</button>
				</mat-cell>
			</ng-container>
			<mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
			<mat-row *matRowDef="let row; columns: displayedColumns;" (click)="openDetails(row)"></mat-row>
		</mat-table>
	</div>
</div>
