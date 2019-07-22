import { Component } from '@angular/core';
import {TranslateService} from '@ngx-translate/core';
import { FastCodeCoreTranslateUiService } from 'fastCodeCore';
<#if SchedulerModule!false>
import { SchedulerTranslateUiService } from 'scheduler';
</#if>
<#if EmailModule!false>
import { EmailBuilderTranslateUiService } from 'ip-email-builder';
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
    <#if SchedulerModule!false>
    private schedulerTranslateUiService: SchedulerTranslateUiService,</#if>
    <#if EmailModule!false>
    private emailBuilderTranslateUiService: EmailBuilderTranslateUiService,</#if>
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
  }
}
