

import { Transition } from '@uirouter/core';
import { Injectable } from '@angular/core';
import { EditFormRoutingService } from 'core-app/shared/components/fields/edit/edit-form/edit-form-routing.service';

@Injectable()
export class WorkPackageEditFormRoutingService extends EditFormRoutingService {
  /**
   * Return whether the given transition is cancelled during the editing of this form
   *
   * @param transition The transition that is underway.
   * @return A boolean marking whether the transition should be blocked.
   */
  public blockedTransition(transition:Transition):boolean {
    const toState = transition.to();
    const fromState = transition.from();
    const fromParams = transition.params('from');
    const toParams = transition.params('to');

    // In new/copy mode, transitions to the same controller are allowed
    if (fromState.name && (/\.(new|copy)$/.exec(fromState.name))) {
      return !(toState.data && toState.data.allowMovingInEditMode);
    }

    // When editing an existing WP, transitions on the same WP id are allowed
    return toParams.workPackageId === undefined || toParams.workPackageId !== fromParams.workPackageId;
  }
}
