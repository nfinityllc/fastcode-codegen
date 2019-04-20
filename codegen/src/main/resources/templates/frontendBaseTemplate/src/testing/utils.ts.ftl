import { NgModule } from '@angular/core';

import { Injectable,  Input} from '@angular/core';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

//import { Observable } from 'rxjs';
//import 'rxjs/add/observable/of';
//import 'rxjs/add/observable/throw';
import { Observable, throwError,of } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import {Component, Directive, ChangeDetectorRef} from '@angular/core';

import {Router, ActivatedRoute,} from '@angular/router';
import {RouterTestingModule} from '@angular/router/testing';
import {Globals} from '../app/globals';
import {PickerDialogService} from '../app/common/components/picker/picker-dialog.service';
import {PickerComponent} from '../app/common/components/picker/picker.component';

import {MatDialog, MatDialogRef,MatButtonModule, MatToolbarModule, MatSidenavModule,
  MatIconModule, MatListModule, MatRadioModule, MatTableModule,
  MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
  MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
  MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatTable,
  MatChipsModule, MatSortModule
} from '@angular/material';
import { FormsModule,ReactiveFormsModule } from '@angular/forms';
import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';
import { ListFiltersComponent } from 'src/app/common/components/list-filters/list-filters.component';
import { AddFilterFieldComponent } from 'src/app/common/components/list-filters/add-filter-field/add-filter-field.component';
  @Injectable()
  class MockRouter { navigate = (commands:any)=> {}; }
  @Injectable()
  class MockPickerDialogService { }
  @Directive({
  selector:'[routerlink]',
  host: {'(click)':'onClick()'}
  })
  export  class RouterLinkDirectiveStub {
    @Input('routerLink') linkParams: any;
    navigatedTo: any = null;
    onClick () {
      this.navigatedTo = this.linkParams;
    }
  }
  let mockGlobal = {
    isSmallDevice$: of({value:true}),
    isMediumDeviceOrLess$:of({value:true})
  };
  let mockActivatedRoute = {
    snapshot: {paramMap: {get: ()=> {return '1'}}},
    paramMap: of({
       convertToParamMap: { 
        userId: 'abc123',
      anotherId: 'd31e8b48-7309-4c83-9884-4142efdf7271',          
       }
      }),
    queryParams: of({
      convertToParamMap: { 
       userId: 'abc123',
     anotherId: 'd31e8b48-7309-4c83-9884-4142efdf7271',          
      }
     })
  }
   class BlankComponent {

  }
@NgModule({
  imports: [
    RouterTestingModule.withRoutes(
      [{path: 'users', component: BlankComponent}]
    ),HttpClientTestingModule,NoopAnimationsModule,
    FormsModule,ReactiveFormsModule,
     MatButtonModule, MatToolbarModule, MatSidenavModule,
    MatIconModule, MatListModule, MatRadioModule, MatTableModule,
    MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
    MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
    MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatChipsModule,
    MatSortModule, NgxMaterialTimepickerModule
  ],
  exports: [RouterTestingModule,HttpClientTestingModule,NoopAnimationsModule,
    FormsModule,ReactiveFormsModule,
     MatButtonModule, MatToolbarModule, MatSidenavModule,
    MatIconModule, MatListModule, MatRadioModule, MatTableModule,
    MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
    MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
    MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatTable,
    MatChipsModule, MatSortModule, NgxMaterialTimepickerModule
  // , PickerComponent,UserNewComponent,JobNewComponent,TriggerNewComponent
  ],
  providers: [
   // {provide: Router, useClass: MockRouter},
   {provide: ActivatedRoute, useValue:mockActivatedRoute},
    {provide: Globals, useValue: mockGlobal},
    MatDialog,
    PickerDialogService,
   // {provide: PickerDialogService, useClass: MockPickerDialogService},
   
  ],
  entryComponents: [
    PickerComponent,ListFiltersComponent, AddFilterFieldComponent
  ]  
 
})
export class TestingModule {  
  constructor() {}
}
export var EntryComponents:any[]=[PickerComponent,ListFiltersComponent, AddFilterFieldComponent];