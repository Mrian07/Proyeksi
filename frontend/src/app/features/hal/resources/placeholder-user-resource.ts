

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { InputState } from 'reactivestates';

export class PlaceholderUserResource extends HalResource {
  // Links
  public updateImmediately:HalResource;

  public delete:HalResource;

  public showUser:HalResource;

  public get state():InputState<this> {
    return this.states.placeholderUsers.get(this.href as string) as any;
  }

  public get showUserPath() {
    return this.showUser ? this.showUser.$link.href : null;
  }
}
