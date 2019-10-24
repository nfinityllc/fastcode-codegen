<mat-toolbar class="action-tool-bar" color="primary">

  <i class="material-icons">
    arrow_back
  </i>
  <span class="middle"> {{'EXECUTING-JOBS.TITLE' | translate}}</span>
  <i class="material-icons">
    add
  </i>
</mat-toolbar>
<div class="list-container">
  <table mat-table [dataSource]="executingJobs" class="mat-elevation-z8 full-width">

    <!-- Trigger Name Column -->
    <ng-container matColumnDef="triggerName">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.TRIGGER-NAME' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.triggerName}}
      </td>
    </ng-container>

    <!-- Trigger Group Column -->
    <ng-container matColumnDef="triggerGroup">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.TRIGGER-GROUP' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.triggerGroup}}
      </td>
    </ng-container>
    
    <!-- Job Name Column -->
    <ng-container matColumnDef="jobName">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.JOB-NAME' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.jobName}}
      </td>
    </ng-container>

    <!-- Job Group Column -->
    <ng-container matColumnDef="jobGroup">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.JOB-GROUP' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.jobGroup}}
      </td>
    </ng-container>

    <!-- Job class Column -->
    <ng-container matColumnDef="jobClass">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.JOB-CLASS' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.jobClass}}
      </td>
    </ng-container>

    <!-- Execution Status Column -->
    <ng-container matColumnDef="status">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.STATUS' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.status}}
      </td>
    </ng-container>

    <!-- Fire Time Column -->
    <ng-container matColumnDef="fireTime">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.FIRE-TIME' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.fireTime}}
      </td>
    </ng-container>

    <!-- Next Fire Time Column -->
    <ng-container matColumnDef="nextExecutionTime">
      <th mat-header-cell *matHeaderCellDef> {{'EXECUTING-JOBS.FIELDS.NEXT-FIRE-TIME' | translate}} </th>
      <td mat-cell *matCellDef="let element">
        {{element.nextExecutionTime}}
      </td>
    </ng-container>

    <tr mat-header-row *matHeaderRowDef="displayedColumnsExecutingJobs"></tr>
    <tr mat-row *matRowDef="let row; columns: displayedColumnsExecutingJobs;"></tr>
  </table>

</div>