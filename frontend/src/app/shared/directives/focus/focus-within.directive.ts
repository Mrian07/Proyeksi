

import { BehaviorSubject } from 'rxjs';
import { auditTime } from 'rxjs/operators';
import {
  Directive, ElementRef, Input, OnInit,
} from '@angular/core';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

// with courtesy of http://stackoverflow.com/a/29722694/3206935

@Directive({
  selector: '[opFocusWithin]',
})
export class FocusWithinDirective extends UntilDestroyedMixin implements OnInit {
  @Input() public selector:string;

  constructor(readonly elementRef:ElementRef) {
    super();
  }

  ngOnInit() {
    const element = jQuery(this.elementRef.nativeElement);
    const focusedObservable = new BehaviorSubject(false);

    focusedObservable
      .pipe(
        this.untilDestroyed(),
        auditTime(50),
      )
      .subscribe((focused) => {
        element.toggleClass('-focus', focused);
      });

    const focusListener = function () {
      focusedObservable.next(true);
    };
    element[0].addEventListener('focus', focusListener, true);

    const blurListener = function () {
      focusedObservable.next(false);
    };
    element[0].addEventListener('blur', blurListener, true);

    setTimeout(() => {
      element.addClass('op-focus-within');
      element.find(this.selector).addClass('op-focus-within');
    }, 0);
  }
}
