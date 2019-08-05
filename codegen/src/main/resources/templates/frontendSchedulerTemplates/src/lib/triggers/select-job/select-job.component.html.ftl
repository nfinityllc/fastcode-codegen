<mat-toolbar class="action-tool-bar" color="primary">
  <button mat-flat-button (click)="onCancel()">
    {{'SCHEDULER-GENERAL.ACTIONS.CANCEL' | translate}} </button>
  <span class="middle">{{'TRIGGERS.SELECT-JOB' | translate}}</span>

  <button mat-flat-button> </button>

</mat-toolbar>
<div class="container">
<!-- <label>Select Job</label> -->
<table mat-table [dataSource]="jobs" class="mat-elevation-z8">

  <!-- name Column -->
  <ng-container matColumnDef="jobName">
    <th mat-header-cell *matHeaderCellDef> {{'JOBS.FIELDS.NAME' | translate}} </th>
    <td mat-cell *matCellDef="let job"> {{job.jobName}} </td>
  </ng-container>

  <ng-container matColumnDef="jobGroup">
    <th mat-header-cell *matHeaderCellDef> {{'JOBS.FIELDS.GROUP' | translate}} </th>
    <td mat-cell *matCellDef="let job"> {{job.jobGroup}} </td>
  </ng-container>
  <ng-container matColumnDef="jobClass">
    <th mat-header-cell *matHeaderCellDef> {{'JOBS.FIELDS.CLASS' | translate}} </th>
    <td mat-cell *matCellDef="let job"> {{job.jobClass}} </td>
  </ng-container>

  <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
  <tr mat-row *matRowDef="let row; columns: displayedColumns;" (click)="selectJob(row)"></tr>
</table>

</div>