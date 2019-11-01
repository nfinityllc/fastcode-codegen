<div fxLayout fxLayoutGap="20" class="task-container">
  <div fxLayout="column" *ngIf="showList || !isMediumDeviceOrLess" fxFlex="{{listFlexWidth}}" class="task-list" (onScroll)="onTableScroll()"
    appVirtualScroll>
    <div class="task-list-header">

      <div *ngIf="!filter.expanded">
        <div class="filter-text" *ngIf="filter.param.nonDefaultFilter">{{'TASK.MESSAGE.FILTERED' | translate}}</div>
        <div class="filter-text" *ngIf="!filter.param.nonDefaultFilter">{{'TASK.MESSAGE.NO-FILTER' | translate}}</div>

        <div class="filter-icon-expand noselect">
          <span (click)="toggleFilter()">
            {{'TASK.FILTER.SHOW' | translate}}<i class="material-icons">expand_more</i>
          </span>
        </div>
      </div>

      <div *ngIf="filter.expanded">
        <div class="filter-icon-collapse noselect">
          <span (click)="toggleFilter()">
            {{'TASK.FILTER.HIDE' | translate}}<i class="material-icons">expand_less</i>
          </span>
        </div>
      </div>

      <div class="summary" *ngIf="filter.expanded">

        <div class="form-group">
          <label translate="TASK.FILTER.TEXT"></label>
          <input class="form-control" type="text" placeholder="{{'TASK.FILTER.TEXT-PLACEHOLDER' | translate}}"
            [(ngModel)]="filter.param.text" (ngModelChange)="applyFilters()">
        </div>

        <div class="form-group">
          <label translate="TASK.FILTER.STATE"></label>
          <div class="selection toggle">
            <div class="toggle-2" *ngFor="let option of stateFilterOptions" [ngClass]="{'active' : filter.param.state.id == option.id}">
              <button class="btn btn-xs" (click)="selectStateFilter(option)">{{option.title | translate}}</button>
            </div>
          </div>
        </div>

        <mat-form-field class="full-width">
          <label translate="TASK.FILTER.APP"></label>
          <mat-select [disabled]="filter.loading" (selectionChange)="applyFilters()" [(ngModel)]="filter.param.appDefinitionKey">
            <mat-option *ngFor="let option of apps" [value]="option.appDefinitionKey">
              {{ (option.name? option.name : 'TASK.FILTER.APP-PLACEHOLDER') | translate}}
            </mat-option>
          </mat-select>
        </mat-form-field>

        <mat-form-field class="full-width">
          <label translate="TASK.FILTER.PROCESS-DEFINITION"></label>
          <mat-select [disabled]="filter.loading" (selectionChange)="applyFilters()" [(ngModel)]="filter.param.processDefinitionId">
            <mat-option *ngFor="let option of processDefinitions" [value]="option.id">
              {{option.name | translate}}
            </mat-option>
          </mat-select>
        </mat-form-field>

        <mat-form-field class="full-width">
          <label translate="TASK.FILTER.ASSIGNMENT"></label>
          <mat-select [disabled]="filter.loading" (selectionChange)="applyFilters()" [(ngModel)]="filter.param.assignment">
            <mat-option *ngFor="let option of assignmentOptions" [value]="option.id">
              {{option.title | translate}}
            </mat-option>
          </mat-select>
        </mat-form-field>

        <div class="text-center">
          <button class="accent-button" mat-raised-button (click)="resetFilters(); refreshFilter();">
            {{'TASK.FILTER.RESET' | translate}}
          </button>
        </div>

      </div>
    </div>

    <div class="sort-value-block">
      <div class="sort-value">
        <mat-form-field class="full-width">
          <mat-select (selectionChange)="sortChanged()" [(ngModel)]="filter.param.sort">
            <mat-option *ngFor="let sort of sorts" [value]="sort.id">
              {{sort.title | translate}}
            </mat-option>
          </mat-select>
        </mat-form-field>
      </div>

      <div class="create-task">
        <button class="accent-button" mat-raised-button (click)="createTask()">
          {{'TASK.ACTION.CREATE' | translate}}
        </button>
      </div>
    </div>

	<mat-progress-bar *ngIf="filter.loading" mode="indeterminate"></mat-progress-bar>
    <div class="list">
      <div *ngFor="let task of tasks" [ngClass]="{'list-item': true, 'active': (selectedTask.id === task.id)}" class="list-item"
        (click)="selectTask(task)">
        <div fxLayout="row">
          <div class="title" fxFlex>{{task.name && task.name || ('TASK.MESSAGE.NO-NAME' | translate)}}</div>

          <div fxFlex="nogrow" class="badge" *ngIf="task.dueDate">
            {{'TASK.MESSAGE.DUE-ON' | translate}} {{(task.dueDate | date:'medium')}}
          </div>
          <div fxFlex="nogrow" class="badge" *ngIf="!task.dueDate">
            {{'TASK.MESSAGE.CREATED-ON' | translate}} {{(task.created | date:'medium')}}
          </div>
        </div>

        <div fxLayout="row">
          {{task.description && task.description || ('TASK.MESSAGE.NO-DESCRIPTION' | translate)}}
        </div>
        <div fxLayout="row">
          <span *ngIf="task.assignee.id">
            {{'TASK.MESSAGE.ASSIGNEE' | translate}} {{task.assignee.firstName && task.assignee.firstName != 'null' ?
            task.assignee.firstName : ''}} {{task.assignee.lastName && task.assignee.lastName != 'null' ?
            task.assignee.lastName : ''}}
          </span>
          <span *ngIf="!task.assignee.id" translate="TASK.MESSAGE.NO-ASSIGNEE">
          </span>
        </div>
      </div>
    </div>
    <div class="nothing-to-see" *ngIf="tasks.length == 0">
      <span translate="TASK.MESSAGE.NO-TASKS"></span>
    </div>

  </div>

  <div fxLayout="column" *ngIf="!showList || !isMediumDeviceOrLess" fxFlex="{{detailsFlexWidth}}">
    <button class="accent-button back-to-list" mat-raised-button *ngIf="isMediumDeviceOrLess" (click)="showList=!showList">{{'TASK.ACTION.TOGGLE-LIST' | translate}}</button>
    <app-task-details [ngClass]="{'task-details-wrap': !isMediumDeviceOrLess,'task-details-wrap-small': isMediumDeviceOrLess}" fxLayout="column" (onCreateTask)="createTask()" [task]="selectedTask" (onOpenTask)="onOpenTask($event)"
      (onTaskCompletion)="onTaskCompletion()"></app-task-details>
  </div>

</div>