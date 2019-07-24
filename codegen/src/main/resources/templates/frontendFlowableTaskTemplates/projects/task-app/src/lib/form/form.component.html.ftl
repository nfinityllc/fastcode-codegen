<div id="formsection">

    <div *ngIf="formData != null && formData != undefined && (disableForm == null || disableForm == undefined || disableForm == false)"
         class="form-wrapper">

        <div *ngIf="!outcomesOnly" >
            <form [formGroup]="form">
                <div *ngFor="let field of formData.fields" id="fieldContainer_{{field.id}}">
                  <app-form-field [parentForm]="form" [field]="field"></app-form-field> 
                  </div>
            </form>
        </div>

        <div *ngIf="!formData.outcomes || formData.outcomes.length === 0" class="clearfix form-actions">
            <div class="pull-right" *ngIf="(hideButtons == undefined || hideButtons == null || hideButtons == false) && (disableForm == undefined || disableForm == null || disableForm == false)">
                <button id="form_save_button" class="btn btn-default" [disabled]="!form.valid || loading || (disableOutcomes != undefined && disableOutcomes != null && disableOutcomes)"
                        (click)="saveForm()" translate="FORM.ACTION.SAVE"></button>
                <button id="form_complete_button" class="btn btn-default" [disabled]="!form.valid || loading || (disableOutcomes != undefined && disableOutcomes != null && disableOutcomes)"
                        (click)="completeForm('complete')">{{getDefaultCompleteButtonText()}}</button>
            </div>
        </div>

        <div *ngIf="formData.outcomes && formData.outcomes.length > 0" class="clearfix form-actions">
            <div class="pull-right" *ngIf="(hideButtons == undefined || hideButtons == null || hideButtons == false) && (disableForm == undefined || disableForm == null || disableForm == false)">
                <button id="form_save_button" class="btn btn-default"
                        [disabled]="!form.valid || loading"
                        (click)="saveForm()" translate="FORM.ACTION.SAVE"></button>
                <button id="form_complete_button" class="btn btn-default"
                        [disabled]="!form.valid || loading"
                        *ngFor="let outcome of formData.outcomes"
                        (click)="completeForm(outcome)">{{outcome.name}}</button>
            </div>
        </div>

        <div *ngIf="formData.selectedOutcome && formData.selectedOutcome.length > 0" class="clearfix form-actions">
        	<div class="pull-right">
                <button id="form_complete_button" class="btn btn-default" [disabled]="true">{{formData.selectedOutcome}}</button>
            </div>
        </div>

    </div>


    <div *ngIf="disableForm != null && disableForm != undefined && disableForm == true">
        <div *ngIf="disableFormText" class="text-center">
            <div class="help-container fixed">
                <div>
                    <div class="help-text">
                        <div class="description">
                            {{disableFormText | translate}}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
