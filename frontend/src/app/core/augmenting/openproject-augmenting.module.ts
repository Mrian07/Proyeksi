

import { NgModule } from '@angular/core';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { OpModalWrapperAugmentService } from 'core-app/shared/components/modal/modal-wrapper-augment.service';
import { PathScriptAugmentService } from 'core-app/core/augmenting/services/path-script.augment.service';

@NgModule({
  imports: [OpenprojectModalModule],
  providers: [PathScriptAugmentService],
})
export class OpenprojectAugmentingModule {
  constructor(modalWrapper:OpModalWrapperAugmentService,
    pathScript:PathScriptAugmentService) {
    // Setup augmenting services
    modalWrapper.setupListener();
    pathScript.loadRequiredScripts();
  }
}
