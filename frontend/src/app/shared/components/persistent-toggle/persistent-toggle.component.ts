

import { Component, ElementRef, OnInit } from '@angular/core';

export const persistentToggleSelector = 'persistent-toggle';

@Component({
  selector: persistentToggleSelector,
  template: '',
})
export class PersistentToggleComponent implements OnInit {
  /** Unique identifier of the toggle */
  private identifier:string;

  /** Is hidden */
  private isHidden = false;

  /** Element reference */
  private $element:JQuery;

  private $targetNotification:JQuery;

  constructor(private elementRef:ElementRef) {
  }

  ngOnInit():void {
    this.$element = jQuery(this.elementRef.nativeElement);
    this.$targetNotification = this.getTargetNotification();

    this.identifier = this.$element.data('identifier');
    this.isHidden = window.ProyeksiApp.guardedLocalStorage(this.identifier) === 'true';

    // Set initial state
    this.$targetNotification.prop('hidden', !!this.isHidden);

    // Register click handler
    this.$element
      .parent()
      .find('.persistent-toggle--click-handler')
      .on('click', () => this.toggle(!this.isHidden));

    // Register target toaster close icon
    this.$targetNotification
      .find('.op-toast--close')
      .on('click', () => this.toggle(true));
  }

  private getTargetNotification() {
    return this.$element
      .parent()
      .find('.persistent-toggle--toaster');
  }

  private toggle(isNowHidden:boolean) {
    this.isHidden = isNowHidden;
    window.ProyeksiApp.guardedLocalStorage(this.identifier, (!!isNowHidden).toString());

    if (isNowHidden) {
      this.$targetNotification.slideUp(400, () => {
        // Set hidden only after animation completed
        this.$targetNotification.prop('hidden', true);
      });
    } else {
      this.$targetNotification.slideDown(400);
      this.$targetNotification.prop('hidden', false);
    }
  }
}
