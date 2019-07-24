<div class="container1">
  <mat-toolbar class="action-tool-bar" color="primary">
    <button mat-flat-button (click)="onCancel()">
      {{'GENERAL.ACTION.CANCEL' | translate}}
    </button>
    <span class="middle">New comment</span>

    <button mat-flat-button (click)="commentNgForm.ngSubmit.emit()" [disabled]="!commentForm.valid || loading">
      {{'TASK.ACTION.ADD-COMMENT-CONFIRM' | translate}}
    </button>

  </mat-toolbar>
  <mat-card>
    <form [formGroup]="commentForm" #commentNgForm="ngForm" (ngSubmit)="onSubmit()" class="comment-form">
      <div class="full-width">
        <mat-form-field class="full-width">
          <textarea formControlName="comment" matInput placeholder="{{ 'TASK.MESSAGE.NEW-COMMENT-PLACEHOLDER' | translate}}"></textarea>
          <mat-error *ngIf="commentForm.get('comment').errors && commentForm.get('comment').errors['required'] && commentForm.get('comment').touched">Comment
            {{'GENERAL.ERROR.REQUIRED' | translate}}</mat-error>
          <mat-error *ngIf="commentForm.get('comment').errors && commentForm.get('comment').errors['maxlength']">Length
            cannot be greater than {{commentForm.get('comment').errors.maxlength.requiredLength}}</mat-error>
        </mat-form-field>
      </div>
    </form>
  </mat-card>
</div>