

import { APIv3GettableResource, APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { States } from 'core-app/core/states/states.service';
import { HasId, StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { tap } from 'rxjs/operators';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export abstract class CachableAPIV3Collection<
  T extends HasId = HalResource,
  V extends APIv3GettableResource<T> = APIv3GettableResource<T>,
  X extends StateCacheService<T> = StateCacheService<T>,
  >
  extends APIv3ResourceCollection<T, V> {
  @InjectField() states:States;

  readonly cache:X = this.createCache();

  /**
   * Observe all value changes of the cache
   */
  public observeAll():Observable<T[]> {
    return this.cache.observeAll();
  }

  /**
   * Inserts a collection or single response to cache as an rxjs tap function
   */
  protected cacheResponse<R>():(source:Observable<R>) => Observable<R> {
    return (source$) => source$.pipe(
      tap(
        (response:R) => {
          if (response instanceof CollectionResource) {
            response.elements?.forEach(this.touch.bind(this));
          } else if (response instanceof HalResource) {
            this.touch(response as any);
          }
        },
      ),
    );
  }

  /**
   * Update a single resource
   */
  protected touch(resource:T):void {
    this.cache.updateFor(resource);
  }

  /**
   * Creates the cache state instance
   */
  protected abstract createCache():X;
}
