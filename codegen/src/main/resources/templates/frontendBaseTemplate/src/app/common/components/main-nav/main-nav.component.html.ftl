<mat-sidenav-container class="sidenav-container">
  <mat-sidenav #drawer class="sidenav" fixedInViewport="true" [attr.role]="(isSmallDevice$ | async) ? 'dialog' : 'navigation'"
    [mode]="(isSmallDevice$ | async) ? 'over' : 'side'"
    [opened]="!(isSmallDevice$ | async) && !isCurrentRootRoute <#if AuthenticationType != "none">&&  Auth.token</#if>">

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
      
      <#if AuthenticationType != "none">
      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.AccessMgmt' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <#if AuthenticationType != "none" && !UserInput??>
          <a mat-list-item class="mat-sub-list-item" routerLink="user">Users </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="userpermission">Users Permissions </a>
          <#elseif AuthenticationType != "none" && UserInput??>
          <a mat-list-item class="mat-sub-list-item" routerLink="[=AuthenticationTable?lower_case]">[=AuthenticationTable] </a>
          <a mat-list-item class="mat-sub-list-item" routerLink="[=AuthenticationTable?lower_case]permission">[=AuthenticationTable] Permissions </a>
          </#if>          
          <a mat-list-item class="mat-sub-list-item" routerLink="role">Roles</a>
          <a mat-list-item class="mat-sub-list-item" routerLink="permission">Permissions</a>
          <a mat-list-item class="mat-sub-list-item" routerLink="rolepermission">Roles Permissions</a>

        </mat-nav-list>
      </mat-expansion-panel>
      </#if>
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
<#if FlowableModule!false>
	<mat-expansion-panel class="expansion-panel">
<mat-expansion-panel-header class="subnav-header">
{{'MainNav.ProcessAdmin.Title' | translate }}
</mat-expansion-panel-header>

<!-- Process Engine -->
<mat-expansion-panel class="expansion-panel">

<mat-expansion-panel-header class="subnav-header">
{{'MainNav.ProcessAdmin.ProcessEngine' | translate }}
</mat-expansion-panel-header>

<mat-nav-list class="subnav">
<a mat-list-item class="mat-sub-list-item" href="/#/deployments">{{'MainNav.ProcessAdmin.Deployments'
|translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/process-definitions">{{'MainNav.ProcessAdmin.Definitions'
|translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/process-instances">{{'MainNav.ProcessAdmin.Instances'
|translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/tasks">{{'MainNav.ProcessAdmin.Tasks' |translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/jobs">{{'MainNav.ProcessAdmin.Jobs' |translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/event-subscriptions">{{'MainNav.ProcessAdmin.EventSubscriptions'
|translate }} </a>
</mat-nav-list>

</mat-expansion-panel>

<!-- App engine -->
<mat-expansion-panel class="expansion-panel">

<mat-expansion-panel-header class="subnav-header">
{{'MainNav.ProcessAdmin.AppEngine' | translate }}
</mat-expansion-panel-header>

<mat-nav-list class="subnav">
<a mat-list-item class="mat-sub-list-item" href="/#/app-deployments">{{'MainNav.ProcessAdmin.Deployments'
|translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/app-definitions">{{'MainNav.ProcessAdmin.Definitions'
|translate }} </a>
</mat-nav-list>

</mat-expansion-panel>

<!-- Form engine -->
<mat-expansion-panel class="expansion-panel">

<mat-expansion-panel-header class="subnav-header">
{{'MainNav.ProcessAdmin.FormEngine' | translate }}
</mat-expansion-panel-header>

<mat-nav-list class="subnav">
<a mat-list-item class="mat-sub-list-item" href="/#/form-deployments">{{'MainNav.ProcessAdmin.Deployments'
|translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/form-definitions">{{'MainNav.ProcessAdmin.Definitions'
|translate }} </a>
<a mat-list-item class="mat-sub-list-item" href="/#/form-instances">{{'MainNav.ProcessAdmin.Instances'
|translate }} </a>
</mat-nav-list>

</mat-expansion-panel>

</mat-expansion-panel>
</#if>

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
      <#if AuthenticationType != "none">
      <a *ngIf="!Auth.token" (click)="login()">Login</a>
      <a *ngIf="Auth.token" (click)="logout()">Logout</a>
      </#if>
    </mat-toolbar>
<#if FlowableModule!false>
	<div ng-view style="height: 100%;overflow: auto"></div>
</#if>
    
    <router-outlet></router-outlet>
    <bottom-tab-nav (onNavMenuClicked)="drawer.toggle()" *ngIf=" (Global.isSmallDevice$ | async)" class="fc-bottom-nav">

    </bottom-tab-nav>
  </mat-sidenav-content>
</mat-sidenav-container>