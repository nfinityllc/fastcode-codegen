import { NgModule } from '@angular/core';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientTestingModule } from '@angular/common/http/testing';

import { ActivatedRoute, } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { Globals, PickerDialogService, PickerComponent, ListFiltersComponent, AddFilterFieldComponent } from 'projects/fast-code-core/src/public_api';

import {
  MatButtonModule, MatToolbarModule, MatSidenavModule,
  MatIconModule, MatListModule, MatRadioModule, MatTableModule,
  MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
  MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
  MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatTable,
  MatChipsModule, MatSortModule, MatSnackBarModule
} from '@angular/material';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';
import { TranslateTestingModule } from './translate-testing.module';
import { mockActivatedRoute, mockGlobal } from './mocks';

export var EntryComponents: any[] = [
  PickerComponent,
  ListFiltersComponent,
  AddFilterFieldComponent
];

export var imports: any[] = [
  HttpClientTestingModule, NoopAnimationsModule,
  FormsModule, ReactiveFormsModule, MatButtonModule,
  MatToolbarModule, MatSidenavModule, MatIconModule,
  MatListModule, MatRadioModule, MatTableModule,
  MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
  MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
  MatDatepickerModule, MatNativeDateModule, MatMenuModule,
  MatChipsModule, MatSortModule, MatSnackBarModule,
  NgxMaterialTimepickerModule, TranslateTestingModule
];

export var exports: any[] = [
  HttpClientTestingModule, NoopAnimationsModule,
  FormsModule, ReactiveFormsModule, MatButtonModule,
  MatToolbarModule, MatSidenavModule, MatIconModule,
  MatListModule, MatRadioModule, MatTableModule,
  MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
  MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
  MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatTable,
  MatChipsModule, MatSortModule, MatSnackBarModule,
  NgxMaterialTimepickerModule, TranslateTestingModule
];

export var providers: any[] = [
  // {provide: Router, useClass: MockRouter},
  { provide: ActivatedRoute, useValue: mockActivatedRoute },
  { provide: Globals, useValue: mockGlobal },
  // MatDialog,
  PickerDialogService,
  // {provide: PickerDialogService, useClass: MockPickerDialogService},
]

@NgModule({
  imports: imports.concat([RouterTestingModule]),
  exports: exports.concat([RouterTestingModule]),
  providers:providers

})
export class TestingModule {
  constructor() { }
}