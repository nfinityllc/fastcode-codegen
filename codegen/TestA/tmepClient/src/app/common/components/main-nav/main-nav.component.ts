import { Component, AfterViewInit, ViewChild, ChangeDetectorRef } from '@angular/core';
import { Observable } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { Globals } from '../../../globals';
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
	
	appName: string = 'tmep';
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
	
}