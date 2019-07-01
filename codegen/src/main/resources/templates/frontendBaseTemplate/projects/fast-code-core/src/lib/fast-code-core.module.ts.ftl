import { NgModule, ModuleWithProviders } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import {
  MatButtonModule, MatToolbarModule, MatSidenavModule,
  MatIconModule, MatListModule, MatRadioModule, MatTableModule,
  MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
  MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
  MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatSortModule,
  MatPaginatorModule, MatProgressSpinnerModule,MatSnackBarModule
} from '@angular/material';
import {MatChipsModule} from '@angular/material/chips';
import { MatExpansionModule } from '@angular/material/expansion';
import { LayoutModule } from '@angular/cdk/layout';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


import { FastCodeCoreComponent } from './fast-code-core.component';

import { ConfirmDialogComponent } from './common/components/confirm-dialog/confirm-dialog.component';
import { AddFilterFieldComponent } from './common/components/list-filters/add-filter-field/add-filter-field.component';
import { ListFiltersComponent } from './common/components/list-filters/list-filters.component';
import { VirtualScrollDirective } from './common/directives/virtualScroll/virtual-scroll.directive';

import { BaseDetailsComponent } from './common/base/base-details.component';
import { BaseListComponent } from './common/base/base-list.component';
import { BaseNewComponent } from './common/base/base-new.component';

import { PickerComponent } from './common/components/picker/picker.component';
import { PickerDialogService } from './common/components/picker/picker-dialog.service';

import { IP_CONFIG } from './tokens';
import { IForRootConf } from './IForRootConf';
import { Globals } from './globals';

@NgModule({
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    MatDialogModule,
    ReactiveFormsModule,
    MatInputModule,
    MatButtonModule,
    LayoutModule,
    MatToolbarModule,
    MatSidenavModule,
    MatTabsModule,
    MatIconModule,
    MatListModule,
    MatExpansionModule,
    MatRadioModule,
    MatTableModule,
    MatCardModule,
    MatSelectModule,
    MatCheckboxModule,
    MatAutocompleteModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatMenuModule,
    MatSortModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatChipsModule,
    NgxMaterialTimepickerModule,
  ],
  declarations: [
    FastCodeCoreComponent,
    ConfirmDialogComponent,
    AddFilterFieldComponent,
    ListFiltersComponent,
    VirtualScrollDirective,
    BaseDetailsComponent,
    BaseListComponent,
    BaseNewComponent,
    PickerComponent
  ],
  exports: [
    FastCodeCoreComponent,
    ConfirmDialogComponent,
    ListFiltersComponent,
    AddFilterFieldComponent,
    VirtualScrollDirective,
    BaseDetailsComponent,
    BaseListComponent,
    BaseNewComponent,
    PickerComponent
  ],
  entryComponents: [
    AddFilterFieldComponent,
    PickerComponent
  ]
})
export class FastCodeCoreModule1 { }

export class FastCodeCoreModule {
  static forRoot(config: IForRootConf): ModuleWithProviders {
    return {
      ngModule: FastCodeCoreModule1,
      providers: [
        {
          provide: IP_CONFIG,
          useValue: config
        },
        Globals
      ]
    };
  }
}