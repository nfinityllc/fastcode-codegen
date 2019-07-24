<div class="help-container" *ngIf="!processInstance"
  auto-height>
  <div>
    <div class="help-text wide">
      <div class="description">
        {{'PROCESS.MESSAGE.NO-INSTANCES-HELP' | translate}}
      </div>
      <div class="help-entry toggle-create-task" ng-class="{'active': newProcessInstance.inline }" (click)="createProcessInstance()">
        <span class="glyphicon glyphicon-plus-sign"></span>
        <span translate="PROCESS.MESSAGE.NO-INSTANCES-HELP-START"></span>
      </div>
    </div>
  </div>
</div>


<!-- <div class="header" *ngIf="newProcessInstance != null && newProcessInstance != undefined && newProcessInstance.processDefinition">
    <h2>
      <edit-in-place value="newProcessInstance.name"></edit-in-place>
    </h2>
  </div> -->

<!-- <div class="content clearfix" auto-height offset="6" *ngIf="newProcessInstance != null && newProcessInstance != undefined && newProcessInstance.processDefinition && newProcessInstance.processDefinition.hasStartForm">
    <div class="alert error" *ngIf="startFormError">
      {{startFormError}}
    </div>
    <div>
      <activiti-form process-name="newProcessInstance.name" process-definition-id="newProcessInstance.processDefinition.id"></activiti-form>
    </div>
  </div> -->

<!-- <div class="content clearfix" auto-height offset="6" *ngIf="newProcessInstance != null && newProcessInstance != undefined && newProcessInstance.processDefinition && !newProcessInstance.processDefinition.hasStartForm">
    <div class="pull-right">
      <button class="btn btn-default" style="margin: 10px 15px 0 0" [disabled]="newProcessInstance.loading" (click)="startProcessInstanceWithoutForm()">{{'FORM.DEFAULT-OUTCOME.START-PROCESS'
        | translate}}
      </button>
    </div>
  </div> -->


<div class="header" *ngIf="processInstance">
  <div class="btn-group pull-right" *ngIf="processInstance.startedBy && processInstance.startedBy.id == ('' + account.id)">
    <button *ngIf="!processInstance.ended" class="btn" (click)="cancelProcess()" translate="PROCESS.ACTION.CANCEL"></button>
    <button *ngIf="processInstance.ended" class="btn" (click)="deleteProcess()" translate="PROCESS.ACTION.DELETE"></button>
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

<div class="content" *ngIf="processInstance">
  <div class="split-right">

    <div class="section">
      <h3 close-on-select="false" (click)="addComment()" title="{{'PROCESS.ACTION.ADD-COMMENT' | translate}}">{{'PROCESS.SECTION.COMMENTS'
        | translate}}
        <span class="action">
          <a>+</a>
        </span>
      </h3>

      <ul class="simple-list comments selectable" *ngIf="comments.data.length">
        <li *ngFor="let comment of comments.data">
          <div class="title">
            <app-user-picture [userId]="comment.createdBy"></app-user-picture>
            {{'PROCESS.MESSAGE.COMMENT-HEADER' | translate:comment}}
          </div>
          <div class="message">{{comment.message}}</div>
        </li>
      </ul>
    </div>

  </div>
  <div class="split-left">
    <div class="section pack">
      <h3 translate="PROCESS.SECTION.ACTIVE-TASKS"></h3>
      <ul class="simple-list checklist">
        <li *ngFor="let task of processTasks" (click)="openTask(task)">
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
    </div>
    <div class="section pack" *ngIf="processInstance.startFormDefined">
      <h3 translate="PROCESS.SECTION.START-FORM" id="startForm"></h3>
      <ul class="simple-list checklist">
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
    </div>
    <div class="section pack">
      <h3 translate="PROCESS.SECTION.COMPLETED-TASKS" id="completedTasks"></h3>
      <ul class="simple-list checklist">
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

    </div>
  </div>

</div>