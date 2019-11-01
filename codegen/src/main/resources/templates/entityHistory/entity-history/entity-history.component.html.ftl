<mat-toolbar class="action-tool-bar" color="primary">

  <i class="material-icons">
    arrow_back
  </i>
  <span class="middle">{{'MainNav.EntityHistory' | translate }}</span>
  <i class="material-icons" (click)="add()">
    add
  </i>
</mat-toolbar>

<div class="example-container mat-elevation-z8">
  <mat-card class="card-class">
    <form [formGroup]="basicFilterForm" class="filter-form">
      <div class="full-width">

        <mat-form-field>
          <input formControlName="from" matInput [matDatepicker]="startDatePicker" placeholder="Enter Start Date">
          <mat-datepicker-toggle matSuffix [for]="startDatePicker"></mat-datepicker-toggle>
          <mat-datepicker #startDatePicker></mat-datepicker>
        </mat-form-field>

        <mat-form-field>
          <input formControlName="to" matInput [matDatepicker]="endDatePicker" placeholder="Enter End Date">
          <mat-datepicker-toggle matSuffix [for]="endDatePicker"></mat-datepicker-toggle>
          <mat-datepicker #endDatePicker></mat-datepicker>
        </mat-form-field>
        
        <mat-form-field>
          <input matInput disabled placeholder="Author" formControlName="author">
          <mat-icon matSuffix (click)="$event.preventDefault();selectAuthor()">list</mat-icon>
        </mat-form-field>

      </div>
    </form>
    <button mat-flat-button color="primary" (click)="applyFilter()">
      {{'LIST-FILTERS.SEARCH-BUTTON-TEXT' | translate}}
    </button>
  </mat-card>
  <mat-table [dataSource]="dataSource" (onScroll)="onTableScroll()" appVirtualScroll class="history-table">

    <ng-container matColumnDef="entity">
      <mat-header-cell *matHeaderCellDef> Entity </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Entity:</span>
        {{entityHistoryEntry.globalId.entity}}
      </mat-cell>>
    </ng-container>

    <ng-container matColumnDef="cdoId">
      <mat-header-cell *matHeaderCellDef> Entity Id </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Entity Id:</span>
        <a routerLink=""> {{entityHistoryEntry.globalId.cdoId}} </a>
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="changeType">
      <mat-header-cell *matHeaderCellDef> Change type </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Change type:</span>
        {{entityHistoryEntry.changeType}}
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="author">
      <mat-header-cell *matHeaderCellDef> Change author </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Change author:</span>
        {{entityHistoryEntry.commitMetadata.author}}
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="commitDate">
      <mat-header-cell *matHeaderCellDef> Change date </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Change date:</span>
        {{entityHistoryEntry.commitMetadata.commitDate | date:'medium'}}
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="propertyName">
      <mat-header-cell *matHeaderCellDef> Property name </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Property name</span>
        {{entityHistoryEntry.property}}
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="previousValue">
      <mat-header-cell *matHeaderCellDef> Previous value </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Previous value</span>
        {{entityHistoryEntry.left}}
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="currentValue">
      <mat-header-cell *matHeaderCellDef> Current value </mat-header-cell>
      <mat-cell *matCellDef="let entityHistoryEntry">
        <span class="mobile-label">Current value</span>
        {{entityHistoryEntry.right}}
      </mat-cell>
    </ng-container>

    <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>

    <mat-row *matRowDef="let row; columns: displayedColumns"></mat-row>


  </mat-table>
</div>