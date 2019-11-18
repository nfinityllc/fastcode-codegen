<mat-sidenav-container class="sidenav-container"> 
  <mat-sidenav #drawer class="sidenav" fixedInViewport="true" [attr.role]="(isSmallDevice$ | async) ? 'dialog' : 'navigation'" 
    [mode]="(isSmallDevice$ | async) ? 'over' : 'side'" 
    [opened]="!(isSmallDevice$ | async) && !isCurrentRootRoute <#if AuthenticationType != "none">&&  Auth.token</#if>"> 
 
    <mat-toolbar color="primary">Menu</mat-toolbar> 
    <mat-nav-list class="nav-list"> 
      <a mat-list-item class="sidenav-list-item" routerLink="/">{{'MainNav.Home' | translate }}</a> 
      
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
      
      <#if AuthenticationType != "none"> 
      <mat-expansion-panel class="expansion-panel"> 
        <mat-expansion-panel-header class="subnav-header"> 
          {{'MainNav.AccessMgmt' | translate }} 
        </mat-expansion-panel-header> 
 
        <mat-nav-list class="subnav"> 
 
          <#if !UserInput??> 
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('user')" routerLink="user">Users </a> 
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('userpermission')" routerLink="userpermission">Users Permissions </a> 
          <#elseif UserInput??> 
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('[=AuthenticationTable?lower_case]')" routerLink="[=AuthenticationTable?lower_case]">[=AuthenticationTable] </a> 
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('[=AuthenticationTable?lower_case]permission')" routerLink="[=AuthenticationTable?lower_case]permission">[=AuthenticationTable] Permissions </a> 
          </#if>           
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('role')" routerLink="role">Roles</a> 
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('permission')" routerLink="permission">Permissions</a> 
          <a mat-list-item class="mat-sub-list-item" *ngIf="isMenuVisible('rolepermission')" routerLink="rolepermission">Roles Permissions</a> 
 
        </mat-nav-list> 
      </mat-expansion-panel> 
      
      </#if>
      <mat-expansion-panel class="expansion-panel"> 
        <mat-expansion-panel-header class="subnav-header"> 
          {{'MainNav.Entities' | translate }} 
        </mat-expansion-panel-header> 
 
        <mat-nav-list class="subnav"> 
 
          <ng-container *ngFor="let entity of entityList"> 
            <a <#if AuthenticationType != "none">*ngIf="isMenuVisible(entity)"</#if> mat-list-item class="mat-sub-list-item" [routerLink]="[entity]"> 
              {{entity}} 
            </a> 
          </ng-container> 
 
        </mat-nav-list> 
      </mat-expansion-panel>
      
      <#if History!false>
      <a mat-list-item class="sidenav-list-item" routerLink="entityHistory">{{'MainNav.EntityHistory' | translate }} 
      </a>
      
      </#if>
      <#if FlowableModule!false> 
      <mat-expansion-panel class="expansion-panel" <#if AuthenticationType != "none">*ngIf="isFlowableMenuVisible('access-admin')"</#if> > 
        <mat-expansion-panel-header class="subnav-header"> 
          {{'MainNav.ProcessAdmin.Title' | translate }} 
        </mat-expansion-panel-header> 
 
        <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/engine">{{'MainNav.ProcessAdmin.ConfigurationEngine' | translate }} </a> 
        <!-- Process Engine --> 
        <mat-expansion-panel class="expansion-panel"> 
 
          <mat-expansion-panel-header class="subnav-header"> 
            {{'MainNav.ProcessAdmin.ProcessEngine' | translate }} 
          </mat-expansion-panel-header> 
 
          <mat-nav-list class="subnav"> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/deployments">{{'MainNav.ProcessAdmin.Deployments'|translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/process-definitions">{{'MainNav.ProcessAdmin.Definitions'|translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/process-instances">{{'MainNav.ProcessAdmin.Instances'|translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/tasks">{{'MainNav.ProcessAdmin.Tasks' |translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/jobs">{{'MainNav.ProcessAdmin.Jobs' |translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/event-subscriptions">{{'MainNav.ProcessAdmin.EventSubscriptions'|translate }} </a> 
          </mat-nav-list> 
 
        </mat-expansion-panel> 
 
        <!-- App engine --> 
        <mat-expansion-panel class="expansion-panel"> 
 
          <mat-expansion-panel-header class="subnav-header"> 
            {{'MainNav.ProcessAdmin.AppEngine' | translate }} 
          </mat-expansion-panel-header> 
 
          <mat-nav-list class="subnav"> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/app-deployments">{{'MainNav.ProcessAdmin.Deployments'|translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/app-definitions">{{'MainNav.ProcessAdmin.Definitions'|translate }} </a> 
          </mat-nav-list> 
 
        </mat-expansion-panel> 
 
        <!-- Form engine --> 
        <mat-expansion-panel class="expansion-panel"> 
 
          <mat-expansion-panel-header class="subnav-header"> 
            {{'MainNav.ProcessAdmin.FormEngine' | translate }} 
          </mat-expansion-panel-header> 
 
          <mat-nav-list class="subnav"> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/form-deployments">{{'MainNav.ProcessAdmin.Deployments'|translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/form-definitions">{{'MainNav.ProcessAdmin.Definitions'|translate }} </a> 
            <a mat-list-item class="mat-sub-list-item" href="/#/flowable-admin/form-instances">{{'MainNav.ProcessAdmin.Instances'|translate }} </a> 
          </mat-nav-list> 
 
        </mat-expansion-panel> 
 
      </mat-expansion-panel> 
      <mat-expansion-panel class="expansion-panel" <#if AuthenticationType != "none"> *ngIf="isFlowableMenuVisible('access-task')"</#if>>
        <mat-expansion-panel-header class="subnav-header"> 
          {{'MainNav.Task.Title' | translate }} 
        </mat-expansion-panel-header> 
 
        <mat-nav-list class="subnav"> 
 
          <a mat-list-item class="mat-sub-list-item" routerLink="/task-app/tasks">{{'MainNav.Task.Tasks' | translate }}</a> 
          <a mat-list-item class="mat-sub-list-item" routerLink="/task-app/processes">{{'MainNav.Task.Processes' | translate }}</a> 
 
        </mat-nav-list> 
      </mat-expansion-panel>
      
      </#if>
      <#if EmailModule!false>
      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          {{'MainNav.Email.Title' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <a mat-list-item class="mat-sub-list-item"  <#if AuthenticationType != "none">*ngIf="isMenuVisible('email')"</#if> routerLink="email/emailtemplates">{{'MainNav.Email.EmailTemplate' | translate }}
          </a>
          <a mat-list-item class="mat-sub-list-item"  <#if AuthenticationType != "none">*ngIf="isMenuVisible('emailvariable')"</#if> routerLink="email/emailvariables">{{'MainNav.Email.EmailVariables' | translate }}
          </a>

        </mat-nav-list>
      </mat-expansion-panel>
      
      </#if>
      <#if SchedulerModule!false>
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
      </mat-expansion-panel>
      
      </#if> 
       
 
    </mat-nav-list> 
  </mat-sidenav> 
  <mat-sidenav-content #navContent class="fc-sidenav-content"> 
    <mat-toolbar class="fc-tool-bar" color="primary" *ngIf="!(Global.isSmallDevice$ | async)"> 
 
      <i class="material-icons"> 
        account_balance 
      </i> 
 
      <span>{{appName}}</span>
      
      <span>
	      <button mat-button [matMenuTriggerFor]="notification"><mat-icon>account_box</mat-icon></button>
	      <#if AuthenticationType != "none">
	      <mat-menu #notification="matMenu">
	        <button mat-menu-item *ngIf="!Auth.token" (click)="login()">Login</button>
	        <button mat-menu-item *ngIf="Auth.token" (click)="logout()">Logout</button>
	      </mat-menu>
	      </#if>
      </span>
      
    </mat-toolbar> 
    <#if FlowableModule!false> 
    <div ng-view style="height: 100%;overflow: auto"></div> 
    </#if> 
     
    <router-outlet></router-outlet> 
    <bottom-tab-nav (onNavMenuClicked)="drawer.toggle()" *ngIf=" (Global.isSmallDevice$ | async)" class="fc-bottom-nav"> 
 
    </bottom-tab-nav> 
  </mat-sidenav-content> 
</mat-sidenav-container> 