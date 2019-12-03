import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { FastCodeCoreTranslateUiService } from 'fastCodeCore';
<#if SchedulerModule!false>
import { SchedulerTranslateUiService } from 'scheduler';
</#if>
<#if EmailModule!false>
//import { EmailBuilderTranslateUiService } from '../../projects/ip-email-builder/src/public_api';
</#if>
<#if FlowableModule!false>
import { UpgradeModule } from "@angular/upgrade/static";
import { TaskAppTranslateUiService } from '../../projects/task-app/src/public_api';
</#if>
<#if AuthenticationType != 'none'>
import { AuthenticationService } from './core/authentication.service';
</#if>

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'fcclient';

  constructor(
    private translate: TranslateService,
    private fastCodeCoreTranslateUiService: FastCodeCoreTranslateUiService,
    <#if FlowableModule!false>
    private upgrade: UpgradeModule,
    private taskAppTranslateUiService: TaskAppTranslateUiService,
    </#if>
    <#if SchedulerModule!false>
    private schedulerTranslateUiService: SchedulerTranslateUiService,
    </#if>
    <#if EmailModule!false>
    //private emailBuilderTranslateUiService: EmailBuilderTranslateUiService,
    </#if>
    <#if AuthenticationType != 'none'>
    private authService: AuthenticationService,
    </#if>
 ) {
    translate.addLangs(["en", "fr"]);
    translate.setDefaultLang('en');

    let browserLang = translate.getBrowserLang();
    let lang = browserLang.match(/en|fr/) ? browserLang : 'en';
    translate.use(lang).subscribe(() => {
      this.fastCodeCoreTranslateUiService.init(lang);
      <#if SchedulerModule!false>
      this.schedulerTranslateUiService.init(lang);</#if>
      <#if EmailModule!false>
      //this.emailBuilderTranslateUiService.init(lang);</#if>
      <#if FlowableModule!false>
      this.taskAppTranslateUiService.init(lang);</#if>
    });
	<#if AuthenticationType != 'none'>
	if(this.authService.loginType == 'oidc') {
      this.authService.configure();
    }
    </#if>
  }
  
  <#if FlowableModule!false>
  ngOnInit(){
  	this.upgrade.bootstrap(document.body, ['flowableAdminApp']);
  }
  </#if>
}
