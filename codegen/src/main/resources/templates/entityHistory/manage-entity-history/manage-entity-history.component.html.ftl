<div class="container">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-flat-button (click)="onCancel()">
      Cancel </button>
    <span class="middle">Manage entity history</span>

    <button mat-flat-button (click)="manageEntityHistoryNgForm.ngSubmit.emit()" [disabled]="!manageEntityHistoryForm.valid || loading">
      Save </button>

  </mat-toolbar>
  <mat-card>
    <form [formGroup]="manageEntityHistoryForm" #manageEntityHistoryNgForm="ngForm" (ngSubmit)="onSubmit()" class="manage-entity-history-form">
      <div class="full-width">
        <mat-form-field [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <mat-select placeholder="Select entity" formControlName="entity">
            <mat-option *ngFor="let ent of entities" [value]="ent">
              {{ent}}
            </mat-option>
          </mat-select>
        </mat-form-field>

        <mat-form-field [ngClass]="{'medium-device-width': isMediumDeviceOrLess, 'large-device-width' : !isMediumDeviceOrLess}">
          <mat-select placeholder="Select property" formControlName="property">
            <mat-option *ngFor="let prop of properties" [value]="prop">
              {{prop}}
            </mat-option>
          </mat-select>
        </mat-form-field>
      </div>
    </form>
    <div class="full-width">
      <span fxFlex></span>
      <button mat-flat-button>
        Start
      </button>
      <button mat-flat-button>
        Stop
      </button>
    </div>
  </mat-card>
</div>