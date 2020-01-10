<div title="{{content.name}}">

  <i *ngIf="content.contentAvailable && content.simpleType" class="icon icon-{{content.simpleType}}"></i>
  {{content.name}}

  <div class="actions">
    <!-- since browsers do not honour "downlaod" attribute in case of cors   -->
    <a *ngIf="content.contentAvailable && (!content.source)" target="_blank" download="{{content.name}}" href="{{content.rawUrl}}"
      ><mat-icon title="Download">cloud_download</mat-icon></a>
    <a *ngIf="!readOnly" (click)="deleteContent(); $event.preventDefault(); $event.stopPropagation();"><mat-icon title="Remove">clear</mat-icon></a>
  </div>
  <div class="subtle">{{'TASK.MESSAGE.CONTENT-UPLOADED-BY' | translate}} <span user-name="content.createdBy"></span> ,
    {{content.created | date:"medium"}}
  </div>
</div>