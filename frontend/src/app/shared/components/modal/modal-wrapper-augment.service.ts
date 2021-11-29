

import { Inject, Injectable, Injector } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { DynamicContentModalComponent } from 'core-app/shared/components/modals/modal-wrapper/dynamic-content.modal';

const iframeSelector = '.iframe-target-wrapper';

/**
 * This service takes modals that are rendered by the rails backend,
 * and re-renders them with the angular op-modal service
 */
@Injectable({ providedIn: 'root' })
export class OpModalWrapperAugmentService {
  constructor(@Inject(DOCUMENT) protected documentElement:Document,
    protected injector:Injector,
    protected opModalService:OpModalService) {
  }

  /**
   * Create initial listeners for Rails-rendered modals
   */
  public setupListener() {
    const matches = this.documentElement.querySelectorAll('[data-augmented-model-wrapper]');
    for (let i = 0; i < matches.length; ++i) {
      this.wrapElement(jQuery(matches[i]) as JQuery);
    }
  }

  /**
   * Wrap a section[data-augmented-modal-wrapper] element
   */
  public wrapElement(element:JQuery) {
    // Find activation link
    const activationSelector = element.data('activationSelector') || '.modal-delivery-element--activation-link';
    const activationLink = jQuery(activationSelector);

    const initializeNow = element.data('modalInitializeNow');

    if (initializeNow) {
      this.show(element);
    } else {
      activationLink.click((evt:JQuery.TriggeredEvent) => {
        this.show(element);
        evt.preventDefault();
      });
    }
  }

  private show(element:JQuery) {
    // Set modal class name
    const modalClassName = element.data('modalClassName');
    // Append CSP-whitelisted IFrame for onboarding
    const iframeUrl = element.data('modalIframeUrl');

    // Set template from wrapped element
    const wrappedElement = element.find('.modal-delivery-element');
    let modalBody = wrappedElement.html();

    if (iframeUrl) {
      modalBody = this.appendIframe(wrappedElement, iframeUrl);
    }

    this.opModalService.show(
      DynamicContentModalComponent,
      this.injector,
      {
        modalBody,
        modalClassName,
      },
    );
  }

  private appendIframe(body:JQuery<HTMLElement>, url:string) {
    const iframe = jQuery('<iframe frameborder="0" height="400" allowfullscreen>></iframe>');
    iframe.attr('src', url);

    body.find(iframeSelector).append(iframe);

    return body.html();
  }
}
