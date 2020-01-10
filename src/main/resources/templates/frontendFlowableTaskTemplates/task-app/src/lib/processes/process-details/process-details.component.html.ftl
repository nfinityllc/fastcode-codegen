<div class="help-container" *ngIf="!processInstance" auto-height>
  <div>
    <div class="help-text wide">
      <div class="description">
        {{'PROCESS.MESSAGE.NO-INSTANCES-HELP' | translate}}
      </div>
      <div class="task-help-entry" (click)="createProcessInstance()">
        <mat-icon>add_circle</mat-icon>
        <span translate="PROCESS.MESSAGE.NO-INSTANCES-HELP-START"></span>
      </div>
    </div>
  </div>
</div>

<div class="header" *ngIf="processInstance">
  <div class="btn-group pull-right"
    *ngIf="processInstance.startedBy && processInstance.startedBy.id == ('' + account.id)">
    <button *ngIf="!processInstance.ended" mat-flat-button color="accent" (click)="cancelProcess()">
      {{'PROCESS.ACTION.CANCEL' | translate}}
    </button>
    <button *ngIf="processInstance.ended" mat-flat-button color="accent" (click)="deleteProcess()">
      {{'PROCESS.ACTION.DELETE' | translate}}
    </button>
  </div>
  <!-- <div class="btn-group pull-right" *ngIf="processInstance.graphicalNotationDefined">
      <button class="btn" id="processDiagramTrigger" translate="PROCESS.ACTION.SHOW-DIAGRAM" (click)="showDiagram()"></button>
    </div> -->
  <h2> {{processInstance.name && processInstance.name ||
    processInstance.processDefinitionName}}</h2>

  <div class="detail">
    <span class="label" *ngIf="processInstance.startedBy">{{'PROCESS.FIELD.STARTED-BY' | translate}}: </span>
    <app-user-name [user]="processInstance.startedBy" *ngIf="processInstance.startedBy"></app-user-name>
    <span class="label">{{'PROCESS.FIELD.STARTED' | translate}}: </span>
    <span title="{{processInstance.started | date:'short'}}">{{processInstance.started |
      date:'short'}}</span>
    <span class="label" *ngIf="processInstance.ended">{{'PROCESS.FIELD.ENDED' | translate}}: </span>
    <span *ngIf="processInstance.ended" title="{{processInstance.ended | date:'short'}}">{{processInstance.ended
      | date:'short'}}</span>
  </div>
</div>

<div class="details-container" *ngIf="processInstance">

  <!-- tasks -->
  <div class="full-width col">

    <mat-card class="details-section">
      <mat-card-title translate="PROCESS.SECTION.ACTIVE-TASKS"></mat-card-title>
      <mat-card-content>
        <ul class="generic-list checklist">
          <li *ngFor="let task of processTasks" (click)="openTask(task)" class="cursor-pointer">
            <div class="clearfix">
              <div class="pull-right">
                <span class="badge" *ngIf="task.dueDate">
                  {{'TASK.MESSAGE.DUE-ON' | translate}} {{(task.dueDate | date:'short')}}
                </span>
                <span class="badge" *ngIf="!task.dueDate">
                  {{'TASK.MESSAGE.CREATED-ON' | translate}} {{(task.created | date:'short')}}
                </span>
              </div>
              <div>
                <app-user-picture *ngIf="task.assignee" [userId]="task.assignee.id"></app-user-picture>
                {{task.name && task.name || ('TASK.MESSAGE.NO-NAME' | translate)}}
              </div>
              <div class="subtle">
                <span *ngIf="task.assignee && task.assignee.id">
                  {{'TASK.MESSAGE.ASSIGNEE' | translate}} {{task.assignee.firstName && task.assignee.firstName !=
                    'null' ? task.assignee.firstName : ''}} {{task.assignee.lastName && task.assignee.lastName != 'null'
                    ? task.assignee.lastName : ''}}
                </span>
                <span *ngIf="!task.assignee || !task.assignee.id" translate="TASK.MESSAGE.NO-ASSIGNEE">
                </span>
              </div>
            </div>
          </li>
        </ul>
        <div class="nothing-to-see" *ngIf="!processTasks || processTasks.length == 0">
          <span translate="PROCESS.MESSAGE.NO-TASKS"></span>
        </div>
      </mat-card-content>
    </mat-card>

    <mat-card class="details-section" *ngIf="processInstance.startFormDefined">
      <mat-card-title translate="PROCESS.SECTION.START-FORM" id="startForm"></mat-card-title>
      <mat-card-content>
        <ul class="generic-list checklist">
          <li (click)="openStartForm()" class="complete">
            <div class="clearfix">
              <div>
                <div user-picture="processInstance.startedBy"></div>
                <span translate="PROCESS.SECTION.START-FORM"></span>
              </div>
              <div class="subtle">
                <span *ngIf="processInstance.startedBy.id">
                  {{'TASK.MESSAGE.COMPLETED-BY' | translate}} {{processInstance.startedBy.firstName &&
                    processInstance.startedBy.firstName != 'null' ? processInstance.startedBy.firstName :
                    ''}} {{processInstance.startedBy.lastName && processInstance.startedBy.lastName != 'null'
                    ? processInstance.startedBy.lastName : ''}}
                  {{processInstance.started | date:'short'}}
                </span>
              </div>
            </div>
          </li>
        </ul>
      </mat-card-content>
    </mat-card>

    <mat-card class="details-section">
      <mat-card-title translate="PROCESS.SECTION.COMPLETED-TASKS" id="completedTasks"></mat-card-title>

      <mat-card-content>
        <ul class="generic-list checklist">
          <li *ngFor="let task of completedProcessTasks" (click)="openTask(task)" class="complete">
            <div class="clearfix">
              <div class="pull-right">
                <span class="badge">
                  {{'TASK.MESSAGE.DURATION' | translate:task}}
                </span>
              </div>
              <div>
                <app-user-picture *ngIf="task.assignee" [userId]="task.assignee.id"></app-user-picture>
                {{task.name && task.name || ('TASK.MESSAGE.NO-NAME' | translate)}}
              </div>
              <div class="subtle">
                <span *ngIf="task.assignee && task.assignee.id">
                  {{'TASK.MESSAGE.COMPLETED-BY' | translate}} {{task.assignee.firstName && task.assignee.firstName !=
                    'null' ? task.assignee.firstName : ''}} {{task.assignee.lastName && task.assignee.lastName != 'null'
                    ? task.assignee.lastName : ''}}
                  {{task.endDate | date:'short'}}
                </span>
                <span *ngIf="!task.assignee || !task.assignee.id" translate="TASK.MESSAGE.NO-ASSIGNEE">
                </span>
              </div>
            </div>
          </li>
        </ul>
        <div class="nothing-to-see" *ngIf="completedProcessTasks.length == 0">
          <span translate="PROCESS.MESSAGE.NO-COMPLETED-TASKS"></span>
        </div>
      </mat-card-content>
    </mat-card>
  </div>

  <!-- comments -->
  <div class="full-width col">
    <mat-card class="details-section">
      <mat-card-title>
        {{'PROCESS.SECTION.COMMENTS' | translate}}
        <span (click)="addComment()" title="{{'PROCESS.ACTION.ADD-COMMENT' | translate}}">
          <mat-icon>add_circle</mat-icon>
        </span>
      </mat-card-title>

      <mat-card-content>
        <ul class="generic-list comments selectable" *ngIf="comments.data.length">
          <li *ngFor="let comment of comments.data">
            <div class="title">
              <app-user-picture [userId]="comment.createdBy"></app-user-picture>
              {{'PROCESS.MESSAGE.COMMENT-HEADER' | translate:comment}}
            </div>
            <div class="message">{{comment.message}}</div>
          </li>
        </ul>
      </mat-card-content>
    </mat-card>
  </div>

</div>