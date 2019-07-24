<div class="header" *ngIf="task">
  <div class=" pull-right">
    <button class="btn" *ngIf="!task.formKey && !task.endDate && (task.assignee.id == account.id || (task.initiatorCanCompleteTask && task.processInstanceStartUserId == ('' + account.id)))"
      translate="TASK.ACTION.COMPLETE" [disabled]="completeButtonDisabled || uploadInProgress" (click)="completeTask()"></button>

    <button class="btn" *ngIf="(task.assignee == null || task.assignee == undefined) &&
            (task.memberOfCandidateGroup || task.memberOfCandidateUsers ||
            (task.initiatorCanCompleteTask && task.processInstanceStartUserId == ('' + account.id)))"
      translate="TASK.ACTION.CLAIM" ng-disabled="claimButtonDisabled || uploadInProgress" (click)="claimTask()"></button>

    <!-- <app-form *ngIf="formData" [taskId]="task.id" [formData]="formData" [outcomesOnly]="true"></app-form> -->

  </div>
  <h2>{{task.name && task.name || ('TASK.MESSAGE.NO-NAME' | translate)}}</h2>

  <div class="detail">
    <!-- assignee -->
    <span class="label">{{'TASK.FIELD.ASSIGNEE' | translate}}: </span>
    <a *ngIf="!task.endDate && task.assignee && (task.assignee.id == account.id || (task.initiatorCanCompleteTask && task.processInstanceStartUserId == ('' + account.id)))"
      class="subtle-select" (click)="openSetTaskAssigneeDialog()">
      <app-user-name [user]="task.assignee"></app-user-name>
    </a>
    <span *ngIf="task.assignee && (task.endDate || (task.assignee.id != account.id && (!task.initiatorCanCompleteTask || task.processInstanceStartUserId != ('' + account.id))))">
      <app-user-name [user]="task.assignee"></app-user-name>
    </span>
    <span *ngIf="(task.endDate && !task.assignee) || !task.assignee" translate="TASK.MESSAGE.NO-ASSIGNEE"></span>

    <!-- due date -->
    <span class="label">{{'TASK.FIELD.DUE' | translate}}: </span>
    <a *ngIf="!task.endDate && !taskUpdating" (click)="updateDueDate()">
      {{task.dueDate && (task.dueDate | date:'medium') || ('TASK.MESSAGE.NO-DUEDATE' | translate)}}
    </a>
    <span *ngIf="task.endDate">{{task.dueDate && (task.dueDate | date:'medium') || ('TASK.MESSAGE.NO-DUEDATE' |
      translate)}}</span>

    <!-- process instance -->
    <span *ngIf="task.processInstanceId && processInstance" class="label">{{'TASK.FIELD.PROCESS-INSTANCE' |
      translate}}: </span>
    <span *ngIf="processInstance">
      <a (click)="openProcessInstance(processInstance.id)">{{processInstance.name && processInstance.name ||
        processInstance.processDefinitionName}}</a>
    </span>

    <!-- parent task -->
    <span *ngIf="task.parentTaskId" class="label">{{'TASK.FIELD.PARENT-TASK' | translate}}: </span>
    <span *ngIf="task.parentTaskId">
      <a (click)="openTaskInstance(task.parentTaskId)">{{task.parentTaskName}}</a>
    </span>

    <span class="label" *ngIf="task.endDate != null && task.endDate != undefined">{{'TASK.FIELD.ENDED' |
      translate}}: </span>
    <span *ngIf="task.endDate != null && task.endDate != undefined">{{task.endDate | date:'medium'}}</span>

    <span class="label" *ngIf="task.endDate != null && task.endDate != undefined">{{'TASK.FIELD.DURATION' |
      translate}}: </span>
    <span *ngIf="task.endDate != null && task.endDate != undefined">{{task.duration}}</span>
  </div>

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
      <button class="btn btn-xs">
        <span *ngIf="activeTab == 'form'">
          {{'TASK.TITLE.SHOW-DETAILS' | translate}}
        </span>
        <span *ngIf="activeTab == 'details'">
          {{'TASK.TITLE.SHOW-FORM' | translate}}
        </span>

      </button>
    </div>
  </div>
</div>

<div class="content" *ngIf="task" ng-class="{'split': activeTab == 'details' && hasDetails() == true}">

  <!-- FORM -->
  <!-- <div class="section" *ngIf="activeTab == 'form' && formData != null && formData != undefined"> -->
  <div class="section" *ngIf="activeTab == 'form'">

    <app-form 
      *ngIf="formData"
      [taskId]="task.id"
      [formData]="formData"
      (onTaskCompletion)="emitOnTaskCompletion()"
      [hideButtons]="task.endDate"
      [disableForm]="(task.assignee.id != account.id && (!task.initiatorCanCompleteTask || task.processInstanceStartUserId != ('' + account.id)))"
      
      ></app-form>
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

  <!-- INVOLVED PEOPLE AND CONTENT-->
  <div class="split-left" *ngIf="activeTab == 'details' && hasDetails() == true">
    <div class="section pack" *ngIf="!commentSummary.loading">
      <h3 (click)="involvePerson()" title="{{'TASK.ACTION.INVOLVE' | translate}}">

        {{'TASK.SECTION.PEOPLE' | translate}}
        <span class="action" *ngIf="!task.endDate">
          <a>+</a>
        </span>
      </h3>

      <ul class="simple-list selectable">
        <li *ngFor="let person of task.involvedPeople; let i = index" class="clearfix">
          <app-user-picture [userId]="person.id"></app-user-picture>
          <app-user-name [user]="person"></app-user-name>
          <div class="actions" *ngIf="!task.endDate"><a><i class="icon icon-remove" (click)="removeInvolvedUser(person,i)"></i></a></div>
        </li>
      </ul>

    </div>
    <div class="section pack" toggle-dragover="dragOverContent(over)" *ngIf="!contentSummary.loading">
      <h3 class="toggle-content-select" (click)="toggleCreateContent()" title="{{'TASK.ACTION.ADD-CONTENT' | translate}}">{{'TASK.TITLE.CONTENT'
        | translate}}
        <span class="action" *ngIf="!task.endDate"><a>+</a></span>
      </h3>

      <div class="form-group">
        <ul id="related-content-list" class="clearfix simple-list selectable content-list">
          <li *ngFor="let content of content.data" title="{{content.name}}">
            <app-document-preview (onContentDeleted)="onContentDeleted(content)" [content]="content" [task]="task"></app-document-preview>
          </li>
        </ul>
      </div>
    </div>
    <div class="section pack" *ngIf="!subTaskSummary.loading">
      <h3 id="toggle-add-subtask" class="toggle-content-select" (click)="createSubTask()">
        {{'TASK.TITLE.SUBTASK' | translate}}
        <span class="action" *ngIf="!task.endDate">
          <a>+</a>
        </span>
      </h3>

      <div class="form-group">
        <ul id="related-subtask-list" class="full-list">
          <li *ngFor="let task of subTasks" title="{{task.name}}" (click)="openTaskInstance(task.id)">
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
      </div>
    </div>
  </div>

  <!-- COMMENTS -->
  <div class="split-right" *ngIf="activeTab == 'details' && hasDetails() == true && !commentSummary.loading">
    <!-- <div class="split-right" *ngIf="activeTab == 'details'"> -->
    <div class="section">
      <h3 close-on-select="false" (click)="addComment()" title="{{'TASK.ACTION.ADD-COMMENT' | translate}}">{{'TASK.SECTION.COMMENTS'
        | translate}}
        <span class="action" *ngIf="!task.endDate">
          <a>+</a>
        </span>
      </h3>

      <ul class="simple-list comments selectable" *ngIf="comments.data.length">
        <li *ngFor="let comment of comments.data">
          <div class="title">
            <app-user-picture [userId]="comment.createdBy"></app-user-picture>
            {{'TASK.MESSAGE.COMMENT-HEADER' | translate:comment}}
          </div>
          <div class="message">{{comment.message}}</div>
        </li>
      </ul>
    </div>
  </div>

  <div class="help-container" *ngIf="activeTab == 'details' && task != null && task != undefined && hasDetails() == false && !involvementSummary.loading && !contentSummary.loading && !commentSummary.loading && !subTaskSummary.loading">
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

        <div class="help-entry" *ngIf="!task.endDate">
          <span class="glyphicon glyphicon-user"></span>
          <span (click)="involvePerson()" title="{{'TASK.ACTION.INVOLVE' | translate}}">{{'TASK.HELP.ADD-PEOPLE'
            | translate}}</span>
        </div>

        <!-- add content -->
        <div *ngIf="!task.endDate">
          <div class="help-entry" (click)="toggleCreateContent()" *ngIf="contentSummary.addContent == null || contentSummary.addContent == undefined || contentSummary.addContent == false">
            <span class="glyphicon glyphicon-list-alt"></span>
            <span>{{'TASK.HELP.ADD-CONTENT' | translate}}</span>
          </div>
        </div>

        <!-- add comment -->
        <div *ngIf="!task.endDate">
          <div (click)="addComment()" class="help-entry" *ngIf="commentSummary.addComment == null || commentSummary.addComment == undefined || commentSummary.addComment == false">
            <span class="glyphicon glyphicon-pencil"></span>
            <span>{{'TASK.HELP.ADD-COMMENT' | translate}}</span>
          </div>
        </div>

        <!-- add sub task-->
        <div *ngIf="!task.endDate">
          <div class="help-entry" id="toggle-create-subtask" (click)="createSubTask()" *ngIf="contentSummary.addContent == null || contentSummary.addContent == undefined || contentSummary.addContent == false">
            <span class="glyphicon glyphicon-check"></span>
            <span>{{'TASK.HELP.ADD-SUBTASK' | translate}}</span>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- hidden file input for content upload-->
  <input type="file" [hidden]="true" (change)="fileChange($event)" #fileInput />

  <div class="help-container" *ngIf="!task || !task.id">
    <div>
      <div class="help-text wide">
        <div class="description">
          {{'TASK.MESSAGE.NO-TASKS-HELP' | translate}}
        </div>
        <div class="help-entry toggle-create-task" (click)="createTask()">
          <span class="glyphicon glyphicon-plus-sign"></span>
          <span translate="TASK.MESSAGE.NO-TASKS-CREATE-TASK"></span>
        </div>
      </div>
    </div>
  </div>

</div>