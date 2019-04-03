import { Component } from '@angular/core';
import { BreakpointObserver, Breakpoints, BreakpointState } from '@angular/cdk/layout';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import {TranslateService} from '@ngx-translate/core';
import {Globals} from '../globals';

@Component({
  selector: 'app-main-nav',
  templateUrl: './main-nav.component.html',
  styleUrls: ['./main-nav.component.scss']
})
export class MainNavComponent {
  selectedLanguage = "en";
  /*isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset)
    .pipe(
      map(result => result.matches)
    );
    isHandset$: Observable<boolean> = this.breakpointObserver.observe(['(max-width: 768px)'])
    .pipe(
      map(result => result.matches)
    );*/
    
    isSmallDevice$: Observable<boolean> ;
    isMediumDevice$: Observable<boolean> ;
  constructor(private breakpointObserver: BreakpointObserver,
    public translate: TranslateService, public Global: Globals) {
    
    this.isSmallDevice$ = Global.isSmallDevice$;
    this.isMediumDevice$ = Global.isMediumDevice$;
  }
  
  switchLanguage(language: string) {
    this.translate.use(language);
    this.selectedLanguage = language;
  }
  onNavMenuClicked() {
    console.log('nav clicked');
  }
  }
