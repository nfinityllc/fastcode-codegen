import { VirtualScrollDirective } from './virtual-scroll.directive';
import {TestBed, ComponentFixture} from '@angular/core/testing';
import {Component, DebugElement} from "@angular/core";
import {By} from "@angular/platform-browser";

@Component({
  template: `<ul type="text" appVirtualScroll>`
})
class TestVirtualScrollComponent {
}
describe('VirtualScrollDirective', () => {
  let component: TestVirtualScrollComponent;
  let fixture: ComponentFixture<TestVirtualScrollComponent>;
  let inputEl: DebugElement;
  let directive: VirtualScrollDirective;
  let scrollEventHandlerSpy;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [TestVirtualScrollComponent, VirtualScrollDirective]
    });
    fixture = TestBed.createComponent(TestVirtualScrollComponent);
    component = fixture.componentInstance;
    inputEl = fixture.debugElement.query(By.directive(VirtualScrollDirective));
    directive = new VirtualScrollDirective(inputEl);
    scrollEventHandlerSpy = spyOn(directive, 'scrollEventHandler').and.returnValue(false);;
  });

  it('handling scroll event', () => {
    inputEl.triggerEventHandler('scroll', null);
    
    // let e = {
    //   target :{
    //     offsetHeight: 200,
    //     scrollHeight: 200,
    //     scrollTop: 50

    //   }
    // }
    directive.scrollEventHandler(null);
    fixture.detectChanges();
    expect(scrollEventHandlerSpy).toHaveBeenCalled();
  });

  // it('should create an instance', () => {
  //   const directive = new VirtualScrollDirective(inputEl);
  //   expect(directive).toBeTruthy();
  // });
});
