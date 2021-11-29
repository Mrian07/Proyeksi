

import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { Apiv3UserPreferencesPaths } from 'core-app/core/apiv3/endpoints/users/apiv3-user-preferences-paths';

export class APIv3UserPaths extends CachableAPIV3Resource<UserResource> {
  readonly avatar = this.subResource('avatar');

  readonly preferences = this.subResource('preferences', Apiv3UserPreferencesPaths);

  protected createCache():StateCacheService<UserResource> {
    return new StateCacheService<UserResource>(this.states.users);
  }
}
