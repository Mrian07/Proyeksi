

import { Inject, Injectable } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { InviteUserModalComponent } from './invite-user.component';
import ClickEvent = JQuery.ClickEvent;

const attributeSelector = '[invite-user-modal-augment]';

/**
 * This service triggers user-invite modals to clicks on elements
 * with the attribute [invite-user-modal-augment] set.
 */
@Injectable({ providedIn: 'root' })
export class OpInviteUserModalAugmentService {
  constructor(@Inject(DOCUMENT) protected documentElement:Document,
    protected opModalService:OpModalService,
    protected currentProjectService:CurrentProjectService) {
  }

  /**
   * Create initial listeners for Rails-rendered modals
   */
  public setupListener() {
    const matches = this.documentElement.querySelectorAll(attributeSelector);
    for (let i = 0; i < matches.length; ++i) {
      const el = matches[i] as HTMLElement;
      el.addEventListener('click', this.spawnModal.bind(this));
    }
  }

  private spawnModal(event:ClickEvent) {
    event.preventDefault();

    const modal = this.opModalService.show(
      InviteUserModalComponent,
      'global',
      { projectId: this.currentProjectService.id },
    );

    modal
      .closingEvent
      .subscribe((modal:InviteUserModalComponent) => {
        // Just reload the page for now if we saved anything
        if (modal.data) {
          window.location.reload();
        }
      });
  }
}
