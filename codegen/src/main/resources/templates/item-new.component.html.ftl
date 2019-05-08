<div class="container">
    <mat-toolbar class="action-tool-bar" color="primary">
        <button mat-flat-button (click)="onCancel()">
            Cancel </button>
        <span class="middle">{{title}}</span>

        <button mat-flat-button (click)="itemNgForm.ngSubmit.emit()" [disabled]="!itemForm.valid || loading">
            Save </button>

    </mat-toolbar>
    <mat-card>
        <h2>{{title}}</h2>
        <form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
            <#list Fields as key,value>
            <#if value.fieldName?lower_case == "id">    
            <#elseif value.fieldType?lower_case == "boolean">    
                <mat-checkbox formControlName="[=value.fieldName]">[=value.fieldName]</mat-checkbox>            
            <#elseif value.fieldType == "Date">
               <mat-form-field>
                        <input formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
                        <mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
                </mat-form-field>
            <#elseif value.fieldType?lower_case == "string">
                  <mat-form-field>
                        <input formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
                        <mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
                </mat-form-field>
              
            </#if> 
      </#list>
      			<div *ngFor="let association of toOne" class="button-row">
							<button mat-raised-button color="accent" (click)="$event.preventDefault();selectAssociation(association)">Select {{association.table}}</button>:
							<a [routerLink]="['/' + association.table + '/' + itemForm.get(association.column.key).value]" *ngIf="itemForm.get(association.column.key).value">{{itemForm.get(association.descriptiveField).value}}</a>
							<label *ngIf="!itemForm.get(association.column.key).value">No {{association.table}} selected</label>
						</div>
            
           
        </form>
    </mat-card>
</div>
