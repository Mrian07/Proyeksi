

import { CapabilityResource } from 'core-app/features/hal/resources/capability-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { Apiv3CapabilitiesPaths } from 'core-app/core/apiv3/endpoints/capabilities/apiv3-capabilities-paths';

export class Apiv3CapabilityPaths extends CachableAPIV3Resource<CapabilityResource> {
  protected createCache():StateCacheService<CapabilityResource> {
    return (this.parent as Apiv3CapabilitiesPaths).cache;
  }
}
