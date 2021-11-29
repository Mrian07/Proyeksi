

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { UserResource } from 'core-app/features/hal/resources/user-resource';

export class RootResource extends HalResource {
  public user:UserResource;
}
