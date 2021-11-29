

import {
  ChangeDetectorRef, Component, ElementRef, Inject, OnDestroy, OnInit,
} from '@angular/core';
import { OpModalLocalsToken } from 'core-app/shared/components/modal/modal.service';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { I18nService } from 'core-app/core/i18n/i18n.service';

@Component({
  templateUrl: './dynamic-content.modal.html',
})
export class DynamicContentModalComponent extends OpModalComponent implements OnInit, OnDestroy {
  // override superclass
  // Allowing outside clicks to close the modal leads to the user involuntarily closing
  // the modal when removing error messages or clicking on labels e.g. in the registration modal.
  public closeOnOutsideClick = false;

  constructor(readonly elementRef:ElementRef,
    @Inject(OpModalLocalsToken) public locals:OpModalLocalsMap,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService) {
    super(locals, cdRef, elementRef);
  }

  ngOnInit() {
    super.ngOnInit();

    // Append the dynamic body
    this.$element
      .find('.dynamic-content-modal--wrapper')
      .addClass(this.locals.modalClassName)
      .append(this.locals.modalBody);

    // Register click listeners
    // This registers both on the close button in the modal header, as well as on any
    // other elements you have added the dynamic-content-modal--close-button class.
    jQuery(document.body)
      .on('click.opdynamicmodal',
        '.op-modal--close-button, [dynamic-content-modal-close-button]',
        (evt:JQuery.TriggeredEvent) => {
          this.closeMe(evt);
        });
  }

  ngOnDestroy() {
    jQuery(document.body).off('click.opdynamicmodal');
    super.ngOnDestroy();
  }
}
