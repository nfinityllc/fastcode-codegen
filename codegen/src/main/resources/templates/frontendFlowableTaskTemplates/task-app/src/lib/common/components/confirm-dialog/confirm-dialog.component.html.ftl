<h1 mat-dialog-title>{{confirmTitle}}</h1>
<div mat-dialog-content>{{confirmMessage}}</div>
<div mat-dialog-actions>
  <button mat-button (click)="dialogRef.close(false)">{{'GENERAL.ACTION.CANCEL'| translate}}</button>
  <button mat-button (click)="dialogRef.close(true)">{{'GENERAL.ACTION.CONFIRM'| translate}}</button>
</div>