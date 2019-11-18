<div class="header" *ngIf="task">
  <div class=" pull-right">
    <button mat-flat-button color="accent"
      *ngIf="!task.formKey && !task.endDate && (task.assignee.id == account.id || (task.initiatorCanCompleteTask && task.processInstanceStartUserId == ('' + account.id)))"
      [disabled]="completeButtonDisabled || uploadInProgress" (click)="completeTask()">
      {{'TASK.ACTION.COMPLETE' | translate}}
    </button>

    <button mat-button color="accent" *ngIf="(task.assignee == null || task.assignee == undefined) &&
      (task.memberOfCandidateGroup || task.memberOfCandidateUsers ||
      (task.initiatorCanCompleteTask && task.processInstanceStartUserId == ('' + account.id)))"
      translate="TASK.ACTION.CLAIM" ng-disabled="claimButtonDisabled || uploadInProgress"
      (click)="claimTask()"></button>

    <!-- <app-form *ngIf="formData" [taskId]="task.id" [formData]="formData" [outcomesOnly]="true"></app-form> -->

  </div>
  <div>
    <h2>{{task.name && task.name || ('TASK.MESSAGE.NO-NAME' | translate)}}</h2>
  </div>
  <div class="detail">
    <!-- assignee -->
    <span class="detail-label">{{'TASK.FIELD.ASSIGNEE' | translate}}: </span>
    <button
      *ngIf="!task.endDate && task.assignee && (task.assignee.id == account.id || (task.initiatorCanCompleteTask && task.processInstanceStartUserId == ('' + account.id)))"
      mat-button (click)="openSetTaskAssigneeDialog()">
      <app-user-name [user]="task.assignee"></app-user-name>
    </button>
    <span class="detail-label"
      *ngIf="task.assignee && (task.endDate || (task.assignee.id != account.id && (!task.initiatorCanCompleteTask || task.processInstanceStartUserId != ('' + account.id))))">
      <app-user-name [user]="task.assignee"></app-user-name>
    </span>
    <span class="detail-label" *ngIf="(task.endDate && !task.assignee) || !task.assignee"
      translate="TASK.MESSAGE.NO-ASSIGNEE"></span>

    <!-- due date -->
    <span class="detail-label">{{'TASK.FIELD.DUE' | translate}}: </span>
    <button mat-button *ngIf="!task.endDate && !taskUpdating" (click)="updateDueDate()">
      {{task.dueDate && (task.dueDate | date:'medium') || ('TASK.MESSAGE.NO-DUEDATE' | translate)}}
    </button>
    <span *ngIf="task.endDate">{{task.dueDate && (task.dueDate | date:'medium') || ('TASK.MESSAGE.NO-DUEDATE' |
      translate)}}</span>

    <!-- process instance -->
    <span *ngIf="task.processInstanceId && processInstance" class="detail-label">{{'TASK.FIELD.PROCESS-INSTANCE' |
      translate}}: </span>
    <span *ngIf="task.processInstanceId && processInstance">
      <button #openProcessInstance mat-button (click)="openProcessInstance(processInstance.id)">{{processInstance.name && processInstance.name ||
        processInstance.processDefinitionName}}</button>
    </span>

    <!-- parent task -->
    <span *ngIf="task.parentTaskId" class="detail-label">{{'TASK.FIELD.PARENT-TASK' | translate}}: </span>
    <span *ngIf="task.parentTaskId">
      <a (click)="openTaskInstance(task.parentTaskId)">{{task.parentTaskName}}</a>
    </span>

    <span class="detail-label" *ngIf="task.endDate != null && task.endDate != undefined">{{'TASK.FIELD.ENDED' |
      translate}}: </span>
    <span *ngIf="task.endDate != null && task.endDate != undefined">{{task.endDate | date:'medium'}}</span>

    <span class="detail-label" *ngIf="task.endDate != null && task.endDate != undefined">{{'TASK.FIELD.DURATION' |
      translate}}: </span>
    <span *ngIf="task.endDate != null && task.endDate != undefined">{{task.duration}}</span>

    <span class="detail-label" *ngIf="task.formKey" (click)="toggleForm()">
      <button mat-stroked-button color="accent">
        <span *ngIf="activeTab == 'form'">
          {{'TASK.TITLE.SHOW-DETAILS' | translate}}
        </span>
        <span *ngIf="activeTab == 'details'">
          {{'TASK.TITLE.SHOW-FORM' | translate}}
        </span>
      </button>
    </span>
  </div>
  <!-- 
  <div class="summary-header clearfix" ng-class="{'pack': involvementSummary.count == 0 &amp;&amp; contentSummary.count == 0}">
    <div class="clearfix" (click)="showDetails()">
      <div class="title title-lg" *ngIf="involvementSummary.count == 0">
        {{'TASK.TITLE.NO-PEOPLE-INVOLVED' | translate}}
      </div>

      <div *ngFor="let user of involvementSummary.items">
        <app-user-picture [userId]="user.id"></app-user-picture>
      </div>

      <div class="user-picture more" *ngIf="involvementSummary.overflow">
        <span>...</span>
      </div>
    </div>
    <div class="clearfix" (click)="showDetails()">
      <div class="title title-lg" *ngIf="contentSummary.count == 0">
        {{'TASK.TITLE.NO-CONTENT-ITEMS' | translate}}
      </div>

      <div class="related-content" *ngFor="let content of contentSummary.items" title="{{content.name}}">
        <i class="icon icon-{{content.simpleType}}"></i>
      </div>

      <div class="related-content more" *ngIf="contentSummary.overflow">
        <span>...</span>
      </div>
    </div>
    <div class="clearfix" (click)="showDetails()">
      <div class="title title-lg" *ngIf="commentSummary.count == 1">
        1 {{'TASK.TITLE.COMMENT-COUNT' | translate}}
      </div>
      <div class="title title-lg" *ngIf="commentSummary.count > 1">
        <span>{{commentSummary.count}}</span> {{'TASK.TITLE.COMMENTS-COUNT' | translate}}
      </div>
      <div class="title title-lg" *ngIf="commentSummary.count == 0">
        {{'TASK.TITLE.NO-COMMENTS' | translate}}
      </div>
    </div>
    <div class="clearfix" (click)="showDetails()">
      <div class="title title-lg" *ngIf="subTaskSummary.count == 1">
        1 {{'TASK.TITLE.SUBTASK-COUNT' | translate}}
      </div>
      <div class="title title-lg" *ngIf="subTaskSummary.count > 1">
        <span>{{subTaskSummary.count}}</span> {{'TASK.TITLE.SUBTASKS-COUNT' | translate}}
      </div>
      <div class="title title-lg" *ngIf="subTaskSummary.count == 0">
        {{'TASK.TITLE.NO-SUBTASKS' | translate}}
      </div>
    </div>
    <div *ngIf="task.formKey" (click)="toggleForm()">
      <button mat-stroked-button color="accent">
        <span *ngIf="activeTab == 'form'">
          {{'TASK.TITLE.SHOW-DETAILS' | translate}}
        </span>
        <span *ngIf="activeTab == 'details'">
          {{'TASK.TITLE.SHOW-FORM' | translate}}
        </span>

      </button>
    </div>
  </div> -->
</div>

<div class="details-content" *ngIf="task" ng-class="{'split': activeTab == 'details' && hasDetails() == true}">

  <!-- FORM -->
  <!-- <div class="section" *ngIf="activeTab == 'form' && formData != null && formData != undefined"> -->
  <div class="section" *ngIf="activeTab == 'form'">

    <app-form *ngIf="formData" [taskId]="task.id" [formData]="formData" (onTaskCompletion)="emitOnTaskCompletion()"
      [hideButtons]="task.endDate"
      [disableForm]="((!task.assignee || task.assignee.id != account.id) && (!task.initiatorCanCompleteTask || task.processInstanceStartUserId != ('' + account.id)))">
    </app-form>
    <!-- unclaimed task-->
    <!-- <div *ngIf="task.assignee == null || task.assignee == undefined">
            <activiti-form form-definition="formData" task-id="task.id"
                           *ngIf="formData"
                           disable-form="task.assignee == null || task.assignee == undefined"
                           hide-buttons="task.endDate"
                           disable-form-text="'TASK.MESSAGE.CLAIM-TASK-FIRST'">
            </activiti-form>
        </div> -->

    <!-- task with assignee -->
    <!-- <div *ngIf="task.assignee && task.assignee.id != undefined && task.assignee.id != null && task.assignee.id != undefined">
            <activiti-form form-definition="formData" task-id="task.id"
                           *ngIf="formData"
                           hide-buttons="task.endDate || (task.assignee.id != account.id && (!task.initiatorCanCompleteTask || task.processInstanceStartUserId != ('' + account.id)))">
            </activiti-form>
        </div> -->
  </div>

  <div class="details-container" *ngIf="activeTab == 'details' && hasDetails() == true">
    <!-- INVOLVED PEOPLE AND CONTENT-->
    <div class="full-width col">
      <mat-card class="details-section">
        <mat-card-title>
          {{'TASK.SECTION.PEOPLE' | translate}}
          <span *ngIf="!task.endDate" (click)="involvePerson()" title="{{'TASK.ACTION.INVOLVE' | translate}}">
            <mat-icon>add_circle</mat-icon>
          </span>
        </mat-card-title>

        <mat-card-content>
          <ul class="generic-list selectable">
            <li *ngFor="let person of task.involvedPeople; let i = index" class="clearfix">
              <div class="user-details">
                <app-user-picture [userId]="person.id"></app-user-picture>
                <app-user-name [user]="person"></app-user-name>
              </div>
              <div class="actions" *ngIf="!task.endDate">
                <a (click)="removeInvolvedUser(person,i)">
                  <mat-icon title="Remove">clear</mat-icon>
                </a>
              </div>
            </li>
          </ul>
        </mat-card-content>

      </mat-card>

      <mat-card class="details-section" *ngIf="!contentSummary.loading">
        <mat-card-title>
          {{'TASK.TITLE.CONTENT'| translate}}
          <span *ngIf="!task.endDate" (click)="toggleCreateContent()" title="{{'TASK.ACTION.ADD-CONTENT' | translate}}">
            <mat-icon>add_circle</mat-icon>
          </span>
        </mat-card-title>

        <mat-card-content>
          <ul id="related-content-list" class="generic-list selectable task-content-list">
            <li *ngFor="let content of content.data" title="{{content.name}}" class="full-width">
              <app-document-preview (onContentDeleted)="onContentDeleted(content)" [content]="content" [task]="task">
              </app-document-preview>
            </li>
          </ul>
        </mat-card-content>
      </mat-card>

      <mat-card class="details-section" *ngIf="!subTaskSummary.loading">
        <mat-card-title id="toggle-add-subtask" class="toggle-content-select">
          {{'TASK.TITLE.SUBTASK' | translate}}
          <span *ngIf="!task.endDate" (click)="createSubTask()" title="{{'TASK.ACTION.ADD-SUB-TASK' | translate}}">
            <mat-icon>add_circle</mat-icon>
          </span>
        </mat-card-title>

        <mat-card-content>
          <ul id="related-subtask-list" class="sub-task-list">
            <li *ngFor="let task of subTasks" title="{{task.name}}" (click)="openTaskInstance(task)">
              <div>
                <div class="pull-right">
                  <span class="badge" *ngIf="task.dueDate">
                    {{'TASK.MESSAGE.DUE-ON' | translate}} {{(task.dueDate | date:'medium')}}
                  </span>
                  <span class="badge" *ngIf="!task.dueDate">
                    {{'TASK.MESSAGE.CREATED-ON' | translate}} {{(task.created | date:'medium')}}
                  </span>
                </div>
                <div class="title">
                  {{task.name && task.name || ('TASK.MESSAGE.NO-NAME' | translate)}}
                </div>
                <div class="summary">
                  {{task.description && task.description || ('TASK.MESSAGE.NO-DESCRIPTION' |
                    translate)}}
                </div>
                <div class="detail">
                  <span *ngIf="task.assignee.id">
                    {{'TASK.MESSAGE.ASSIGNEE' | translate}} {{task.assignee.firstName &&
                      task.assignee.firstName != 'null' ? task.assignee.firstName : ''}}
                    {{task.assignee.lastName && task.assignee.lastName != 'null' ?
                      task.assignee.lastName : ''}}
                  </span>
                  <span *ngIf="!task.assignee.id" translate="TASK.MESSAGE.NO-ASSIGNEE">
                  </span>
                </div>
              </div>
            </li>
          </ul>
        </mat-card-content>
      </mat-card>
    </div>

    <!-- COMMENTS -->
    <div class="full-width col">
      <mat-card class="details-section" *ngIf="!commentSummary.loading">
        <mat-card-title close-on-select="false">{{'TASK.SECTION.COMMENTS'
          | translate}}
          <span *ngIf="!task.endDate" (click)="addComment()" title="{{'TASK.ACTION.ADD-COMMENT' | translate}}">
            <mat-icon>add_circle</mat-icon>
          </span>
        </mat-card-title>
        <mat-card-content>
          <ul class="generic-list comments selectable" *ngIf="comments.data.length">
            <li *ngFor="let comment of comments.data">
              <div class="title">
                <app-user-picture [userId]="comment.createdBy"></app-user-picture>
                {{'TASK.MESSAGE.COMMENT-HEADER' | translate:comment}} {{(comment.created | date:'medium')}}
              </div>
              <div class="message">{{comment.message}}</div>
            </li>
          </ul>
        </mat-card-content>
      </mat-card>
    </div>
  </div>

  <div class="help-container"
    *ngIf="activeTab == 'details' && task != null && task != undefined && hasDetails() == false && !involvementSummary.loading && !contentSummary.loading && !commentSummary.loading && !subTaskSummary.loading">
    <div>
      <div class="help-text">

        <div class="description" *ngIf="!task.endDate && task.assignee != null && task.assignee != undefined">
          {{'TASK.HELP.DESCRIPTION' | translate}}
        </div>

        <div class="description" *ngIf="task.endDate">
          {{'TASK.HELP.COMPLETED-DESCRIPTION' | translate}}
        </div>

        <div class="description" *ngIf="!task.endDate && (task.assignee == null || task.assignee == undefined)">
          {{'TASK.HELP.DESCRIPTION-WITH-CLAIM' | translate}}
        </div>

        <div class="task-help-entry" *ngIf="!task.endDate">
          <!-- <span class="glyphicon glyphicon-user"></span> -->
          <mat-icon>person</mat-icon>
          <span (click)="involvePerson()" title="{{'TASK.ACTION.INVOLVE' | translate}}">{{'TASK.HELP.ADD-PEOPLE'
            | translate}}</span>
        </div>

        <!-- add content -->
        <div *ngIf="!task.endDate">
          <div class="task-help-entry" (click)="toggleCreateContent()"
            *ngIf="contentSummary.addContent == null || contentSummary.addContent == undefined || contentSummary.addContent == false">
            <mat-icon>insert_drive_file</mat-icon>
            <span>{{'TASK.HELP.ADD-CONTENT' | translate}}</span>
          </div>
        </div>

        <!-- add comment -->
        <div *ngIf="!task.endDate">
          <div (click)="addComment()" class="task-help-entry"
            *ngIf="commentSummary.addComment == null || commentSummary.addComment == undefined || commentSummary.addComment == false">
            <mat-icon>message</mat-icon>
            <span>{{'TASK.HELP.ADD-COMMENT' | translate}}</span>
          </div>
        </div>

        <!-- add sub task-->
        <div *ngIf="!task.endDate">
          <div class="task-help-entry" id="toggle-create-subtask" (click)="createSubTask()"
            *ngIf="contentSummary.addContent == null || contentSummary.addContent == undefined || contentSummary.addContent == false">
            <mat-icon>assignment_turned_in</mat-icon>
            <span>{{'TASK.HELP.ADD-SUBTASK' | translate}}</span>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- hidden file input for content upload-->
  <input type="file" [hidden]="true" (change)="fileChange($event)" #fileInput />

</div>

<div class="help-container" *ngIf="!task || !task.id">
  <div>
    <div class="help-text wide">
      <div class="description">
        {{'TASK.MESSAGE.NO-TASKS-HELP' | translate}}
      </div>
      <div class="task-help-entry toggle-create-task" (click)="createTask()">
        <mat-icon>assignment_turned_in</mat-icon>
        <span>{{'TASK.MESSAGE.NO-TASKS-CREATE-TASK' | translate}}</span>
      </div>
    </div>
  </div>
</div>