

import {
  ConfirmDialogModalComponent,
  ConfirmDialogOptions,
} from 'core-app/shared/components/modals/confirm-dialog/confirm-dialog.modal';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { Injectable, Injector } from '@angular/core';

@Injectable()
export class ConfirmDialogService {
  constructor(readonly opModalService:OpModalService,
    readonly injector:Injector) {
  }

  /**
   * Confirm an action with an ng dialog with the given options
   */
  public confirm(options:ConfirmDialogOptions):Promise<void> {
    return new Promise<void>((resolve, reject) => {
      const confirmModal = this.opModalService.show(ConfirmDialogModalComponent, this.injector, { options });
      confirmModal.closingEvent.subscribe((modal:ConfirmDialogModalComponent) => {
        if (modal.confirmed) {
          resolve();
        } else {
          reject();
        }
      });
    });
  }
}
