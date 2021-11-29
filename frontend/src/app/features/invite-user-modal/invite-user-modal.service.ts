

import { Injectable, EventEmitter } from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { InviteUserModalComponent } from './invite-user.component';

/**
 * This service triggers user-invite modals to clicks on elements
 * with the attribute [invite-user-modal-augment] set.
 */
@Injectable()
export class OpInviteUserModalService {
  public close = new EventEmitter<HalResource|HalResource[]>();

  constructor(
    protected opModalService:OpModalService,
    protected currentProjectService:CurrentProjectService,
  ) {
  }

  public open(projectId:string|null = this.currentProjectService.id) {
    const modal = this.opModalService.show(
      InviteUserModalComponent,
      'global',
      { projectId },
    );

    modal
      .closingEvent
      .subscribe((modal:InviteUserModalComponent) => {
        this.close.emit(modal.data);
      });
  }
}
