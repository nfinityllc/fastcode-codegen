export { ActivatedRoute } from '@angular/router';
import { Input, Injectable } from "@angular/core";
import { of } from "rxjs";

export class RouterLinkDirectiveStub {
  @Input('routerLink') linkParams: any;
  navigatedTo: any = null;
  onClick() {
    this.navigatedTo = this.linkParams;
  }
}

export let mockGlobal = {
  isSmallDevice$: of({ value: true }),
  isMediumDeviceOrLess$: of({ value: true })
};

export let mockActivatedRoute = {
  snapshot: { 
    paramMap: { get: () => { return '1' } },
    queryParams: { get: () => { return '1' } }
  }
}

@Injectable()
export class MockRouter { 
  navigate = (commands: any) => {}; 
}

@Injectable()
export class MockPickerDialogService { }