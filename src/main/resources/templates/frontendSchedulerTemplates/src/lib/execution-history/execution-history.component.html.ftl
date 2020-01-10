<mat-toolbar class="action-tool-bar" color="primary">

  <i class="material-icons">
    arrow_back
  </i>
  <span class="middle">{{'EXECUTION-HISTORY.TITLE' | translate}}</span>
  <i class="material-icons">
    add
  </i>
</mat-toolbar>
<div class="list-container">
  <app-list-filters [columnsList]="columns" (onSearch)="applyFilter($event)"></app-list-filters>

  <mat-table class="mat-elevation-z8" matSort (onScroll)="onTableScroll()" appVirtualScroll [dataSource]="dataSource">

    <div *ngFor="let column of selectedColumns">
      <ng-container matColumnDef="{{column.column}}">
        <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="column['sort'] ? false: true">
          {{column.label}} </mat-header-cell>
        <div *ngIf="column.type != 'Date'">
          <mat-cell *matCellDef="let element">
            <span class="mobile-label">{{column.column}}</span>
            {{element[column.column]}}
          </mat-cell>
        </div>

        <div *ngIf="column.type == 'Date'">
          <mat-cell *matCellDef="let element">
            <span class="mobile-label">{{column.column}}</span>
            {{element[column.column] | date:'medium'}}
          </mat-cell>
        </div>

      </ng-container>
    </div>

    <mat-header-row *matHeaderRowDef="displayedColumnsExecutionHistory"></mat-header-row>
    <mat-row *matRowDef="let row; columns: displayedColumnsExecutionHistory;"></mat-row>
  </mat-table>
</div>