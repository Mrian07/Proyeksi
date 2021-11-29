

import { Apiv3CapabilityPaths } from 'core-app/core/apiv3/endpoints/capabilities/apiv3-capability-paths';
import { CapabilityResource } from 'core-app/features/hal/resources/capability-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { CachableAPIV3Collection } from 'core-app/core/apiv3/cache/cachable-apiv3-collection';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { CapabilityCacheService } from 'core-app/core/apiv3/endpoints/capabilities/capability-cache.service';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class Apiv3CapabilitiesPaths
  extends CachableAPIV3Collection<CapabilityResource, Apiv3CapabilityPaths>
  implements Apiv3ListResourceInterface<CapabilityResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'capabilities', Apiv3CapabilityPaths);
  }

  /**
   * Load a list of capabilities with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<CapabilityResource>> {
    return this
      .halResourceService
      .get<CollectionResource<CapabilityResource>>(this.path + listParamsString(params))
      .pipe(
        this.cacheResponse(),
      );
  }

  protected createCache():StateCacheService<CapabilityResource> {
    return new CapabilityCacheService(this.injector, this.states.capabilities);
  }
}
