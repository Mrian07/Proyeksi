

import { InputState } from 'reactivestates';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class UserResource extends HalResource {
  // Properties
  public login:string;

  public firstName:string;

  public lastName:string;

  public email:string;

  public avatar:string;

  public status:string;

  // Links
  public lock:HalResource;

  public unlock:HalResource;

  public delete:HalResource;

  public showUser:HalResource;

  public static get active_user_statuses() {
    return ['active', 'registered'];
  }

  public get state():InputState<this> {
    return this.states.users.get(this.href as string) as any;
  }

  public get showUserPath() {
    return this.showUser ? this.showUser.$link.href : null;
  }

  public get isActive() {
    return UserResource.active_user_statuses.indexOf(this.status) >= 0;
  }
}
