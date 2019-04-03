<mat-card *ngIf="filterFields.length > 0">
  <!-- <form [formGroup]="detailsFilterForm" class="filter-form" [hidden]="!showFilters">
    <div class="full-width">
      <mat-form-field *ngFor="let field of filterFields">
        <input formControlName="{{field.column}}" matInput placeholder="{{field.label}}">
      </mat-form-field>
    </div>
  </form> -->

  
  <form [formGroup]="basicFilterForm" class="filter-form" [hidden]="showFilters">
    <div class="full-width">
      <!-- <mat-form-field>
        <input formControlName="searchText" matInput placeholder="Search">
      </mat-form-field> -->
      <!-- <mat-form-field>
        <input formControlName="addFilter" matInput placeholder="add Filter" [matMenuTriggerFor]="menu">
        <mat-menu #menu="matMenu">
          <button  (click)="addFilter(field)" mat-menu-item *ngFor="let field of filterFields">{{field.label}}</button>
        </mat-menu>
      </mat-form-field> -->

      <mat-form-field class="example-chip-list">
        <mat-chip-list #chipList>
          <mat-chip
            *ngFor="let field of selectedFilterFields"
            (removed)="remove(field)">
            {{field}}
            <mat-icon matChipRemove >cancel</mat-icon>
          </mat-chip>
          <input
            placeholder="Add filter"
            #filterInput
            [formControl]="filterCtrl"
            [matAutocomplete]="auto"
            [matChipInputFor]="chipList"
            [matChipInputSeparatorKeyCodes]="separatorKeysCodes"
            [matChipInputAddOnBlur]="addOnBlur"
            (matChipInputTokenEnd)="add($event)">
        </mat-chip-list>
        <mat-autocomplete #auto="matAutocomplete" (optionSelected)="selected($event)">
          <mat-option *ngFor="let field of filterFields" [value]="field.label">
            {{field.label}}
          </mat-option>
        </mat-autocomplete>
      </mat-form-field>
    </div>
  </form>

  <button mat-flat-button (click)="search()">
    Search
  </button>
</mat-card>