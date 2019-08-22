import { Component } from '@angular/core';
import { BreakpointObserver, Breakpoints, BreakpointState } from '@angular/cdk/layout';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { TranslateService } from '@ngx-translate/core';
import { Globals } from '../../../globals';
<#if AuthenticationType != "none">
import { AuthenticationService } from '../../../core/authentication.service';
</#if>
import { ActivatedRoute, Router, Event } from '@angular/router';
import entities from './entities.json';

@Component({
	selector: 'app-main-nav',
	templateUrl: './main-nav.component.html',
	styleUrls: ['./main-nav.component.scss']
})
export class MainNavComponent {
	selectedLanguage = "en";
	entityList = entities;
	
	/*isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset) 
	  .pipe( 
		map(result => result.matches) 
	  ); 
	  isHandset$: Observable<boolean> = this.breakpointObserver.observe(['(max-width: 768px)']) 
	  .pipe( 
		map(result => result.matches) 
	  );*/

	isSmallDevice$: Observable<boolean>;
	isMediumDevice$: Observable<boolean>;
	isCurrentRootRoute: boolean = false;
	constructor(
		private breakpointObserver: BreakpointObserver,
		private router: Router,
		public translate: TranslateService,
		public Global: Globals,
		<#if AuthenticationType != "none">
		public Auth: AuthenticationService,
		</#if>
	) {

		this.isSmallDevice$ = Global.isSmallDevice$;
		this.isMediumDevice$ = Global.isMediumDevice$;

		this.router.events.subscribe((event: Event) => {
			this.isCurrentRootRoute = (this.router.url == '/') ? true : false;
		})
	}

	switchLanguage(language: string) {
		this.translate.use(language);
		this.selectedLanguage = language;
	}
	onNavMenuClicked() {
		console.log('nav clicked');
	}
	<#if AuthenticationType != "none">
	login() {
		this.router.navigate(['/login'], { queryParams: { returnUrl: 'dashboard' } });
	}
	logout() {
		this.Auth.logout();
		this.router.navigate(['/']);
	}
	</#if>
	
}