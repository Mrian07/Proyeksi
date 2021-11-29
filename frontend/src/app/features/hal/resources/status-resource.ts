

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { InputState } from 'reactivestates';

export class StatusResource extends HalResource {
  isClosed:boolean;

  isDefault:boolean;

  public get state():InputState<this> {
    return this.states.statuses.get(this.href as string) as any;
  }
}
