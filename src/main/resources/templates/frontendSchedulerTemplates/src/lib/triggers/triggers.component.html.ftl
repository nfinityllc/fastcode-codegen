<mat-toolbar class="action-tool-bar" color="primary">

  <i class="material-icons">
    arrow_back
  </i>
  <span class="middle">{{'TRIGGERS.TITLE' | translate}}</span>
  <i class="material-icons" (click)="add()">
    add
  </i>
</mat-toolbar>
<div class="list-container">
  <app-list-filters [columnsList]="columns" (onSearch)="applyFilter($event)"></app-list-filters>
  <mat-table matSort [dataSource]="dataSource" (onScroll)="onTableScroll()" appVirtualScroll class="mat-elevation-z8">

    <!-- name Column -->
    <ng-container matColumnDef="triggerName">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.NAME' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"><a routerLink="/triggers/{{trigger.triggerName}}/{{trigger.triggerGroup}}">{{trigger.triggerName}}</a>
      </mat-cell>
    </ng-container>

    <!-- name Column -->
    <ng-container matColumnDef="triggerGroup">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.GROUP' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger">{{trigger.triggerGroup}} </mat-cell>
    </ng-container>

    <!-- name Column -->
    <ng-container matColumnDef="jobName">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.JOB-NAME' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger">{{trigger.jobName}} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="jobGroup">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.JOB-GROUP' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"> {{trigger.jobGroup}} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="type">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.TYPE' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"> {{trigger.triggerType}} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="nextExecutionTime">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.NEXT-EXECUTION-TIME' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"> {{ trigger.nextExecutionTime | date:'medium' }} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="lastExecutionTime">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.LAST-EXECUTION-TIME' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"> {{trigger.lastExecutionTime | date:'medium' }} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="startTime">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.START-TIME' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"> {{trigger.startTime | date:'medium' }} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="endTime">
      <mat-header-cell *matHeaderCellDef mat-sort-header> {{'TRIGGERS.FIELDS.END-TIME' | translate}} </mat-header-cell>
      <mat-cell *matCellDef="let trigger"> {{trigger.endTime | date:'medium' }} </mat-cell>
    </ng-container>

    <ng-container matColumnDef="actions">
      <mat-header-cell *matHeaderCellDef> {{'SCHEDULER-GENERAL.ACTIONS.ACTIONS' | translate}}</mat-header-cell>
      <mat-cell *matCellDef="let trigger">
        <button mat-button color="accent" (click)="pauseTrigger(trigger)">{{'SCHEDULER-GENERAL.ACTIONS.PAUSE' | translate}}</button>
        <button mat-button color="accent" (click)="deleteTrigger(trigger)">{{'SCHEDULER-GENERAL.ACTIONS.DELETE' | translate}}</button>
      </mat-cell>
    </ng-container>


    <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
    <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
  </mat-table>

</div>