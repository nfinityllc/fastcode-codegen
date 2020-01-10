<div class="container1">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-button class="left" (click)="onCancel()">{{'GENERAL.ACTION.CANCEL' | translate}} </button>
    <span>{{'TASK.INVOLVEMENT.TITLE' | translate}}</span>
    <button mat-button class="right" (click)="onSelect()">{{'GENERAL.ACTION.SELECT' | translate}}</button>
  </mat-toolbar>

  <form class="search-form">
		<mat-form-field class="form-field">
			<input matInput placeholder="Search" (input)="onSearch($event.target.value)">
		</mat-form-field>
	</form>

  <mat-dialog-content>
    <mat-selection-list>
      <mat-list-option *ngFor="let item of users" [value]="item">
        <mat-icon mat-list-icon>perm_identity</mat-icon>
        <h4 mat-line>{{item.fullName}}</h4>
        <mat-divider></mat-divider>
      </mat-list-option>
    </mat-selection-list>
  </mat-dialog-content>
</div>