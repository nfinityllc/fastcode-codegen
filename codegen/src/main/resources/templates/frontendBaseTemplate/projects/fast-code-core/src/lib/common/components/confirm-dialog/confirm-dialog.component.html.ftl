<h1 mat-dialog-title>{{'CONFIRM-DIALOG-TITLE' | translate}}</h1>
<div mat-dialog-content>{{confirmMessage}}</div>
<div mat-dialog-actions>
  <button mat-button (click)="dialogRef.close(true)">{{'FASTCODE-CORE-GENERAL.ACTIONS.CONFIRM' | translate}}</button>
  <button mat-button (click)="dialogRef.close(false)">{{'FASTCODE-CORE-GENERAL.ACTIONS.CANCEL' | translate}}</button>
</div>