<div class="container">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-flat-button (click)="onCancel()">
      {{'SCHEDULER-GENERAL.ACTIONS.CANCEL' | translate}} </button>
    <span class="middle">{{'JOBS.TITLE' | translate}}</span>

    <button mat-flat-button (click)="jobNgForm.ngSubmit.emit()" [disabled]="!jobForm.valid || loading">
      {{'SCHEDULER-GENERAL.ACTIONS.SAVE' | translate}} </button>

  </mat-toolbar>
  <mat-card>
    <h2>New Job</h2>
    <form [formGroup]="jobForm" #jobNgForm="ngForm" (ngSubmit)="onSubmit()" class="job-form">
      <div class="full-width">
        <mat-form-field [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <input formControlName="jobName" matInput placeholder="{{'JOBS.FIELDS.NAME' | translate}}">
          <mat-error *ngIf="!jobForm.get('jobName').valid && jobForm.get('jobName').touched">{{'SCHEDULER-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>

        <mat-form-field [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <input placeholder="{{'JOBS.FIELDS.GROUP' | translate}}" formControlName="jobGroup" matInput [matAutocomplete]="auto">
          <mat-autocomplete #auto="matAutocomplete">
            <mat-option *ngFor="let group of filteredOptions | async" [value]="group">
              {{group}}
            </mat-option>
          </mat-autocomplete>
          <mat-error *ngIf="!jobForm.get('jobGroup').valid && jobForm.get('jobGroup').touched">{{'SCHEDULER-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>

        <mat-form-field [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <mat-select placeholder="{{'JOBS.FIELDS.CLASS-PLACEHOLDER' | translate}}" formControlName="jobClass">
            <mat-option *ngFor="let jc of jobClasses" [value]="jc">
              {{jc}}
            </mat-option>
          </mat-select>
          <mat-error *ngIf="!jobForm.get('jobClass').valid && jobForm.get('jobClass').touched">{{'SCHEDULER-GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>
        <span [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <mat-checkbox formControlName="isDurable">
            {{'JOBS.FIELDS.IS-DURABLE' | translate}}
          </mat-checkbox>
        </span>

        <mat-form-field [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <textarea formControlName="description" matInput placeholder="{{'JOBS.FIELDS.DESCRIPTION' | translate}}"></textarea>
          <mat-error *ngIf="!jobForm.get('description').valid && jobForm.get('description').touched">{{'SCHEDULER-GENERAL.ERRORS.LENGTH-EXCEDDING' | translate : {length : 80} }}</mat-error>
        </mat-form-field>

        <div class="full-width">
          <label style="margin-bottom: 10px">{{'JOBS.FIELDS.JOB-MAP-DATA' | translate}}
            <mat-icon (click)="addJobData()">add_circle</mat-icon>
          </label>
          <table mat-table [dataSource]="dataSource" class="mat-elevation-z8">

            <!--- these columns can be defined in any order.
                The actual rendered columns are set as a property on the row definition" -->

            <!-- Key Column -->
            <ng-container matColumnDef="key">
              <th mat-header-cell *matHeaderCellDef> {{'JOB-DATA.KEY' | translate}} </th>
              <td mat-cell *matCellDef="let element">
                <input matInput [(ngModel)]="element.dataKey" [ngModelOptions]="{standalone: true}">
              </td>
            </ng-container>

            <!-- Value Column -->
            <ng-container matColumnDef="value">
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
        </div>
      </div>
    </form>
  </mat-card>
</div>