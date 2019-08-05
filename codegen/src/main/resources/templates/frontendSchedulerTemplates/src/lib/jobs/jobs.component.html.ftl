<mat-toolbar class="action-tool-bar" color="primary">

  <i class="material-icons">
    arrow_back
  </i>
  <span class="middle">{{'JOBS.TITLE' | translate}}</span>
  <i class="material-icons" (click)="add()">
    add
  </i>
</mat-toolbar>
<div class="container">
  <app-list-filters [columnsList]="columns" (onSearch)="applyFilter($event)"></app-list-filters>

  <mat-table matSort [dataSource]="dataSource" (onScroll)="onTableScroll()" appVirtualScroll class="mat-elevation-z8">

    <ng-container matColumnDef="jobName">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'JOBS.FIELDS.NAME' | translate}} </mat-header-cell>>
      <mat-cell *matCellDef="let job"> <a routerLink="/jobs/{{job.jobName}}/{{job.jobGroup}}">{{job.jobName}}</a>
      </mat-cell>
    </ng-container>

    <ng-container matColumnDef="jobGroup">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'JOBS.FIELDS.GROUP' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let job"> {{job.jobGroup}} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="jobClass">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'JOBS.FIELDS.CLASS' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let job"> {{job.jobClass}} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="actions">
      <mat-header-cell *matHeaderCellDef> {{'SCHEDULER-GENERAL.ACTIONS.ACTIONS' | translate}}</mat-header-cell>
      <mat-cell *matCellDef="let job;let i = index;">
        <!-- <button mat-button color="accent" (click)="triggerJob(job,i)">Trigger</button> -->
        <button mat-button color="accent" (click)="pauseJob(job, i)">{{'SCHEDULER-GENERAL.ACTIONS.PAUSE' | translate}}</button>
        <button mat-button color="accent" (click)="deleteJob(job, i)">{{'SCHEDULER-GENERAL.ACTIONS.DELETE' | translate}}</button>
      </mat-cell>
    </ng-container>


    <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
    <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
  </mat-table>

</div>