<!--<mat-toolbar color="primary">
  <h1>This is demo version of Angular 6 Email Template Buider!</h1>
  <a href="https://www.npmjs.com/package/ip-email-builder" target="_blank" style="margin-left: auto" mat-stroked-button>Get
    it for FREE
  </a>
  <a href="https://wlocalhost.org/t/thoughts-about-angular-6-email-builder/227" style="margin-left: 5px;" target="_blank"
    mat-button>
    More info
  </a>
</mat-toolbar>  -->
<mat-toolbar class="action-tool-bar" color="primary" >
  <button mat-flat-button (click)="onBack()">
    Cancel </button>
  <span class="middle">Template Details</span>
  <button mat-flat-button   [hidden]="editorView" >
     </button>
  <button mat-flat-button    (click)="saveEmail()" [hidden]="!editorView" >
      Save </button>

</mat-toolbar>
<mat-card *ngIf="!editorView">
  <mat-card-content>
  <form [formGroup]="formGroup" #attributeForm="ngForm" (ngSubmit)="saveEmail()" class="attribute-form">
    <mat-form-field>
      <input formControlName="templateName" matInput placeholder="Enter Template name">
      <mat-error *ngIf="!formGroup.get('templateName').valid && formGroup.get('templateName').touched">Name is required</mat-error>
  </mat-form-field>
  <mat-form-field>
      <input formControlName="category" matInput placeholder="Enter category">
      <mat-error *ngIf="!formGroup.get('category').valid && formGroup.get('category').touched">Category is required</mat-error>
  </mat-form-field>
  <mat-form-field>
      <input formControlName="to" matInput placeholder="Enter Email Receiver">
      <mat-error *ngIf="!formGroup.get('to').valid && formGroup.get('to').touched">Receiver is required</mat-error>
  </mat-form-field>
  <mat-form-field>
      <input formControlName="subject" matInput placeholder="Enter subject name">
      <mat-error *ngIf="!formGroup.get('subject').valid && formGroup.get('subject').touched">Subject is required</mat-error>
  </mat-form-field>
  <mat-form-field>
    <input formControlName="attachmentpath" matInput placeholder="Enter attachment path">
    
</mat-form-field>
<mat-checkbox formControlName="active">Active</mat-checkbox>
  </form>
  </mat-card-content>
  <mat-card-actions>
  <button mat-raised-button color="accent" (click)="saveEmail()">Next: Email Body</button>
  
  </mat-card-actions>
</mat-card>
<ip-email-builder (onEmailTemplateSave)='onEmailTemplateSave($event)' style="height: calc(100% - 64px)" *ngIf="editorView">
  <div class="top-actions">
    
    <button mat-button (click)="sendTestMail()" [disabled]="isLoading | async" color="primary">Send a test email</button>
  </div>
  <div class="top-content">
      <mat-card>
          <mat-expansion-panel>
              <mat-expansion-panel-header>
                <mat-panel-title>
                  Email Template Attributes
                </mat-panel-title>           
              </mat-expansion-panel-header>
              <form  class="template-form"  [formGroup]="formGroup" #ngForm="ngForm" (ngSubmit)="saveEmail()" >
                  <mat-form-field>
                      <input formControlName="templateName" matInput placeholder="Enter Template name">
                      <mat-error *ngIf="!formGroup.get('templateName').valid && formGroup.get('templateName').touched">Name is required</mat-error>
                  </mat-form-field>
                  <mat-form-field>
                      <input formControlName="category" matInput placeholder="Enter category">
                      <mat-error *ngIf="!formGroup.get('category').valid && formGroup.get('category').touched">Category is required</mat-error>
                  </mat-form-field>
                  <mat-form-field>
                      <input formControlName="to" matInput placeholder="Enter Email Receiver">
                      <mat-error *ngIf="!formGroup.get('to').valid && formGroup.get('to').touched">Receiver is required</mat-error>
                  </mat-form-field>
                  <mat-form-field>
                      <input formControlName="subject" matInput placeholder="Enter subject name">
                      <mat-error *ngIf="!formGroup.get('subject').valid && formGroup.get('subject').touched">Subject is required</mat-error>
                  </mat-form-field>
                  <mat-form-field>
                    <input formControlName="attachmentpath" matInput placeholder="Enter attachment path">
                    
                </mat-form-field>
                <mat-checkbox formControlName="active">Active</mat-checkbox>
            
                 
              </form> 
            </mat-expansion-panel>
  
</mat-card>
</div>
  <div class="after-content-blocks"></div>
  <div class="after-structure-blocks"></div>
</ip-email-builder>
