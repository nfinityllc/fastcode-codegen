import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { FastCodeCoreTranslateUiService } from 'fastCodeCore';

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
 ) {
    translate.addLangs(["en", "fr"]);
    translate.setDefaultLang('en');

    let browserLang = translate.getBrowserLang();
    translate.use(browserLang.match(/en|fr/) ? browserLang : 'en').subscribe(() => {
      this.fastCodeCoreTranslateUiService.init();



    });
  }
  
}
