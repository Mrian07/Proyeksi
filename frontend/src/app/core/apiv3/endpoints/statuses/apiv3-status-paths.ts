

import { StatusResource } from 'core-app/features/hal/resources/status-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class APIv3StatusPaths extends CachableAPIV3Resource<StatusResource> {
  protected createCache():StateCacheService<StatusResource> {
    return new StateCacheService<StatusResource>(this.states.statuses);
  }
}
