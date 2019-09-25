import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { FastCodeCoreTranslateUiService } from 'fastCodeCore';
<#if SchedulerModule!false>
import { SchedulerTranslateUiService } from 'scheduler';
</#if>
<#if EmailModule!false>
import { EmailBuilderTranslateUiService } from 'ip-email-builder';
</#if>
<#if FlowableModule!false>
import { UpgradeModule } from "@angular/upgrade/static";
import { TaskAppTranslateUiService } from 'task-app';
</#if>
<#if AuthenticationType != 'none'>
import { OAuthService, JwksValidationHandler, OAuthErrorEvent, OAuthSuccessEvent, OAuthInfoEvent } from 'angular-oauth2-oidc';
import { AuthOidcConfig } from './oauth/auth-oidc-config';
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
    private emailBuilderTranslateUiService: EmailBuilderTranslateUiService,
    </#if>
	<#if AuthenticationType != 'none'>
    private authService: AuthenticationService,
    private oauthService: OAuthService
    </#if>
 ) {
    translate.addLangs(["en", "fr"]);
    translate.setDefaultLang('en');

    let browserLang = translate.getBrowserLang();
    translate.use(browserLang.match(/en|fr/) ? browserLang : 'en').subscribe(() => {
      this.fastCodeCoreTranslateUiService.init(browserLang);
      <#if SchedulerModule!false>
      this.schedulerTranslateUiService.init(browserLang);</#if>
      <#if EmailModule!false>
      this.emailBuilderTranslateUiService.init(browserLang);</#if>
    });
	<#if AuthenticationType != 'none'>
	if(this.authService.loginType == 'oidc') {
    	this.authService.configure();
    }
    </#if>
  }
  
  <#if FlowableModule!false>
  ngOnInit()
  {
  this.upgrade.bootstrap(document.body, ['flowableAdminApp']);
  }
  </#if>
}
