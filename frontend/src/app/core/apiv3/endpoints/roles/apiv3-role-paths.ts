

import { RoleResource } from 'core-app/features/hal/resources/role-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class APIv3RolePaths extends CachableAPIV3Resource<RoleResource> {
  protected createCache():StateCacheService<RoleResource> {
    return new StateCacheService<RoleResource>(this.states.roles);
  }
}
