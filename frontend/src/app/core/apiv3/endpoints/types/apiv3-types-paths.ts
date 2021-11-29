

import { TypeResource } from 'core-app/features/hal/resources/type-resource';
import { APIv3TypePaths } from 'core-app/core/apiv3/endpoints/types/apiv3-type-paths';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { CachableAPIV3Collection } from 'core-app/core/apiv3/cache/cachable-apiv3-collection';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';

export class APIv3TypesPaths extends CachableAPIV3Collection<TypeResource, APIv3TypePaths> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'types', APIv3TypePaths);
  }

  protected createCache():StateCacheService<TypeResource> {
    return new StateCacheService<TypeResource>(this.states.types);
  }
}
