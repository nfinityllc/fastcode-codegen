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
		<#if AuthenticationType != "none">
		public Auth: AuthenticationService,
		public globalPermissionService: GlobalPermissionService,
		</#if>
	) {

		this.isSmallDevice$ = Global.isSmallDevice$;
		this.isMediumDevice$ = Global.isMediumDevice$;

		this.router.events.subscribe((event: Event) => {
			this.isCurrentRootRoute = (this.router.url == '/') ? true : false;
		});
	}

	switchLanguage(language: string) {
		this.translate.use(language);
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