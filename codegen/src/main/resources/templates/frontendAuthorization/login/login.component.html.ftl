<div class="container">
    
    <div class="item-form-container"> 
    <mat-card class="item-card">
            <mat-card-title>Login</mat-card-title>
        <mat-card-content>
      
        <form [formGroup]="itemForm" #loginNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
            <mat-form-field>
                <input formControlName="userName" matInput placeholder="Enter User Name">
                <mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">User Name is required</mat-error>
            </mat-form-field>
            <mat-form-field>
                <input type="password" formControlName="password" matInput placeholder="Enter Password">
                <mat-error *ngIf="!itemForm.get('password').valid && itemForm.get('password').touched">Password is required</mat-error>
            </mat-form-field>
            <mat-error *ngIf="itemForm.errors?.passwordUserNameError && (itemForm.touched || itemForm.dirty)" >
                  Wrong username or password.
                </mat-error>
        </form>
        </mat-card-content>
        <mat-card-actions class="item-action">
            <button mat-flat-button (click)="loginNgForm.ngSubmit.emit()" [disabled]="!itemForm.valid || loading">
                Login </button>
         </mat-card-actions>
    </mat-card>
</div>
</div>