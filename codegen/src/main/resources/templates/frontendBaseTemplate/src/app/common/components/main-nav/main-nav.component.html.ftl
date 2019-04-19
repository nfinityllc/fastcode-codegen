<mat-sidenav-container class="sidenav-container">
  <mat-sidenav #drawer class="sidenav" fixedInViewport="true" [attr.role]="(isSmallDevice$ | async) ? 'dialog' : 'navigation'"
    [mode]="(isSmallDevice$ | async) ? 'over' : 'side'" [opened]="!(isSmallDevice$ | async)">
    <mat-toolbar color="primary">Menu</mat-toolbar>
    <mat-nav-list>
      <a mat-list-item class="sidenav-list-item" routerLink="/">{{'MainNav.Home' | translate }}</a>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.Entities' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <a *ngFor="let entity of entityList" mat-list-item class="mat-sub-list-item" [routerLink]="[entity]">
            {{entity}}
          </a>

        </mat-nav-list>
      </mat-expansion-panel>

      <!-- <a mat-list-item class="sidenav-list-item" routerLink="admin">Admin</a>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.AccessMgmt' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <a mat-list-item class="mat-sub-list-item" routerLink="users">{{'MainNav.Users' | translate }} </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="roles">Roles</a>
          <a mat-list-item class="mat-sub-list-item" routerLink="permissions">Permissions</a>

        </mat-nav-list>
      </mat-expansion-panel>

      <a mat-list-item class="sidenav-list-item" routerLink="entityHistory">{{'MainNav.EntityHistory' | translate }}
      </a>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.Email.Title' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <a mat-list-item class="mat-sub-list-item" routerLink="email">{{'MainNav.Email.EmailTemplate' | translate }}
          </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="emailvariables">{{'MainNav.Email.EmailVariables' |
            translate }} </a>

        </mat-nav-list>
      </mat-expansion-panel>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.JobScheduling.Title' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <a mat-list-item class="mat-sub-list-item" routerLink="jobs">{{'MainNav.JobScheduling.Jobs' | translate }}
          </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="executingJobs">{{'MainNav.JobScheduling.ExecutingJobs'
            | translate }} </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="triggers">{{'MainNav.JobScheduling.Triggers' |
            translate }} </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="executionHistory">{{'MainNav.JobScheduling.ExecutionHistory'
            | translate }} </a>

        </mat-nav-list>
      </mat-expansion-panel> -->

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.Language' | translate}}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">
          <mat-radio-group class="radio-group" [(ngModel)]="selectedLanguage">
            <mat-radio-button class="radio-button" *ngFor="let lang of translate.getLangs()" (click)="switchLanguage(lang)"
              [value]="lang">
              {{lang | translate}}
            </mat-radio-button>
          </mat-radio-group>

        </mat-nav-list>
      </mat-expansion-panel>

      <!-- <a mat-list-item class="sidenav-list-item" routerLink="entities">{{'MainNav.Monitoring' | translate }}</a> -->

    </mat-nav-list>
  </mat-sidenav>
  <mat-sidenav-content class="fc-sidenav-content">
    <mat-toolbar class="fc-tool-bar" color="primary" *ngIf="!(Global.isSmallDevice$ | async)">

      <i class="material-icons">
        account_balance
      </i>

      <span>Application Name</span>
      <i class="material-icons">
        account_box
      </i>
    </mat-toolbar>

    <router-outlet></router-outlet>
    <bottom-tab-nav (onNavMenuClicked)="drawer.toggle()" *ngIf=" (Global.isSmallDevice$ | async)" class="fc-bottom-nav">

    </bottom-tab-nav>
  </mat-sidenav-content>
</mat-sidenav-container>