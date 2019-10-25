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

  constructor(<#if FlowableModule!false>private upgrade: UpgradeModule,private taskAppTranslateUiService: TaskAppTranslateUiService,</#if>
    private translate: TranslateService,
    private fastCodeCoreTranslateUiService: FastCodeCoreTranslateUiService,
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
    translate.use(browserLang.match(/en|fr/) ? browserLang : 'en').subscribe(() => {
      this.fastCodeCoreTranslateUiService.init();
      <#if SchedulerModule!false>
      this.schedulerTranslateUiService.init(browserLang);</#if>
      <#if EmailModule!false>
      //this.emailBuilderTranslateUiService.init(browserLang);</#if>
      <#if FlowableModule!false>
      this.taskAppTranslateUiService.init();</#if>
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
