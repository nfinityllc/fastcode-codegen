<h1 mat-dialog-title>Confirm</h1>
<div mat-dialog-content>{{confirmMessage}}</div>
<div mat-dialog-actions>
  <button mat-button (click)="dialogRef.close(true)">Confirm</button>
  <button mat-button (click)="dialogRef.close(false)">Cancel</button>
</div>
