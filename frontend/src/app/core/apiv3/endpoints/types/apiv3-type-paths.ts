

import { TypeResource } from 'core-app/features/hal/resources/type-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { APIv3TypesPaths } from 'core-app/core/apiv3/endpoints/types/apiv3-types-paths';

export class APIv3TypePaths extends CachableAPIV3Resource<TypeResource> {
  protected createCache():StateCacheService<TypeResource> {
    return (this.parent as APIv3TypesPaths).cache;
  }
}
