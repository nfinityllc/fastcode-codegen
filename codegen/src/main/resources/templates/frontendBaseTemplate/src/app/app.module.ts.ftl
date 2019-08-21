
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClient, HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { LayoutModule } from '@angular/cdk/layout';

import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { DashboardComponent } from './dashboard/dashboard.component';
import { HomeComponent } from './home/index';
<#if AuthenticationType != "none">
import { LoginComponent } from './login/index';
</#if>

<#if EmailModule!false>
import { IpEmailBuilderModule } from 'ip-email-builder';
</#if>
<#if SchedulerModule!false>
import { SchedulerModule } from 'scheduler';
</#if>
<#if FlowableModule!false>
import { UpgradeModule } from "@angular/upgrade/static"; 
import { UrlHandlingStrategy } from '@angular/router';
import { TaskAppModule } from 'task-app';
</#if>

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

import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';

import { routingModule } from './app.routing';
import { FastCodeCoreModule } from 'fastCodeCore';

/** core components and filters **/
import { AuthenticationService } from './core/authentication.service';
import { AuthGuard } from './core/auth-guard';
import { JwtInterceptor } from './core/jwt-interceptor';
import { JwtErrorInterceptor } from './core/jwt-error-interceptor';

/** end of core components and filters **/

/** common components and filters **/

import { MainNavComponent } from './common/components/main-nav/main-nav.component';
import { BottomTabNavComponent } from './common/components/bottom-tab-nav/bottom-tab-nav.component';

/** end of common components and filters **/

import { environment } from '../environments/environment';
import { Globals } from './globals';

export function HttpLoaderFactory(httpClient: HttpClient) {
  return new TranslateHttpLoader(httpClient);
}
<#if FlowableModule!false>
export class CustomHandlingStrategy implements UrlHandlingStrategy { 

shouldProcessUrl(url) { 

       console.log(url.toString()); 

       let urlStr = url.toString().split('/'); 

       return url.toString() == "/" || (urlStr.length > 1 && urlStr[1] == "app") 

   } 

   extract(url) { return url; } 

   merge(url, whole) { return url; } 

} 
</#if>
@NgModule({
  declarations: [
  	HomeComponent,
  	DashboardComponent,
  	<#if AuthenticationType != "none">
	LoginComponent,
	</#if>
    AppComponent,
    MainNavComponent,
    BottomTabNavComponent,
  ],
  imports: [
    BrowserModule,
    routingModule,
    HttpClientModule,
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
    <#if EmailModule!false>
    IpEmailBuilderModule.forRoot({
      xApiKey: 't7HdQfZjGp6R96fOV4P8v18ggf6LLTQZ1puUI2tz',
      apiPath:environment.apiUrl
    }),
    </#if>
    <#if SchedulerModule!false>
    SchedulerModule.forRoot({
      apiPath: environment.apiUrl
    }),
    </#if>
    <#if FlowableModule!false>
    UpgradeModule,  
    TaskAppModule.forRoot({ 

	apiPath: "http://localhost:8080/flowable-task" // url where task backend app is running 

	}),
    </#if>
    FastCodeCoreModule.forRoot({
    	apiUrl: environment.apiUrl
    }),
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: HttpLoaderFactory,
        deps: [HttpClient]
      }
    }),

  ],
  providers: [
		AuthenticationService,
		<#if FlowableModule!false>
		{ provide: UrlHandlingStrategy, useClass: CustomHandlingStrategy },
		</#if>
		{ provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
		{ provide: HTTP_INTERCEPTORS, useClass: JwtErrorInterceptor, multi: true },
		AuthGuard,
		Globals
	],
  bootstrap: [AppComponent],
  entryComponents: [
  ]
})
export class AppModule { }
