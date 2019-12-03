import { Component, AfterViewInit, ViewChild, ChangeDetectorRef } from '@angular/core';
import { Observable } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { Globals } from '../../../globals';
<#if AuthenticationType != "none">
import { AuthenticationService } from '../../../core/authentication.service';
import { GlobalPermissionService } from '../../../core/global-permission.service';
</#if>
import { Router, Event } from '@angular/router';
import entities from './entities.json';
import { MatSidenav, MatSidenavContent } from '@angular/material';

import { FastCodeCoreTranslateUiService } from 'fastCodeCore';
<#if FlowableModule!false>
import { TaskAppTranslateUiService } from '../../../../../projects/task-app/src/public_api';
</#if>
<#if SchedulerModule!false>
import { SchedulerTranslateUiService } from 'scheduler';
</#if>
<#if EmailModule!false>
import { EmailBuilderTranslateUiService } from '../../../../../projects/ip-email-builder/src/public_api';
</#if>

@Component({
	selector: 'app-main-nav',
	templateUrl: './main-nav.component.html',
	styleUrls: ['./main-nav.component.scss']
})
export class MainNavComponent {	
	@ViewChild("drawer", { static: false }) drawer: MatSidenav;
	@ViewChild("navContent", { static: false }) navContent: MatSidenavContent;
	
	appName: string = '[=AppName]';
	selectedLanguage = "en";
	entityList = entities;

	hasTaskAppPermission: boolean = false;
	hasAdminAppPermission: boolean = false;

	isSmallDevice$: Observable<boolean>;
	isMediumDevice$: Observable<boolean>;
	isCurrentRootRoute: boolean = false;
	constructor(
		private router: Router,
		public translate: TranslateService,
		public Global: Globals,
    private fastCodeCoreTranslateUiService: FastCodeCoreTranslateUiService,
		<#if AuthenticationType != "none">
		public Auth: AuthenticationService,
		public globalPermissionService: GlobalPermissionService,
		</#if>
		<#if FlowableModule!false>
    private taskAppTranslateUiService: TaskAppTranslateUiService,
    </#if>
		<#if SchedulerModule!false>
    private schedulerTranslateUiService: SchedulerTranslateUiService,
    </#if>
    <#if EmailModule!false>
    private emailBuilderTranslateUiService: EmailBuilderTranslateUiService,
    </#if>
	) {

		this.isSmallDevice$ = Global.isSmallDevice$;
		this.isMediumDevice$ = Global.isMediumDevice$;

		this.router.events.subscribe((event: Event) => {
			this.isCurrentRootRoute = (this.router.url == '/') ? true : false;
		});
	}

	switchLanguage(language: string) {
	  if(this.translate.translations[language]){
      this.translate.use(language);
    }else{
      this.translate.use(language).subscribe(() => {
        this.fastCodeCoreTranslateUiService.init(language);
        <#if SchedulerModule!false>
        this.schedulerTranslateUiService.init(language);</#if>
        <#if EmailModule!false>
        this.emailBuilderTranslateUiService.init(language);</#if>
        <#if FlowableModule!false>
        this.taskAppTranslateUiService.init(language);</#if>
      });
    }
    this.selectedLanguage = language;
	}
	onNavMenuClicked() {
		console.log('nav clicked');
	}
	<#if AuthenticationType != "none">
	isMenuVisible(entityName:string){
		return  this.Auth.token? this.globalPermissionService.hasPermissionOnEntity(entityName,"READ"): false;
	}
	
	login() {
		this.router.navigate(['/login'], { queryParams: { returnUrl: 'dashboard' } });
	}
	
	logout() {
		this.Auth.logout();
		this.router.navigate(['/']);
	}
	
	<#if FlowableModule!false>
	isFlowableMenuVisible(app: string){
		return this.Auth.token? this.globalPermissionService.hasPermission(app): false;
	}
	</#if>

	</#if>
	
}