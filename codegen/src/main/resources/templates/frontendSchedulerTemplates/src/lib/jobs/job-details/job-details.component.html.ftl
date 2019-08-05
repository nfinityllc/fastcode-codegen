<mat-toolbar class="action-tool-bar" color="primary">
  <button mat-flat-button (click)="back()">
    {{'SCHEDULER-GENERAL.ACTIONS.BACK' | translate}} </button>
  <span class="middle">{{'JOBS.TITLE' | translate}}</span>

  <button mat-flat-button (click)="jobNgForm.ngSubmit.emit()" [disabled]="!jobForm.valid || loading">
    {{'SCHEDULER-GENERAL.ACTIONS.SAVE' | translate}} </button>

</mat-toolbar>
<mat-card>
  <mat-card-content>
    <h2>Job Details</h2>
    <form [formGroup]="jobForm" #jobNgForm="ngForm" (ngSubmit)="onSubmit()" class="job-form">
      <!-- Job Name-->
      <mat-form-field>
        <input formControlName="jobName" matInput placeholder="{{'JOBS.FIELDS.NAME' | translate}}">
        <mat-error *ngIf="!jobForm.get('jobName').valid && jobForm.get('jobName').touched">{{'SCHEDULER-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
      </mat-form-field>

      <!-- Job Group-->
      <mat-form-field>
        <input placeholder="{{'JOBS.FIELDS.GROUP' | translate}}" formControlName="jobGroup" matInput [matAutocomplete]="auto">
        <mat-autocomplete #auto="matAutocomplete">
          <mat-option *ngFor="let group of filteredOptions | async" [value]="group">
            {{group}}
          </mat-option>
        </mat-autocomplete>
        <mat-error *ngIf="!jobForm.get('jobGroup').valid && jobForm.get('jobGroup').touched">{{'SCHEDULER-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
      </mat-form-field>

      <!-- Job Class-->
      <mat-form-field>
        <mat-select placeholder="{{'JOBS.FIELDS.CLASS-PLACEHOLDER' | translate}}" [compareWith]="compareFn" formControlName="jobClass">
          <mat-option *ngFor="let jobClass of jobClasses" [value]="jobClass">
            {{jobClass}}
          </mat-option>
        </mat-select>
        <mat-error *ngIf="!jobForm.get('jobClass').valid && jobForm.get('jobClass').touched">{{'SCHEDULER-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
      </mat-form-field>

      <!-- Previous Fire Time -->
      <mat-form-field>
        <input matInput [(ngModel)]="job.lastExecutionTime" placeholder="{{'JOBS.FIELDS.LAST-EXECUTION-TIME' | translate}}" [ngModelOptions]="{standalone: true}">
      </mat-form-field>

      <!-- Next Fire Time-->
      <mat-form-field>
        <input matInput [(ngModel)]="job.nextExecutionTime" placeholder="{{'JOBS.FIELDS.NEXT-EXECUTION-TIME' | translate}}" [ngModelOptions]="{standalone: true}">
      </mat-form-field>

      <!-- is Durable -->
      <div>
        <input matInput style="display:none">
        <mat-checkbox [checked]="job.isDurable" class="example-margin" formControlName="isDurable">
          {{'JOBS.FIELDS.IS-DURABLE' | translate}}
        </mat-checkbox>
      </div>

      <!-- description -->
      <mat-form-field>
        <textarea formControlName="jobDescription" matInput placeholder="{{'JOBS.FIELDS.DESCRIPTION' | translate}}"></textarea>
        <mat-error *ngIf="!jobForm.get('jobDescription').valid && jobForm.get('jobDescription').touched">Description cannot be more than 80 characters</mat-error>
      </mat-form-field>

      <mat-tab-group [disableRipple]="true">
        <!-- Job Data-->
        <mat-tab label="{{'JOBS.FIELDS.JOB-MAP-DATA' | translate}}">
          <label style="margin-bottom: 10px">{{'JOB-DATA.NEW-VALUE' | translate}}
            <mat-icon (click)="addJobData()">add_circle</mat-icon>
          </label>
          <table mat-table [dataSource]="dataSourceJobData" class="mat-elevation-z8 full-width">

            <!--- Note that these columns can be defined in any order.
                        The actual rendered columns are set as a property on the row definition" -->

            <!-- Key Column -->
            <ng-container matColumnDef="position">
              <th mat-header-cell *matHeaderCellDef> {{'JOB-DATA.KEY' | translate}} </th>
              <td mat-cell *matCellDef="let element">
                <input matInput [(ngModel)]="element.dataKey" [ngModelOptions]="{standalone: true}">
              </td>
            </ng-container>

            <!-- Value Column -->
            <ng-container matColumnDef="name">
              <th mat-header-cell *matHeaderCellDef> {{'JOB-DATA.VALUE' | translate}} </th>
              <td mat-cell *matCellDef="let element">
                <input matInput [(ngModel)]="element.dataValue" [ngModelOptions]="{standalone: true}">
              </td>
            </ng-container>

            <!-- Actions -->
            <ng-container matColumnDef="actions">
              <th mat-header-cell *matHeaderCellDef> {{'SCHEDULER-GENERAL.ACTIONS.ACTIONS' | translate}} </th>
              <td mat-cell *matCellDef="let element; let i = index;">
                <mat-icon (click)="removeJobData(i)">remove_circle</mat-icon>
              </td>
            </ng-container>

            <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
            <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
          </table>
        </mat-tab>

        <!-- Triggers -->
        <mat-tab label="Triggers">
          <table mat-table [dataSource]="dataSourceTriggers" class="mat-elevation-z8 full-width">

            <!-- Trigger Name Column -->
            <ng-container matColumnDef="triggerName">
              <th mat-header-cell *matHeaderCellDef> Name </th>
              <td mat-cell *matCellDef="let element">
                {{element.triggerName}}
              </td>
            </ng-container>

            <!-- Trigger Group Column -->
            <ng-container matColumnDef="triggerGroup">
              <th mat-header-cell *matHeaderCellDef> Trigger Group </th>
              <td mat-cell *matCellDef="let element">
                {{element.triggerGroup}}
              </td>
            </ng-container>

            <!-- Trigger Type Column -->
            <ng-container matColumnDef="type">
              <th mat-header-cell *matHeaderCellDef> Type </th>
              <td mat-cell *matCellDef="let element">
                {{element.type}}
              </td>
            </ng-container>

            <!-- Trigger Start Time Column -->
            <ng-container matColumnDef="startTime">
              <th mat-header-cell *matHeaderCellDef> Start Time </th>
              <td mat-cell *matCellDef="let element">
                {{element.startTime}}
              </td>
            </ng-container>

            <!-- Trigger End Time Column -->
            <ng-container matColumnDef="endTime">
              <th mat-header-cell *matHeaderCellDef> End Time </th>
              <td mat-cell *matCellDef="let element">
                {{element.endTime}}
              </td>
            </ng-container>

            <!-- Trigger Previous Fire Time Column -->
            <ng-container matColumnDef="lastExecutionTime">
              <th mat-header-cell *matHeaderCellDef> Previous Fire Time </th>
              <td mat-cell *matCellDef="let element">
                {{element.lastExecutionTime}}
              </td>
            </ng-container>

            <!-- Trigger Next Fire Time Column -->
            <ng-container matColumnDef="nextExecutionTime">
              <th mat-header-cell *matHeaderCellDef> Next Fire Time </th>
              <td mat-cell *matCellDef="let element">
                {{element.nextExecutionTime}}
              </td>
            </ng-container>

            <tr mat-header-row *matHeaderRowDef="displayedColumnsTriggers"></tr>
            <tr mat-row *matRowDef="let row; columns: displayedColumnsTriggers;"></tr>
          </table>
        </mat-tab>

        <!-- Execution History -->
        <mat-tab label="Execution History">
          <table mat-table [dataSource]="dataSourceExecutionHistory" class="mat-elevation-z8 full-width">

            <!-- Trigger Name Column -->
            <ng-container matColumnDef="triggerName">
              <th mat-header-cell *matHeaderCellDef> Name </th>
              <td mat-cell *matCellDef="let element">
                {{element.triggerName}}
              </td>
            </ng-container>

            <!-- Trigger Group Column -->
            <ng-container matColumnDef="duration">
              <th mat-header-cell *matHeaderCellDef> Duration </th>
              <td mat-cell *matCellDef="let element">
                {{element.duration}}
              </td>
            </ng-container>

            <!-- Execution Status Column -->
            <ng-container matColumnDef="status">
              <th mat-header-cell *matHeaderCellDef> Status </th>
              <td mat-cell *matCellDef="let element">
                {{element.status}}
              </td>
            </ng-container>

            <!-- Trigger Group Column -->
            <ng-container matColumnDef="fireTime">
              <th mat-header-cell *matHeaderCellDef> Fire Time</th>
              <td mat-cell *matCellDef="let element">
                {{element.fireTime}}
              </td>
            </ng-container>

            <!-- Trigger Group Column -->
            <ng-container matColumnDef="finishedTime">
              <th mat-header-cell *matHeaderCellDef> Finished time</th>
              <td mat-cell *matCellDef="let element">
                {{element.finishedTime}}
              </td>
            </ng-container>

            <!-- Trigger Group Column -->
            <ng-container matColumnDef="triggerGroup">
              <th mat-header-cell *matHeaderCellDef> Trigger Group </th>
              <td mat-cell *matCellDef="let element">
                {{element.triggerGroup}}
              </td>
            </ng-container>

            <tr mat-header-row *matHeaderRowDef="displayedColumnsExecutionHistory"></tr>
            <tr mat-row *matRowDef="let row; columns: displayedColumnsExecutionHistory;"></tr>
          </table>
        </mat-tab>
      </mat-tab-group>
    </form>
  </mat-card-content>
</mat-card>