

import { StateObject } from '@uirouter/core/lib/state/stateObject';
import { DeviceService } from 'core-app/core/browser/device.service';
import {
  TargetState,
  Transition,
} from '@uirouter/core';

export function mobileGuardActivated(state:StateObject):boolean {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access,@typescript-eslint/no-unsafe-return
  return state.data && state.data.mobileAlternative && (new DeviceService()).isMobile;
}

export function redirectToMobileAlternative(transition:Transition):TargetState {
  const $state = transition.router.stateService;
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access,@typescript-eslint/no-unsafe-assignment
  const alternativeRoute:string = transition.to().data.mobileAlternative;

  return $state.target(alternativeRoute, transition.params(), {});
}
