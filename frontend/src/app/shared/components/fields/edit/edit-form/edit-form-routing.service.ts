

import { Transition } from '@uirouter/core';
import { Injectable } from '@angular/core';

@Injectable()
export class EditFormRoutingService {
  /**
   * Return whether the given transition is cancelled during the editing of this form
   *
   * @param transition The transition that is underway.
   * @return A boolean marking whether the transition should be blocked.
   */
  public blockedTransition(transition:Transition):boolean {
    // By default, don't allow any transitions to continue
    return true;
  }
}
