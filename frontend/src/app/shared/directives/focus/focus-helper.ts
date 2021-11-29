

import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class FocusHelperService {
  private minimumOffsetForNewSwitchInMs = 100;

  private lastFocusSwitch = -this.minimumOffsetForNewSwitchInMs;

  private lastPriority = -1;

  private static FOCUSABLE_SELECTORS = 'a, button, :input, [tabindex], select';

  public throttleAndCheckIfAllowedFocusChangeBasedOnTimeout() {
    const allowFocusSwitch = (Date.now() - this.lastFocusSwitch) >= this.minimumOffsetForNewSwitchInMs;

    // Always update so that a chain of focus-change-requests gets considered as one
    this.lastFocusSwitch = Date.now();

    return allowFocusSwitch;
  }

  public checkIfAllowedFocusChange(priority?:any) {
    const checkTimeout = this.throttleAndCheckIfAllowedFocusChangeBasedOnTimeout();

    if (checkTimeout) {
      // new timeout window -> reset priority
      this.lastPriority = -1;
      return checkTimeout;
    }

    if (priority > this.lastPriority) {
      // within timeout window
      this.lastPriority = priority;
      return true;
    }

    return checkTimeout;
  }

  public getFocusableElement(element:JQuery) {
    const focusser = element.find('input.ui-select-focusser');

    if (focusser.length > 0) {
      return focusser[0];
    }

    let focusable = element;

    if (!element.is(FocusHelperService.FOCUSABLE_SELECTORS)) {
      focusable = element.find(FocusHelperService.FOCUSABLE_SELECTORS);
    }

    return focusable[0];
  }

  public focus(element:JQuery) {
    const focusable = jQuery(this.getFocusableElement(element));
    const $focusable = jQuery(focusable);
    const isDisabled = $focusable.is('[disabled]');

    if (isDisabled && !$focusable.attr('ng-disabled')) {
      $focusable.prop('disabled', false);
    }

    focusable.focus();

    if (isDisabled && !$focusable.attr('ng-disabled')) {
      $focusable.prop('disabled', true);
    }
  }

  public focusElement(element:JQuery, priority?:any) {
    if (!this.checkIfAllowedFocusChange(priority)) {
      return;
    }

    setTimeout(() => {
      this.focus(element);
    }, 10);
  }
}
